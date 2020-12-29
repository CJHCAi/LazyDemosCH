//
//  HK_IncomeDetailController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_IncomeDetailController.h"
#import "HK_baseSubDetailVc.h"
#import "ZWMSegmentController.h"
@interface HK_IncomeDetailController ()
@property (nonatomic, strong) ZWMSegmentController *segmentVC;

@end

@implementation HK_IncomeDetailController
-(void)initNav {
    self.navigationItem.title =@"明细";
    [self setShowCustomerLeftItem:YES];
}
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    
    [self creatSubViewControllers];
}
-(void)creatSubViewControllers {
    NSMutableArray *vcArray=[[NSMutableArray alloc] init];
    //标题数组
    NSArray *titleArr =@[@"全部",@"收入",@"支出",@"冻结/解冻"];
    for (int i=0; i<titleArr.count;i++) {
        HK_baseSubDetailVc *pageVc = [[HK_baseSubDetailVc alloc] init];
        pageVc.status =i;
        [vcArray addObject:pageVc];
    }
 self.segmentVC = [[ZWMSegmentController alloc] initWithFrame:self.view.bounds titles:titleArr];
    
    self.segmentVC.segmentView.segmentTintColor = [UIColor colorFromHexString:@"333333"];
    self.segmentVC.segmentView.segmentNormalColor =[UIColor colorFromHexString:@"7c7c7c"];
    self.segmentVC.viewControllers = vcArray;
    if (vcArray.count==1) {
        
        self.segmentVC.segmentView.style = ZWMSegmentStyleDefault;
    }else {
         self.segmentVC.segmentView.style = ZWMSegmentStyleFlush;
    }
    //指示条和按钮文字对其
    [self addSegmentController:self.segmentVC];
    [self.segmentVC  setSelectedAtIndex:0];
    
}


@end
