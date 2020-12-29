//
//  HKOrderFormSearchViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKOrderFormSearchViewController.h"
#import "HKOrderFormTableViewCell.h"
#import "HKOrderFormViewModel.h"
@interface HKOrderFormSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSString *textStr;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic,assign) int pageNumber;
@end

@implementation HKOrderFormSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.nabarView.placeHoder = @"请输入商品、订单号、手机号、姓名";
    self.pageNumber = 1;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)loadNewData{
    
    self.pageNumber = 1;
    [self loadData];
}
-(void)loadNextData{
    self.pageNumber = self.pageNumber + 1;
    [self loadData];
}
-(void)loadData{
    [HKOrderFormViewModel searchorderListByState:@{@"loginUid":HKUSERLOGINID,@"title":self.textStr,@"pageNumber":@(self.pageNumber)} success:^(HKSellerorderListRespone *responde)  {       if (self.pageNumber == 1) {
            [self.questionArray removeAllObjects];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (responde.code.length>0&&[responde.code intValue] == 0) {
            [self.questionArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }else{
            if (self.pageNumber > 1) {
                self.pageNumber = self.pageNumber - 1;
            }
        }
    }];
}
-(void)cancleClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.nabarView.mas_bottom);
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKOrderFormTableViewCell *cell  = [HKOrderFormTableViewCell orderFormTableViewCellWithTableView:tableView];
    cell.model = self.questionArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textChangeWithText:(NSString *)textStr{
    if (![_textStr isEqualToString:textStr]) {
        _textStr = textStr;
        [self loadNewData];
    }
    
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
