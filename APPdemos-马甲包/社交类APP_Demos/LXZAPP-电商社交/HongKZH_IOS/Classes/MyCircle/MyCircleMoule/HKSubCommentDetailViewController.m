//
//  HKSubCommentDetailViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSubCommentDetailViewController.h"
#import "HKPostCommitCell.h"
#import "HKMyCircleViewModel.h"
@interface HKSubCommentDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger page;
@end
@implementation HKSubCommentDetailViewController

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"评论回复列表";
    self.page =1;
    [self setUI];
    [self loadData];
    [self.view addSubview:self.tableView];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        //_tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = 130;
        [_tableView registerClass:[HKPostCommitCell class] forCellReuseIdentifier:@"cm"];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.page++;
            [self  loadData];
        }];
        _tableView.tableFooterView =[[UIView alloc] init];
    }
    return _tableView;
}
-(void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)loadData {
    
    [HKMyCircleViewModel getReCommentList:self.list.commentId pageNumber:self.page success:^(HKReCommentListResponse *responde) {
        if (responde.code ==0) {
            if (self.page ==1) {
                [self.dataArray removeAllObjects];
            }
            if (self.page == responde.data.totalPage || responde.data.totalPage == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
            }
            [self.dataArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKPostCommitCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cm" forIndexPath:indexPath];
    HKReCommentList *list  =self.dataArray[indexPath.row];
    cell.model = self.list;
    cell.list =list;
    return cell;
}

@end
