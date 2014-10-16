//
//  BTClientController.h
//  BloomTouch
//
//  Created by Nathan Burgers on 4/5/14.
//  Copyright (c) 2014 Nathan Burgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void (^BTDataAcquisitionBlock)(NSData *data);

@interface BTClientController : NSObject <CBPeripheralManagerDelegate>
@property (readonly, nonatomic) BTDataAcquisitionBlock callback;
@property (readonly, nonatomic) CBPeripheralManager *peripheralManager;
@property (readonly, nonatomic) CBMutableCharacteristic *clientCharacteristic;
@property (readonly, nonatomic) CBMutableCharacteristic *dataCharacteristic;
@property (readonly, nonatomic) NSMutableData *currentData;

@property CBCentral *central;
- (id) initWithCallback:(BTDataAcquisitionBlock)callback;

- (void)sendFinalResult:(NSObject *)object;

@end
