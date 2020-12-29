//
//  HKShopMessageVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShopMessageVc.h"
#import "HKAcountMessageCell.h"
#import "HKCounFooterView.h"
#import "HKShopSysytemMessageCell.h"
@interface HKShopMessageVc ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKCounFooterView *foo;

@end

@implementation HKShopMessageVc
-(HKCounFooterView *)foo {
    if (!_foo) {
        _foo =[[HKCounFooterView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,25)];
    }
    return _foo;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.backgroundColor = MainColor
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.tableFooterView = self.foo;
        if (self.messageType ==1) {
            [_tableView registerClass:[HKShopSysytemMessageCell class] forCellReuseIdentifier:@"system"];
        }else {
               [_tableView registerClass:[HKAcountMessageCell class] forCellReuseIdentifier:@"message"];
        }
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.messageType ==1) {
        HKShopSysytemMessageCell * cell =[tableView dequeueReusableCellWithIdentifier:@"system" forIndexPath:indexPath];
        return cell;
    }
    HKAcountMessageCell * cell =[tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.messageType ==1) {
        return 170;
    }
    return 128;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.messageType ==1) {
        self.title =@"系统消息";
    }else {
        self.title =@"账户消息";
    }
    self.showCustomerLeftItem = YES;
    [self.view addSubview:self.tableView];
   
}


@end
