//
//  HKMyRepliesPostsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyRepliesPostsViewController.h"
#import "HKMyPostViewModel.h"
#import "HKMyRepliesPostTableViewCell.h"
#import "HKMyReplisePostInfoView.h"
@interface HKMyRepliesPostsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic,assign) int pageNum;
@end

@implementation HKMyRepliesPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    [self setUI];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
    [self loadData];
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)loadData{
    [HKMyPostViewModel myRepliesPosts:@{@"loginUid":HKUSERLOGINID,@"pageNumber":@(self.pageNum)} success:^(HKMyRepliesPostsRespone *responde) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
      
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            [self.questionArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
            [self scrollViewDidScroll:self.tableView];
        }else{
            if (self.pageNum>1) {
                self.pageNum --;
            }
        }
    }];
}
-(void)loadNewData{
    self.pageNum = 1;
    [self.questionArray removeAllObjects];
    [self loadData];
}
-(void)loadNextData{
    self.pageNum ++;
    [self loadData];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.questionArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   MyRepliesPostsListModel*listM = self.questionArray[section];
    return [[listM comments]count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 95;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //这里是我的headerView和footerView的高度
    UITableView *tableview = (UITableView *)scrollView;
    CGFloat sectionHeaderHeight = 95;
    CGFloat sectionFooterHeight = 95;
    CGFloat offsetY = tableview.contentOffset.y;
    if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
    {
        tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
    {
        tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
    }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
    {
        tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MyRepliesPostsListModel*listM = self.questionArray[section];
    HKMyReplisePostInfoView*infoView = [[HKMyReplisePostInfoView alloc]init];
    infoView.model = listM;
    return infoView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyRepliesPostTableViewCell *cell = [HKMyRepliesPostTableViewCell myRepliesPostTableViewCellWithTableView:tableView];
   MyRepliesPostsListModel*listM = self.questionArray[indexPath.section];
    cell.model = listM.comments[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
@end
