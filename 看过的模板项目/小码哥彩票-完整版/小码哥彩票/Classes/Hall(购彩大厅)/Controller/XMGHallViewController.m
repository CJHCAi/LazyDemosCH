//
//  XMGHallViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGHallViewController.h"

#import "XMGCover.h"
#import "XMGActiveMenu.h"
#import "XMGDownMenu.h"

#import "XMGMenuItem.h"

@interface XMGHallViewController ()<XMGActiveMenuDelegate>

@property (nonatomic, weak) XMGDownMenu *downMenu;

@property (nonatomic, assign) BOOL isPopMenu;

@end

@implementation XMGHallViewController

- (XMGDownMenu *)downMenu
{
    if (_downMenu == nil) {
        
        XMGMenuItem *item = [XMGMenuItem itemWithImage:[UIImage imageNamed:@"Development"] title:nil];
        XMGMenuItem *item1 = [XMGMenuItem itemWithImage:[UIImage imageNamed:@"Development"] title:nil];
        XMGMenuItem *item2 = [XMGMenuItem itemWithImage:[UIImage imageNamed:@"Development"] title:nil];
        XMGMenuItem *item3 = [XMGMenuItem itemWithImage:[UIImage imageNamed:@"Development"] title:nil];
        XMGMenuItem *item4 = [XMGMenuItem itemWithImage:[UIImage imageNamed:@"Development"] title:nil];
        XMGMenuItem *item5 = [XMGMenuItem itemWithImage:[UIImage imageNamed:@"Development"] title:nil];
        
        NSArray *items = @[item,item1,item2,item3,item4,item5];
        
        // 弹出黑色菜单
        _downMenu = [XMGDownMenu showInView:self.view items:items oriY:0];
        
    }
    return _downMenu;
}

// navigationItem不能设置导航条背景颜色
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"购彩大厅";
    
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriRenderingImage:@"CS50_activity_image"] style:UIBarButtonItemStylePlain target:self action:@selector(active)];
   
    // 添加右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriRenderingImage:@"Development"] style:UIBarButtonItemStylePlain target:self action:@selector(popMenu)];
    
}
#pragma mark - 点击菜单按钮的时候调用
- (void)popMenu
{
    if (_isPopMenu == NO) {
        
        [self downMenu];
        
    }else{
        // 隐藏菜单
        [self.downMenu hide];
        
    }
    
    _isPopMenu = !_isPopMenu;
    
}
#pragma mark - 点击活动
- (void)active
{
    // 弹出蒙版
    NSLog(@"点击活动");
    
    [XMGCover show];
    
    // 弹出活动菜单
    XMGActiveMenu *menu = [XMGActiveMenu showInPoint:self.view.center];
    
    menu.delegate = self;
    
}

#pragma mark - XMGActiveMenu代理方法
// 点击活动菜单的关闭按钮的时候调用
- (void)activeMenuDidClickCloseBtn:(XMGActiveMenu *)menu
{
    
    [XMGActiveMenu hideInPoint:CGPointMake(44, 44) completion:^{
        [XMGCover hide];
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


@end
