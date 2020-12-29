//
//  ActivityDatePickerViewController.h
//  BackPacker
//
//  Created by 聂 亚杰 on 13-5-10.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
#import "NewActivityTableViewController.h"

@interface ActivityDatePickerViewController : UIViewController

@property(nonatomic, retain) id<PassValueDelegate>passValueDelegate;


@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *datePicker;
@property (strong, nonatomic) IBOutlet UIView *buttonBackgroundView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *OkButton;
@property (strong,nonatomic)IBOutlet NSMutableArray *yearArray;
@property (strong,nonatomic)IBOutlet NSMutableArray *monthArray;
@property (strong,nonatomic)IBOutlet NSMutableArray *dayArray;

@property (nonatomic,retain)IBOutlet NSMutableArray *days;

//标明是哪一个Button触发的此pickerView，0代表活动开始时间button，1代表是报名截止日期触发的
@property (nonatomic,retain)NSString *launchB;

@property (nonatomic,retain)NewActivityTableViewController *activityVC;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)OkPressed:(id)sender;

@end
