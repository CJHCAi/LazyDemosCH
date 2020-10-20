//
//  SDDiscoverTableViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/10.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDDiscoverTableViewController.h"
#import "SDTimeLineTableViewController.h"

@interface SDDiscoverTableViewController ()

@end

@implementation SDDiscoverTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    
    return [[UIStoryboard storyboardWithName:@"SDDiscoverTableViewController" bundle:nil] instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

@end
