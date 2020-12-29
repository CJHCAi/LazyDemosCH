//
//  NewActivityTableViewController.h
//  BackPacker
//
//  Created by 聂 亚杰 on 13-5-9.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableView.h"
#import "PassValueDelegate.h"
#import "ASIHTTPRequest.h"
@interface NewActivityTableViewController : UITableViewController<TouchTableViewDelegate,PassValueDelegate,ASIHTTPRequestDelegate>

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *typeTextField;
@property (strong, nonatomic) IBOutlet UITextField *activityDuration;
@property (strong, nonatomic) IBOutlet UITextField *maxNum;
@property (strong, nonatomic) IBOutlet CustomTableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *acitivityStartDate;
@property (strong, nonatomic) IBOutlet UILabel *jionEndTime;

@property (nonatomic,retain)NSURL *commitActivityBaseURLString;
- (IBAction)newActivityFinished:(id)sender;
- (IBAction)newActivityClosed:(id)sender;
- (IBAction)editDidEnd:(id)sender;
- (IBAction)nextEdit:(id)sender;
- (IBAction)editDate:(id)sender;

@end
