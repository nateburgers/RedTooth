//
//  BTAppDelegate.h
//  BloomTouch
//
//  Created by Nathan Burgers on 4/5/14.
//  Copyright (c) 2014 Nathan Burgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTAnalyticsViewController;
@class BTLoadBalancer;
@class BTClientController;
@class BTEvaluator;
@interface BTAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (readonly, nonatomic) BTAnalyticsViewController *viewController;
@property (readonly, strong, nonatomic) BTLoadBalancer *loadBalancer;
@property (readonly, nonatomic) BTClientController *clientController;
@property (readonly, nonatomic) BTEvaluator *evaluator;
@property (strong, nonatomic) UIWindow *window;

@property (readonly, nonatomic) NSMutableArray *dataSet;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
