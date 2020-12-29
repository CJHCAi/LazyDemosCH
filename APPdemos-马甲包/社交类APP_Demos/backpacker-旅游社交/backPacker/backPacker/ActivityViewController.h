//
//  ActivityViewController.h
//  BackPacker
//
//  Created by 聂 亚杰 on 13-4-10.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
@interface ActivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
@property (nonatomic,retain)NSString *activityBaseURLString;
@property (nonatomic,retain)NSString *userActivityBaseURLString;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment_activity;
@property (nonatomic,retain)NSMutableArray *activityList;
- (IBAction)activitySegmentPressed:(id)sender;
@end
