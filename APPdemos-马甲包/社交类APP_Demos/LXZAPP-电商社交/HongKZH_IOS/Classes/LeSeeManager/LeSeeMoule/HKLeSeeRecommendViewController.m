//
//  HKLeSeeRecommendViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeSeeRecommendViewController.h"
#import "HKLeSeeViewModel.h"
#import "HKUserCategoryListRespone.h"
#import "HKSowIngTableViewCell.h"
#import "HKSowingRespone.h"
#import "HKHotTableViewCell.h"
#import "HkHotRespone.h"
#import "HKRecommendRespone.h"
#import "HKRecommendType2TableViewCell.h"
#import "HKRecommendType1TableViewCell.h"
#import "HKRewardViewsController.h"
#import "SelfMediaRespone.h"
#import "HKSelfMeidaVodeoViewController.h"
#import "HKCorporateAdvertisingInfoViewController.h"
@interface HKLeSeeRecommendViewController ()<UITableViewDelegate,UITableViewDataSource,HKHotTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sowingArray;
@property (nonatomic, strong)NSMutableArray *hotArray;
@property(nonatomic, assign) int pageNum;
@property (nonatomic, strong)NSMutableArray *recommentArray;
@end

@implementation HKLeSeeRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadNewData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
}
-(void)loadNewData{
    self.pageNum = 1;
    self.tableView.userInteractionEnabled = NO;
    dispatch_group_t group =  dispatch_group_create();
    dispatch_group_enter(group);
    [self loadHotsuccess:^{
       dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [self loadSowingsuccess:^{
        dispatch_group_leave(group);
    }];
    [self.recommentArray removeAllObjects];
    dispatch_group_enter(group);
    [self loadRecommendsuccess:^{
       dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.tableView.userInteractionEnabled = YES;
    });
}
-(void)loadNextData{
    self.pageNum ++;
    self.tableView.userInteractionEnabled = NO;
    [self loadRecommendsuccess:^{
        self.tableView.userInteractionEnabled = YES;
    }];
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)loadRecommendsuccess:(void (^)(void))success{
    [HKLeSeeViewModel getRecommendList:@{@"pageNumber":@(self.pageNum)} success:^(HKRecommendRespone *responde) {
        self.tableView.userInteractionEnabled = YES;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (responde.responeSuc) {
            if (responde.data) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                 self.tableView.mj_footer.hidden = NO;
            }
            [self.recommentArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }else{
            if (self.pageNum>1) {
                self.pageNum --;
            }
            
        }
        success();
    }];
}
-(void)loadHotsuccess:(void (^)(void))success{
    [HKLeSeeViewModel getHotAdvList:@{@"pageNumber":@"1"} success:^(HkHotRespone *responde) {
        if (responde.responeSuc) {
            [self.hotArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }
        success();
    }];
}
-(void)loadSowingsuccess:(void (^)(void))success{
    [HKLeSeeViewModel getCarouselListWithSuccess:^(HKSowingRespone *responde) {
        if (responde.responeSuc) {
            self.sowingArray = responde.data;
            [self.tableView reloadData];
        }
        success();
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.recommentArray.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKSowIngTableViewCell*cell = [HKSowIngTableViewCell sowIngTableViewCellWithTableView:tableView];
        if (self.sowingArray.count>0) {
            cell.imageArray = self.sowingArray;
        }
        
        return cell;
    }else if(indexPath.section == 1){
        HKHotTableViewCell*cell = [HKHotTableViewCell hotTableViewCellWithTableView:tableView];
        if (self.hotArray.count>0) {
            cell.dataArray = self.hotArray;
        }
        cell.delegate = self;
        return cell;
    }else{
        RecommendModel*recommendM = self.recommentArray[indexPath.row];
        if (recommendM.type == 1) {
            HKRecommendType1TableViewCell*cell = [HKRecommendType1TableViewCell baseCellWithTableView:tableView];
            cell.model = recommendM;
            return cell;
        }else{
            HKRecommendType2TableViewCell*cell = [HKRecommendType2TableViewCell baseCellWithTableView:tableView];
            cell.model = recommendM;
            return cell;
        }
    }
   
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendModel*recommendM = self.recommentArray[indexPath.row];
    [self gotoVideo:recommendM.ID antType:[NSString stringWithFormat:@"%d",recommendM.type] coverImgSrc:recommendM.coverImgSrc];
}
- (NSMutableArray *)sowingArray
{
    if(_sowingArray == nil)
    {
        _sowingArray = [ NSMutableArray array];
    }
    return _sowingArray;
}
- (NSMutableArray *)hotArray
{
    if(_hotArray == nil)
    {
        _hotArray = [ NSMutableArray array];
    }
    return _hotArray;
}
-(NSMutableArray *)recommentArray{
    if (!_recommentArray) {
        _recommentArray = [NSMutableArray array];
    }
    return _recommentArray;
}
-(void)gotoVideo:(NSString*)ID antType:(NSString*)type coverImgSrc:(NSString*)coverImgSrc{
    //1自媒体 2企业广告3城市广告4传统文化
    if (type.intValue == 1) {
        SelfMediaModelList*listM = [[SelfMediaModelList alloc]init];
        listM.title = @"";
        listM.coverImgSrc = coverImgSrc;
        //    listM.
        listM.praiseCount = @"";
        listM.rewardCount = @"";
        listM.isCity = NO;
        listM.ID = ID;
        HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
        vc.dataArray = [NSMutableArray arrayWithObject:listM];
        vc.selectRow = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type.intValue == 2){
        HKCorporateAdvertisingInfoViewController*vc = [[HKCorporateAdvertisingInfoViewController alloc]init];
        vc.ID = ID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (type.intValue == 3){
        SelfMediaModelList*listM = [[SelfMediaModelList alloc]init];
        listM.title = @"";
        listM.coverImgSrc = coverImgSrc;
        //    listM.
        listM.praiseCount = @"";
        listM.rewardCount = @"";
        listM.isCity = YES;
        listM.ID = ID;
        HKSelfMeidaVodeoViewController*vc = [[HKSelfMeidaVodeoViewController alloc]init];
        vc.dataArray = [NSMutableArray arrayWithObject:listM];
        vc.selectRow = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}
-(void)clickHot:(NSInteger)tag{
    HKHotModel*model = self.hotArray[tag];
    [self gotoVideo:model.ID antType:model.type coverImgSrc:model.coverImgSrc];
}
@end
