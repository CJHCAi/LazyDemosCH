//
//  LCOptionsViewController.h
//  LoanCaculator
//
//  Created by lingyi xu on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCaculatorModel.h"
#import "LCMainViewController.h"

@interface LCOptionsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSInteger _whichOption;
    NSArray *_currentData;
    NSString *_currentSelect;
    
    LCCaculatorModel *_caculatorModel;
}

@property (nonatomic, assign) NSInteger whichOption;
@property (nonatomic, copy) NSString *currentSelect;

@end