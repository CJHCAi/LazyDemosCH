//
//  HKMarketViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMarketViewController.h"
#import "HKMarketHeadTableViewCell.h"
#import "MarketDataViewModel.h"
#import "MarketDataRespone.h"
#import "HKMarketDataTableViewCell.h"
#import "HKCounponTool.h"
#import "HKGameProductRespone.h"
#import "HKMarketCounponTableViewCell.h"
#import "HKMarketTypeTableViewCell.h"
@interface HKMarketViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)MarketDataRespone *myData;
@property (nonatomic, strong)NSMutableArray *counponArray;
@property (nonatomic, strong)NSMutableArray *goodsArray;
@end

@implementation HKMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self loadNewData];
    [self addNotification];
}
-(void)cancelNewUser {
    [super cancelNewUser];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)loadNewData{
    [self loadMyDataSuccess:^{
        
    }];
    [self loadGoodsDataSuccess:^{
        
    }];
    [self loadCounponDataSuccess:^{
        
    }];
}
-(void)loadMyDataSuccess:(void (^)(void))succes{
    [MarketDataViewModel myDataMarketSuccess:^(MarketDataRespone *respone) {
        if (respone.responeSuc) {
            self.myData = respone;
            [self.tableView reloadData];
        }
        succes();
    }];
}
-(void)loadCounponDataSuccess:(void (^)(void))succes{
    [MarketDataViewModel getCounponList:^(HKCouponResponse *response) {
        if ([response.data isKindOfClass:[HKCounData class]] && response.data.list.count>0) {
            NSMutableArray*array;
            [self.counponArray removeAllObjects];
            for (int i = 0; i < response.data.list.count; i++) {
           
            if (self.counponArray.count>0) {
              NSMutableArray*lastArrey =  self.counponArray.lastObject;
                if (lastArrey.count<3) {
                    array = lastArrey;
                }else{
                    array = [NSMutableArray array];
                    [self.counponArray addObject:array];
                }
            }else{
                array = [NSMutableArray array];
                [self.counponArray addObject:array];
            }
                HKCounList*model = response.data.list[i];
                [array addObject:model];
           
                
            }
            [self.tableView reloadData];
        }
        succes();
    }];
}
-(void)loadGoodsDataSuccess:(void (^)(void))succes{
    [MarketDataViewModel getGameProductRespone:^(HKGameProductRespone *respone) {
        if (respone.responeSuc) {
            
        if (respone.data.list.count>0) {
            [self.goodsArray removeAllObjects];
         
            for (int i = 0; i<respone.data.list.count; i++) {
                NSMutableArray*array;
                if (self.goodsArray.count>0) {
                    NSMutableArray*lastArrey =  self.goodsArray.lastObject;
                    if (lastArrey.count<3) {
                        array = lastArrey;
                    }else{
                        array = [NSMutableArray array];
                        [self.goodsArray addObject:array];
                    }
                }else{
                    array = [NSMutableArray array];
                    [self.goodsArray addObject:array];
                }
                HKGameProductModel*model = respone.data.list[i];
                [array addObject:model];
            }
            [self.tableView reloadData];
        }
            
        }
        succes();
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
      _tableView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgs"]];
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        if (self.counponArray.count>0) {
            return [self.counponArray count];
        }else{
            return 1;
        }
        
    }else if (section == 5){
        if (self.goodsArray.count>0) {
            return [self.goodsArray count];
        }else{
            return 1;
        }
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKMarketHeadTableViewCell*cell = [HKMarketHeadTableViewCell baseCellWithTableView:tableView];
        return cell;
    }else if (indexPath.section==1){
        HKMarketDataTableViewCell*cell = [HKMarketDataTableViewCell baseCellWithTableView:tableView];
        cell.respone = self.myData;
        return cell;
    }else if (indexPath.section == 3){
        HKMarketCounponTableViewCell*cell = [HKMarketCounponTableViewCell baseCellWithTableView:tableView];
        cell.type = 0;
        if (self.counponArray.count>0) {
              cell.dataArray = self.counponArray[indexPath.item];
        }else{
            cell.dataArray = [NSMutableArray array];
        }
      
        return cell;
    }else if(indexPath.section == 5){
        HKMarketCounponTableViewCell*cell = [HKMarketCounponTableViewCell baseCellWithTableView:tableView];
        cell.type = 1;
        if (self.goodsArray.count>0) {
            cell.dataArray = self.goodsArray[indexPath.item];
        }else{
            cell.dataArray = [NSMutableArray array];
        }
        
        return cell;
    }else{
        HKMarketTypeTableViewCell*cell = [HKMarketTypeTableViewCell baseCellWithTableView:tableView];
        cell.section = indexPath.section;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(NSMutableArray *)counponArray{
    if (!_counponArray) {
        _counponArray = [NSMutableArray array];
    }
    return _counponArray;
}
-(NSMutableArray *)goodsArray{
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}
@end
