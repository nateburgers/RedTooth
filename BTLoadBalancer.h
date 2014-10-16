//
//  BTLoadBalancer.h
//  BloomTouch
//
//  Created by Nathan Burgers on 4/5/14.
//  Copyright (c) 2014 Nathan Burgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface BTLoadBalancer : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate>
@property (readonly, nonatomic) NSMutableArray *dataSet;
@property (readonly, nonatomic) MCPeerID *peerId;
@property (readonly, nonatomic) MCSession *session;
@property (readonly, nonatomic) MCNearbyServiceAdvertiser *advertiser;
@property (readonly, nonatomic) MCNearbyServiceBrowser *browser;

+ (NSString *)serviceName;

- (NSUInteger) workload;

- (void) send:(MCPeerID *)peer dump:(NSDictionary *)data;
- (NSDictionary *)selectorsByMessage;
- (void) receive:(MCPeerID *)peer workload:(NSDictionary *)workloadData;
- (void) receive:(MCPeerID *)peer dump:(NSDictionary *)data;

@end
