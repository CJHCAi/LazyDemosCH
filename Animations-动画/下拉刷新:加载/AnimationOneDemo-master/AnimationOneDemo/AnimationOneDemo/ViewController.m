//
//  ViewController.m
//  AnimationOneDemo
//
//  Created by zhenglanchun on 16/3/11.
//  Copyright © 2016年 dothisday. All rights reserved.
//

#import "ViewController.h"
#import "YGLoadingView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(showLoading)];
    
    YGLoadingView *pullLoading = [[YGLoadingView alloc]initPullLoadingWithScrollerView:self.tableview refreshingBlock:^(YGLoadingView *refreshView){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [refreshView hideLoading];
        });
    }];
}
-(void)showLoading{
    
    YGLoadingView *loadingView = [[YGLoadingView alloc]initCenterLoadingWithSuperView:self.view];
    [loadingView startLoading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [loadingView hideLoading];
    });
}



@end



