//
//  Text3.m
//  CQTopBar
//
//  Created by yto on 2018/1/22.
//  Copyright © 2018年 CQ. All rights reserved.
//

#import "Text3.h"
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface Text3 ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation Text3

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 350)];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Text3Cell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"text%zd",indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [NSString stringWithFormat:@"text%zd",indexPath.row];
    NSNotification *notification =[NSNotification notificationWithName:NSStringFromClass([Text3 class]) object:str];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
