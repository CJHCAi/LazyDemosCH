//
//  HomeViewController.h
//  IStone
//
//  Created by 胡传业 on 14-7-20.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//



#import <UIKit/UIKit.h>

#import "REFrostedViewController.h"

#import "HMSegmentedControl.h"

#import "FHSegmentedViewController.h"

#import "Table_1Controller.h"
#import "Table_2Controller.h"

//#import "XHTwitterPaggingViewer.h"

@interface HomeViewController : FHSegmentedViewController <UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) UISegmentedControl *segmentedControl;

-(IBAction)showMenu;

@property (strong, nonatomic) Table_1Controller *table_1Controller;
@property (strong, nonatomic) Table_2Controller *table_2Controller;

@end
