//
//  SDChatTableViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/13.
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

#import "SDChatTableViewController.h"

#import "GlobalDefines.h"

#import "SDChatTableViewCell.h"
#import "SDAnalogDataGenerator.h"
#import "SDWebViewController.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#define kChatTableViewControllerCellId @"ChatTableViewController"

@implementation SDChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDataWithCount:30];
    
    CGFloat rgb = 240;
    self.tableView.backgroundColor = SDColor(rgb, rgb, rgb, 1);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SDChatTableViewCell class] forCellReuseIdentifier:kChatTableViewControllerCellId];
}

- (void)setupDataWithCount:(NSInteger)count
{
    for (int i = 0; i < count; i++) {
        SDChatModel *model = [SDChatModel new];
        model.messageType = arc4random_uniform(2);
        if (model.messageType) {
            model.iconName = [SDAnalogDataGenerator randomIconImageName];
            if (arc4random_uniform(10) > 5) {
                int index = arc4random_uniform(5);
                model.imageName = [NSString stringWithFormat:@"test%d.jpg", index];
            }
        } else {
            if (arc4random_uniform(10) < 5) {
                int index = arc4random_uniform(5);
                model.imageName = [NSString stringWithFormat:@"test%d.jpg", index];
            }
            model.iconName = @"2.jpg";
        }
        
        
        model.text = [SDAnalogDataGenerator randomMessage];
        [self.dataArray addObject:model];
    }
}

#pragma mark - tableview delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatTableViewControllerCellId];
    cell.model = self.dataArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [cell setDidSelectLinkTextOperationBlock:^(NSString *link, MLEmojiLabelLinkType type) {
        if (type == MLEmojiLabelLinkTypeURL) {
            [weakSelf.navigationController pushViewController:[SDWebViewController webViewControllerWithUrlString:link] animated:YES];
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [self.tableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[SDChatTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@">>>>>  %@", [self.dataArray[indexPath.row] text]);
}

@end
