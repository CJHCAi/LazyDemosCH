//
//  HKPraiseViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPraiseViewController.h"
#import "HKPushViewModel.h"
#import "HKMyPostsRespone.h"
#import "HKMyPostShareTableViewCell.h"
@interface HKPraiseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic,assign) int pageNum;
@end

@implementation HKPraiseViewController

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
    [self.questionArray removeAllObjects];
    [self loadData];
}
-(void)loadNextData{
    self.pageNum ++;
    [self loadData];
}
-(void)loadData{
    [HKPushViewModel myPraisePost:@{@"loginUid":HKUSERLOGINID,@"pageNumber":@(self.pageNum)}type:self.type success:^(HKMyPostsRespone *responde) {
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
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyPostShareTableViewCell*cell = [HKMyPostShareTableViewCell myPostBaseTableViewCellWithTableView:tableView];
    HKMyPostModel*model = self.questionArray[indexPath.row];
    model.type = [NSString stringWithFormat:@"%d",self.type];
    cell.model = model;
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
-(void)setType:(int)type{
    _type = type;
    if (type == 11) {
        self.title = @"点赞";
    }else{
        self.title = @"转发";
    }
}
@end
