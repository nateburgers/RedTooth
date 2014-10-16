//
//  BTAnalyticsViewController.h
//  BloomTouch
//
//  Created by Nathan Burgers on 4/6/14.
//  Copyright (c) 2014 Nathan Burgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTAnalyticsViewController : UIViewController

@property (nonatomic,retain) IBOutlet UIView *viewFromNib;
@property (nonatomic,retain) IBOutlet UILabel *dataSetLabel;
@property (nonatomic,retain) IBOutlet UILabel *dataSizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *dataComputedLabel;
@property (nonatomic, retain) IBOutlet UILabel *dataToComputeLabel;
@property (nonatomic, retain) IBOutlet UILabel *resultLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;

@end
