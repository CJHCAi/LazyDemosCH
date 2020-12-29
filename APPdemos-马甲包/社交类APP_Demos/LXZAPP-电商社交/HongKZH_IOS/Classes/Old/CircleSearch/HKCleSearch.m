//
//  HKCleSearch.m
//  HongKZH_IOS
//
//  Created by 王辉 on 2018/8/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCleSearch.h"
#import "HKSearchView.h"
#import "HKSearcCleTableViewCell.h"
#import "HKSesioncleView.h"
#import "HK_BaseRequest.h"
#import "HKSearchcircleListModel.h"
#import "HKMyCircleViewController.h"
@interface HKCleSearch ()<HKSearchViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)HKSearchView*searchV;
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSArray*dataArr;;
@end

@implementation HKCleSearch

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)setUI{
    self.navigationItem.titleView = self.searchV;
    [self setShowCustomerLeftItem:YES];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HKSearchcircleListModelData*model = self.dataArr[indexPath.row];
    HKMyCircleViewController*vc = [[HKMyCircleViewController alloc]init];
    vc.circleId = model.circleId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [HKSesioncleView sesioncleView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HKSearcCleTableViewCell*cell = [HKSearcCleTableViewCell searcCleTableViewCellWithTableView:tableView];
    cell.dataM = self.dataArr[indexPath.row];
    return cell;
}
- (void)requestRecommandJobs:(NSString*)name {
    NSDictionary* dic = @{@"name":name,@"loginUid":HKUSERLOGINID};
    [HK_BaseRequest  buildPostRequest:get_searchcircleList body:dic success:^(id  _Nullable responseObject) {
        HKSearchcircleListModel *model = [HKSearchcircleListModel mj_objectWithKeyValues:responseObject];
        self.dataArr = model.data;
        [self.tableView reloadData];
    } failure:^(NSError * _Nullable error) {
        
    }];
//    [self Business_Request:BusinessRequestType_get_searchcircleList dic:dic cache:NO];
}
-(void)textChange:(UITextField *)textFile{
    [self requestRecommandJobs:textFile.text];
}

-(HKSearchView *)searchV{
    if (!_searchV) {
        _searchV = [HKSearchView searchView];
        _searchV.frame = CGRectMake(0, 0, kScreenWidth-45-60, 30);
        _searchV.intrinsicContentSize = CGSizeMake(kScreenWidth-45-60, 30);
        _searchV.delegate = self;
        [_searchV layoutSubviews];
    }
    return _searchV;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}
-(void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    self.searchV.searchText = searchText;
}
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
@end
