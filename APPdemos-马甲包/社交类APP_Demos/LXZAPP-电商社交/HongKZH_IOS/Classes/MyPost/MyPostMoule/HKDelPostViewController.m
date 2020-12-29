//
//  HKDelPostViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDelPostViewController.h"
#import "HKMyRepliesPostTableViewCell.h"
#import "HKMyPostViewModel.h"
@interface HKDelPostViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic,assign) int pageNum;
@end

@implementation HKDelPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.title =@"我的回帖";
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
    [self loadNewData];
}
-(void)loadNewData{
    self.pageNum =1;
    [self.questionArray removeAllObjects];
    [self loadData];
}
-(void)loadNextData{
    self.pageNum ++;
    [self loadData];
}
-(void)loadData{
    NSDictionary*dict = @{@"loginUid":HKUSERLOGINID,@"pageNumber":@(self.pageNum),@"delType":@(self.type)};
    [HKMyPostViewModel myDelPosts:dict success:^(HKMyDelPostsRespne *responde) {
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
        }else{
            if (self.pageNum>1) {
                self.pageNum --;
            }
        }
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
    HKMyRepliesPostTableViewCell*cell = [HKMyRepliesPostTableViewCell myRepliesPostTableViewCellWithTableView:tableView];
    cell.delModel = self.questionArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(void)setUI{
    self.title = @"我的帖子";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
