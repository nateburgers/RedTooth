//
//  BTLoadBalancer.m
//  BloomTouch
//
//  Created by Nathan Burgers on 4/5/14.
//  Copyright (c) 2014 Nathan Burgers. All rights reserved.
//

#import "BTLoadBalancer.h"

@implementation BTLoadBalancer

+ (NSString *)serviceName
{
    return @"bt-balance";
}

- (id)init
{
    if (self = [super init]) {
        _dataSet = [NSMutableArray array];
        _peerId = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
        _session = [[MCSession alloc] initWithPeer:_peerId];
        _session.delegate = self;
        _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerId serviceType:[BTLoadBalancer serviceName]];
        _browser.delegate = self;
        [_browser startBrowsingForPeers];
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerId discoveryInfo:nil serviceType:[BTLoadBalancer serviceName]];
        _advertiser.delegate = self;
        [_advertiser startAdvertisingPeer];
    }
    return self;
}

- (NSUInteger)workload
{
    return [self.dataSet count];
}

- (void)send:(MCPeerID *)peer dump:(NSDictionary *)data
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    [self.session sendData:jsonData toPeers:@[peer] withMode:MCSessionSendDataReliable error:nil];
}

- (NSDictionary *)selectorsByMessage
{
    return @{@"workload": NSStringFromSelector(@selector(receive:workload:)),
             @"dump": NSStringFromSelector(@selector(receive:dump:))
             };
}

- (void)receive:(MCPeerID *)peer workload:(NSDictionary *)workloadData
{
    NSNumber *workloadNumber = [workloadData objectForKey:@"workload"];
    NSUInteger workload = [workloadNumber unsignedIntegerValue];
    NSUInteger workloadDifference = self.workload - workload;
    if (workloadDifference > 0 ) {
        NSUInteger sizeToSend = workloadDifference / 2;
        NSArray *dataToSend = [self.dataSet subarrayWithRange:NSMakeRange(0, sizeToSend)];
        _dataSet = [[self.dataSet subarrayWithRange:NSMakeRange(sizeToSend, self.dataSet.count - sizeToSend)] mutableCopy];
        NSDictionary *messageToSend = @{@"message":@"dump", @"dump":dataToSend};
        [self send:peer dump:messageToSend];
    }
}

- (void)receive:(MCPeerID *)peer dump:(NSDictionary *)data
{
    NSArray *dump = [data objectForKey:@"dump"];
    [self.dataSet addObjectsFromArray:dump];
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    invitationHandler(YES, self.session);
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateConnected:
            [self.session connectPeer:peerID withNearbyConnectionData:nil];
            break;
        case MCSessionStateConnecting:
            // pass
            break;
        case MCSessionStateNotConnected:
            [self.session connectPeer:peerID withNearbyConnectionData:nil];
            break;
        default:
            break;
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSString *message = [json objectForKey:@"message"];
    NSString *selectorName = [self.selectorsByMessage objectForKey:message];
    if (selectorName) {
        [self performSelector:NSSelectorFromString(selectorName) withObject:peerID withObject:json];
    }
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    //pass
}
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    //pass
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    //pass
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"found peer: %@", peerID.displayName);
    [self.browser invitePeer:peerID toSession:self.session withContext:nil timeout:30.0];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    //pass
}

@end
