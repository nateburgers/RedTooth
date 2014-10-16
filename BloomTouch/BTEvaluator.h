//
//  BTEvaluator.h
//  BloomTouch
//
//  Created by Nathan Burgers on 4/6/14.
//  Copyright (c) 2014 Nathan Burgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNEval.h"

@interface BTEvaluator : NSObject

@property (readwrite, atomic, copy) SNProcedure mapFunction;
@property (readwrite, atomic, copy) SNProcedure reduceFunction;
@property (readonly, nonatomic) NSMutableArray *queue;
@property (readonly, nonatomic) NSMutableArray *mapQueue;
@property (readonly, nonatomic) NSMutableArray *reduceQueue;

@property NSObject *reduction;
@property NSArray *cache;

- (void) queue:(NSDictionary *)data withProgress:(void (^)(NSDictionary *))progress onComplete:(void (^)(NSObject *))result;

@end
