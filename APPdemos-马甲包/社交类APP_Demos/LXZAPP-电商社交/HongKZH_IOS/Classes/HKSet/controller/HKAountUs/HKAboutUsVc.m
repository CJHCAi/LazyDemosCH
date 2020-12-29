//
//  HKAboutUsVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAboutUsVc.h"
#import "HK_AboutHeaderView.h"
#import "HKWebInfoVc.h"
@interface HKAboutUsVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tabView;
@property (nonatomic, strong)NSMutableArray *data;
@property (nonatomic, strong)HK_AboutHeaderView *head;
@property (nonatomic, strong)UILabel *companyLabel;
@property (nonatomic, strong)UILabel *copyrightLabel;
@end

@implementation HKAboutUsVc

-(NSMutableArray *)data {
    if (!_data) {
        _data =[[NSMutableArray alloc] init];
    }
    return _data;
}
-(UITableView *)tabView {
    if (!_tabView) {
        _tabView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.scrollEnabled = NO;
        _tabView.tableHeaderView = self.head;
        _tabView.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        _tabView.tableFooterView = [[UIView alloc] init];
    }
    return _tabView;
}
-(HK_AboutHeaderView *)head {
    if (!_head) {
        UIImage *ima =[UIImage imageNamed:@"logo"];
        CGFloat h = ima.size.height + 30 +20+20;
        _head =[[HK_AboutHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,h)];
    }
    return _head;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"TB"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier:@"TB"];
    }
    cell.accessoryType  =UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:PingFangSCRegular size:15.f];
    cell.textLabel.textColor = RGB(51, 51, 51);
    NSString * titles =self.data[indexPath.row];
    cell.textLabel.text = titles;
    if (indexPath.row) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V %@",[AppUtils currentVersion]];
        cell.detailTextLabel.font =PingFangSCRegular13;
        cell.detailTextLabel.textColor =[UIColor colorFromHexString:@"666666"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==0) {
        HKWebInfoVc *webVc =[[HKWebInfoVc alloc] init];
        webVc.webTitleIndex = 0;
        [self.navigationController pushViewController:webVc animated:YES];
    }else {
     //版本更新
       // [EasyShowTextView showText:@"APPStore升级版本"];
    }
}
-(void)initData {
    NSArray * listData =@[@"用户协议",@"版本信息"];
    [self.data addObjectsFromArray:listData];
    [self.tabView reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"关于我们";
    self.showCustomerLeftItem= YES;
    [self.view addSubview:self.tabView];
    [self initData];
    [self.view addSubview:self.copyrightLabel];
    [self.view addSubview:self.companyLabel];
  
}
-(UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMinY(self.copyrightLabel.frame)-5-10,kScreenWidth,10)
                        ];
          [AppUtils getConfigueLabel:_companyLabel font:PingFangSCRegular13 aliment:NSTextAlignmentCenter textcolor:RGB(153,153,153) text:@"北京鸿坤泽厚信息技术有限公司 版权所有"];
    }
    return _companyLabel;
}
-(UILabel *)copyrightLabel {
    if (!_copyrightLabel) {
        _copyrightLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,kScreenHeight-NavBarHeight-StatusBarHeight -10 -10-SafeAreaBottomHeight,kScreenWidth,10)];
        [AppUtils getConfigueLabel:_copyrightLabel font:PingFangSCRegular13 aliment:NSTextAlignmentCenter textcolor:RGB(153,153,153) text:@"Copyright©2017-2018 Hongkunzehou.All Rights Reseverd."];
    }
    return _copyrightLabel;
}




@end
