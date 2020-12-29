//
//  HKTollSelfCommitViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTollSelfCommitViewController.h"
#import "GetMediaAdvAdvByIdRespone.h"
#import "HKLeSeeViewModel.h"
#import "InfoMediaAdvCommentListRespone.h"
#import "HKToolCommtiTableViewCell.h"
#import "HKCommitInfosViewController.h"
@interface HKTollSelfCommitViewController ()<UITableViewDelegate,UITableViewDataSource,HKToolCommtiTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property(nonatomic, assign) int pageNum;
@property (nonatomic, strong)NSMutableArray *questionArray;
@end

@implementation HKTollSelfCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    
    [self setUI];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
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
    NSString *ID;
    if (self.cityResponse) {
       ID = self.cityResponse.data.cityAdvId;
    }else {
        ID =self.responde.data.ID;
    }
    [HKLeSeeViewModel getInfoMediaAdvCommentList:@{@"loginUid":HKUSERLOGINID,@"pageNumber":@(self.pageNum),@"id":ID>0?ID:@""} success:^(InfoMediaAdvCommentListRespone *responde) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            if (self.pageNum == 1) {
                [self.questionArray removeAllObjects];
            }
            [self.questionArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }else{
            if (self.pageNum>1) {
                self.pageNum--;
            }
        }
    }];
}
-(void)commitWithAdvCommentModel:(InfoMediaAdvCommentListModels *)model{
    HKCommitInfosViewController*vc = [[HKCommitInfosViewController alloc]init];
    vc.model =model;
    vc.isPre = YES;
    vc.responde = self.responde;
    vc.cityResponse = self.cityResponse;
    UINavigationController*navVc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navVc animated:YES completion:nil];
}
-(void)setUI{
  
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
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
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKToolCommtiTableViewCell*cell = [HKToolCommtiTableViewCell baseCellWithTableView:tableView];
    cell.model = self.questionArray[indexPath.row];
    cell.type = 0;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCommitInfosViewController*vc = [[HKCommitInfosViewController alloc]init];
    vc.model = self.questionArray[indexPath.row];
    vc.isPre = YES;
    vc.responde= self.responde;
    UINavigationController*navVc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navVc animated:YES completion:nil];
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray  ;
}

@end
