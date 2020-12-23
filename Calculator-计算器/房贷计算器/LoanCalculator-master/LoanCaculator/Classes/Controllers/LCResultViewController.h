//
//  LCResultViewControllerViewController.h
//  LoanCaculator
//
//  Created by lingyi xu on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCaculatorModel.h"

@interface LCResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *_scrollView;
    UITableView *_tableView;
    
    LCCaculatorModel *_caculatorModel;
}

@end
