//
//  HKCorporateTypeAdvertisingViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCorporateTypeAdvertisingViewController.h"
#import "HKRecommendType1TableViewCell.h"
#import "HKLeSeeViewModel.h"
#import "HKCorporateAdvertisingInfoViewController.h"
@interface HKCorporateTypeAdvertisingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic,assign) int pageNum;
@end

@implementation HKCorporateTypeAdvertisingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum++;
    [self setUI];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
    self.title = self.name;
    [self loadNewData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    [HKLeSeeViewModel getEnterpriseListByCategory:@{@"categoryId":self.ID,@"pageNumber":@(self.pageNum)} success:^(HKPriseHotAdvListRespone *responde) {
       
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
        _tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKRecommendType1TableViewCell*cell = [HKRecommendType1TableViewCell baseCellWithTableView:tableView];
    cell.hotModel = self.questionArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HKCorporateAdvertisingInfoViewController*vc = [[HKCorporateAdvertisingInfoViewController alloc]init];
    PriseHotAdvListModel*model = self.questionArray[indexPath.row];;
    vc.ID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
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
