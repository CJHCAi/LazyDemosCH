//
//  HKPushViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPushViewController.h"
#import "ZSDBManageBaseModel.h"
#import "HKPushModel.h"
#import "DatabaseToll.h"
#import "HKPushTableViewCell.h"
#import "HKBaseTableViewCell.h"
#import "HKPraiseViewController.h"
@interface HKPushViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataArray;
@end

@implementation HKPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setUI];
}
-(void)setUI{
    self.title = @"圈子通知";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else{
    return self.dataArray.count;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor =[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKBaseTableViewCell*cell = [HKBaseTableViewCell baseTableViewCellWithTableView:tableView];
        if (indexPath.row == 0) {
            cell.title = @"点赞";
            cell.image = @"qzdz";
        }else{
            cell.title = @"转发";
            cell.image = @"qzdzhf";
        }
        return cell;
    }
    HKPushTableViewCell*cell = [HKPushTableViewCell pushTableViewCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HKPraiseViewController*praVc = [[HKPraiseViewController alloc]init];
            praVc.type = 11;
            [self.navigationController pushViewController:praVc animated:YES];
        }else{            HKPraiseViewController*praVc = [[HKPraiseViewController alloc]init];
            praVc.type = 12;
            [self.navigationController pushViewController:praVc animated:YES];
        }
    }
}
-(void)loadData{
    HKPushModel*model = [[HKPushModel alloc]init];
    model.sysUid = HKUSERID;
    NSString *selectStr = [[ZSDBManageBaseModel sharedZSDBManageBaseModel]getSqlString:model withImplementType:implementType_select];
   FMResultSet*rs =   [[DatabaseToll sharedDatabaseToll]executeQuery:selectStr];
    NSArray*array =  [[ZSDBManageBaseModel sharedZSDBManageBaseModel] analysisWihtClass:[HKPushModel class] andRs:rs];
    self.dataArray = array;
    [self.tableView reloadData];
}

@end
