//
//  HKBurstingEndViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBurstingEndViewController.h"
#import "HKluckyBurstDetailRespone.h"
#import "HKBurstingtEndTitleTableViewCell.h"
#import "HKBurstingInfoFallTableViewCell.h"
#import "HKBurstingEndToolTableViewCell.h"
#import "HKBurstingInfoSuccessTableViewCell.h"
@interface HKBurstingEndViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation HKBurstingEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
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
        _tableView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
    }
    return _tableView  ;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HKBurstingtEndTitleTableViewCell*cell = [HKBurstingtEndTitleTableViewCell baseCellWithTableView:tableView];
        cell.respone = self.respone;
        return cell;
    }else if (indexPath.row == 1){
        if(self.respone.data.state.integerValue == 0){
            HKBurstingInfoFallTableViewCell*cell = [HKBurstingInfoFallTableViewCell baseCellWithTableView:tableView];
            cell.respone = self.respone;
            return cell;
        }else{
            HKBurstingInfoSuccessTableViewCell*cell = [HKBurstingInfoSuccessTableViewCell baseCellWithTableView:tableView];
            cell.respone = self.respone;
            return cell;
        }
    }else if (indexPath.row == 2){
        HKBurstingEndToolTableViewCell*cell = [HKBurstingEndToolTableViewCell baseCellWithTableView:tableView];
        cell.isAward = self.respone.data.state.boolValue;
        return cell;
    }
    static NSString *identify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(void)setRespone:(HKluckyBurstDetailRespone *)respone{
    _respone = respone;
    [self.tableView reloadData];
}
@end
