//
//  StudioStateViewController.h
//  BackPacker
//
//  Created by 聂 亚杰 on 13-4-11.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
@interface StudioStateViewController : UITableViewController<ASIHTTPRequestDelegate>
{
    NSMutableArray *requetStates;
}
@property (strong, nonatomic) IBOutlet UITableView *studioStateTableview;
@property(nonatomic,retain)NSURL *StudioAllStateURL;
@property (nonatomic,retain)NSMutableArray *stateList;
@property(nonatomic,retain)NSMutableArray *portraitArray;
@end
