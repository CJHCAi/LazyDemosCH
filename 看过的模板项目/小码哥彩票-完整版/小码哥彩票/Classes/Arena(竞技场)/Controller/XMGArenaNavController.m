//
//  XMGArenaNavController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/28.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGArenaNavController.h"

@interface XMGArenaNavController ()

@end

@implementation XMGArenaNavController

+ (void)initialize
{
    // 获取当前类下面的所有导航条去设置
      UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
      [bar setBackgroundImage:[UIImage imageWithStretchableImageName:@"NLArenaNavBar64"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
