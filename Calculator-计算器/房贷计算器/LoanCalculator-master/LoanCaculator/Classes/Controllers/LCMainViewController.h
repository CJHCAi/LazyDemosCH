//
//  LCMainViewController.h
//  LoanCaculator
//
//  Created by lingyi xu on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCaculatorModel.h"
#import "LCOptionsViewController.h"
#import "LCResultViewController.h"

@interface LCMainViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>
{
#pragma mark - Some UI
    UIScrollView *_scrollView;
    UITableView *_tableView;
    
    LCCaculatorModel *_caculatorModel;
    
    BOOL isIphone5;
}

@end
