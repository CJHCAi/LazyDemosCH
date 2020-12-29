//
//  HKLuckyBurstFriendsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLuckyBurstFriendsViewController.h"
#import "HKShoppingViewModel.h"
#import "LuckyBurstFriendsRespone.h"
#import "HKLuckyBurstFriendsData.h"
#import "HKHKLuckyBurstFriendTableViewCell.h"
@interface HKLuckyBurstFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic,assign) int pageNum;
@property (nonatomic, strong)UIView *headView;
@property (nonatomic, strong)UILabel *allNum;
@end

@implementation HKLuckyBurstFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
    [self loadNewData];
}
-(void)loadNewData{
    self.pageNum = 1;
    [self loadData];
}
-(void)loadNextData{
    self.pageNum++;
    [self loadData];
}
-(void)loadData{
    [HKShoppingViewModel getLuckyBurstFriends:@{@"orderNumber":self.orderNumber,kloginUid:HKUSERLOGINID,@"pageNumber":@(self.pageNum)} success:^(LuckyBurstFriendsRespone *responde) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (responde.responeSuc) {
            if (self.pageNum == 1) {
                [self.questionArray removeAllObjects];
            }
            self.allNum.text = [NSString stringWithFormat:@"共%ld人",responde.data.list.count];
            [self.questionArray addObjectsFromArray:responde.data.list];
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            [self.tableView reloadData];
        }else{
            if (self.pageNum>1) {
                self.pageNum --;
            }
        }
    }];
}
-(void)setUI{
    self.title = @"助力好友";
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
        _tableView.tableHeaderView = self.headView;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKHKLuckyBurstFriendTableViewCell*cell = [HKHKLuckyBurstFriendTableViewCell baseCellWithTableView:tableView];
    cell.model = self.questionArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        [_headView addSubview:self.allNum];
        [self.allNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headView);
            make.right.equalTo(_headView).offset(-15);
        }];
        _headView.backgroundColor = [UIColor colorFromHexString:@"F5F5F5"];
    }
    return _headView;
}
-(UILabel *)allNum{
    if (!_allNum) {
        _allNum = [[UILabel alloc]init];
        _allNum.font = PingFangSCMedium12;
        _allNum.textColor = [UIColor colorFromHexString:@"666666"];
    }
    return _allNum;
}
@end
