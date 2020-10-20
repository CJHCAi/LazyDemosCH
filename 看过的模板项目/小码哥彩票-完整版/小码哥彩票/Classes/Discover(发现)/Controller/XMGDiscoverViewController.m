//
//  XMGDiscoverViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGDiscoverViewController.h"

@interface XMGDiscoverViewController ()

@end

@implementation XMGDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    UIViewController *vc = segue.destinationViewController;
    
    vc.hidesBottomBarWhenPushed = YES;
}

@end