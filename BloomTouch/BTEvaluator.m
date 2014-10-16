//
//  BTEvaluator.m
//  BloomTouch
//
//  Created by Nathan Burgers on 4/6/14.
//  Copyright (c) 2014 Nathan Burgers. All rights reserved.
//

#import "BTEvaluator.h"

@implementation BTEvaluator

- (id)init
{
    if (self = [super init]) {
        _queue = [NSMutableArray array];
        _reduction = @(0);
        
    }
    return self;
}

- (void)queue:(NSDictionary *)data withProgress:(void (^)(NSDictionary *))progress onComplete:(void (^)(NSObject *))result
{
    
//    [self.queue addObjectsFromArray:data];
    NSArray *datum = data[@"data"];
    NSNumber *size = data[@"size"];
    NSNumber *done = data[@"computed"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSUInteger i=0; i<datum.count; i++) {
            
            NSObject *mapValue = self.mapFunction([[SNEval prelude] mutableCopy], @[datum[i]]);
            self.reduction = self.reduceFunction([[SNEval prelude] mutableCopy], @[self.reduction, mapValue]);
            

            dispatch_async(dispatch_get_main_queue(), ^{
                progress(@{@"size":size,
                           @"computed":done,
                           @"result":self.reduction
                           });
                if ([done isEqualToNumber: size]) {
                    result(self.reduction);
                }
            });
        }
        NSLog(@"reduction: %@", self.reduction);
    });
}

@end
