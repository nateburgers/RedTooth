//
//  BTClientController.m
//  BloomTouch
//
//  Created by Nathan Burgers on 4/5/14.
//  Copyright (c) 2014 Nathan Burgers. All rights reserved.
//

#import "BTClientController.h"
#import "service.h"

@implementation BTClientController

- (id)initWithCallback:(BTDataAcquisitionBlock)callback
{
    if (self = [super init]) {
        _currentData = [[NSMutableData alloc] initWithBytes:nil length:0];
        _callback = callback;
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        _peripheralManager.delegate = self;
        
        _clientCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:CLIENT_RESULT_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
        
        _dataCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:CLIENT_RECEIPT_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyWriteWithoutResponse value:nil permissions:CBAttributePermissionsWriteable];
    }
    return self;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"client updating state");
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"client online");
        
        CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:SERVICE_UUID] primary:YES];
        [service setCharacteristics:@[self.clientCharacteristic, self.dataCharacteristic]];
        [self.peripheralManager addService:service];
        
        [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:SERVICE_UUID]]}];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"receiving subscription notice");
    self.central = central;
//    NSString *message = @"hey there from the other side";
//    [self.peripheralManager updateValue:[message dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.clientCharacteristic onSubscribedCentrals:nil];
}

- (void)sendFinalResult:(NSObject *)object
{
    NSLog(@"sending final result");
    [self.peripheralManager updateValue:[NSJSONSerialization dataWithJSONObject:@[object] options:0 error:nil] forCharacteristic:self.clientCharacteristic onSubscribedCentrals:@[self.central]];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    for (CBATTRequest *request in requests) {
        if (request.value.length > 0) {
            [self.currentData appendData:request.value];
            char lastChar;
            [request.value getBytes:&lastChar range:NSMakeRange(request.value.length-1, 1)];
            if (lastChar == 0) {
                self.callback([self.currentData subdataWithRange:NSMakeRange(0, self.currentData.length-1)]);
                [self.currentData setLength:0];
            }
        }
    }
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    
}

@end
