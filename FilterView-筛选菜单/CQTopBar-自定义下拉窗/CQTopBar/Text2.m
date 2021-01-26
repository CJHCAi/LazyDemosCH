//
//  Text2.m
//  CQTopBar
//
//  Created by yto on 2018/1/22.
//  Copyright © 2018年 CQ. All rights reserved.
//

#import "Text2.h"
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface Text2 ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation Text2

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"Text2Cell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"Text%zd",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [NSString stringWithFormat:@"Text%zd",indexPath.row];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:str,@"text", nil];
    NSNotification *notification = [NSNotification notificationWithName:NSStringFromClass([Text2 class]) object:nil userInfo:dict];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
