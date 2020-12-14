//
//  YTSettingViewController.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/10.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTSettingViewController.h"

@interface YTSettingViewController ()

@end

@implementation YTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topline"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *titleAttr = @{
                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                };
    [self.navigationController.navigationBar setTitleTextAttributes:titleAttr];

    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"取消"
                                                                              target:self
                                                                              action:@selector(cancel)];
    
    
    [self add0SectionItems];
    
    
    
    
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems
{
    WeakSelf;
    // 1.1.自动追更
    ZFSettingItem *push = [ZFSettingItem itemWithIcon:nil title:@"自动追更" type:ZFSettingItemTypeArrow];
    //cell点击事件
    push.operation = ^{
//        ZFPushNoticeViewController *notice = [[ZFPushNoticeViewController alloc] init];
//        [weakSelf.navigationController pushViewController:notice animated:YES];
    };
    
    // 1.2.检查书籍更新
    ZFSettingItem *shake = [ZFSettingItem itemWithIcon:nil title:@"检查书籍更新" type:ZFSettingItemTypeArrow];
    //开关事件
    shake.operation = ^{
        NSLog(@"声音提示");
    };
    
    ZFSettingGroup *group = [[ZFSettingGroup alloc] init];
    //group.header = @"基本设置";
    group.items = @[push, shake];
    [_allGroups addObject:group];
}

- (void)cencel{

}


@end
