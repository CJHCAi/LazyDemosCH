//
//  HKCorporateAdvertisingViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCorporateAdvertisingViewController.h"
#import "HKLeSeeViewModel.h"
#import "HKSowingRespone.h"
#import "HKAdvertisingScrollTableViewCell.h"
#import "HKAdvertisingTypeTableViewCell.h"
#import "CorporateCategoryResponse.h"
#import "EnterpriseHotAdvTypeListRedpone.h"
#import "HKEnterpriseHotAdvTypeListTableViewCell.h"
#import "HKEnterpriseHotAdvListParameter.h"
#import "HKPriseHotAdvListRespone.h"
#import "HKRecommendType1TableViewCell.h"
#import "HKRecommendType2TableViewCell.h"
#import "HKCorporateAdvertisingInfoViewController.h"
#import "HKCorporateTypeAdvertisingViewController.h"
@interface HKCorporateAdvertisingViewController ()<UITableViewDelegate,UITableViewDataSource,HKAdvertisingTypeTableViewCellDelegate,HKEnterpriseHotAdvTypeListTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKSowingRespone *sowIng;
@property (nonatomic, strong)CorporateCategoryResponse *categoryResponse;
@property (nonatomic, strong)EnterpriseHotAdvTypeListRedpone *hotRespone;
@property (nonatomic, strong)NSMutableArray *parameterArray;
@property (nonatomic,assign) CGFloat y;

@property(nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong)NSMutableArray *categoryParameterArray;
@end

@implementation HKCorporateAdvertisingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
    [self InitializationData];
}
-(void)InitializationData{
    self.currentIndex = 0;
    [self loadNewData];
}
-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(self.view).offset(-44-SafeAreaBottomHeight);
        
    }];
}
-(void)loadTypesSuccess:(void (^)(void))success{
    [HKLeSeeViewModel getEnterpriseCategoryList:^(CorporateCategoryResponse *responde) {
        if (responde.responeSuc) {
            self.categoryResponse = responde;
            [self.categoryParameterArray removeAllObjects];
            for (CorporateCategoryModel*model in responde.data) {
                HKEnterpriseHotAdvListParameter*parameter = [[HKEnterpriseHotAdvListParameter alloc]init];
                parameter.typeId = model.ID;
                parameter.pageNumber = 1;
                [self.categoryParameterArray addObject:parameter];
            }
//            CorporateCategoryModel*model = [[CorporateCategoryModel alloc]init];
//            model.name = @"限时抢";
//            model.ID = @"";
//            [responde.data insertObject:model atIndex:0];
            [self.tableView reloadData];
            if (self.currentIndex==0) {
                success();
            }else{
                [self loadCategoryDataSuccess:^{
                    success();
                }];
            }
        }else{
          success();
        }
        
    }];
}
-(void)loadCarouseSuccess:(void (^)(void))success{
    [HKLeSeeViewModel getEnterpriseCarouselListSuccess:^(HKSowingRespone *responde) {
        if (responde.responeSuc) {
            self.sowIng = responde;
            [self.tableView reloadData];
        }
         success();
    }];
}
-(void)loadNewData{
    HKEnterpriseHotAdvListParameter*param =    [self getParameter];
    param.pageNumber = 1;
    [param.questionArray removeAllObjects];
    [SVProgressHUD showWithStatus:@"加载中"];
    dispatch_group_t group =  dispatch_group_create();
    dispatch_group_enter(group);
    [self loadCarouseSuccess:^{
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [self loadTypesSuccess:^{
        dispatch_group_leave(group);
    }];
    if (self.currentIndex == 0) {
        dispatch_group_enter(group);
        [self loadHotSuccess:^{
            dispatch_group_leave(group);
        }];
    }
   
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    });
}
-(void)loadNewListDataSuccess:(void (^)(void))success{
    
    [self loadListDataSuccess:^{
        success();
    }];
}
-(void)loadNextData{
    HKEnterpriseHotAdvListParameter*param =    [self getParameter];
    param.pageNumber++;
    [SVProgressHUD showWithStatus:@"加载中"];
    if (self.currentIndex == 0) {
        [self loadListDataSuccess:^{
            [SVProgressHUD dismiss];
        }];
    }else{
        [self loadCategoryDataSuccess:^{
             [SVProgressHUD dismiss];
        }];
    }
    
}

-(void)loadHotSuccess:(void (^)(void))success{
    [HKLeSeeViewModel EnterpriseHotAdvTypeList:^(EnterpriseHotAdvTypeListRedpone *responde) {
        if (responde.responeSuc) {
            self.hotRespone = responde;
            [self.tableView reloadData];
            [self loadNewListDataSuccess:^{
                success();
            }];
        }else{
            success();
        }
    }];
}
-(void)loadListDataSuccess:(void (^)(void))success{
    HKEnterpriseHotAdvListParameter*param =    [self getParameter];
    [HKLeSeeViewModel getEnterpriseHotAdvList:@{@"typeId":param.typeId,@"pageNumber":@(param.pageNumber)} success:^(HKPriseHotAdvListRespone *responde) {
        HKEnterpriseHotAdvListParameter*param =    [self getParameter];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            
            [param.questionArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
            if (self.y>0) {
                [self.tableView setContentOffset:CGPointMake(0, self.y) animated:YES];
            }
        }else{
            if (param.pageNumber>1) {
                param.pageNumber --;
            }
        }
        success();
    }];
}



-(void)loadCategoryDataSuccess:(void (^)(void))success{
    HKEnterpriseHotAdvListParameter*param =    [self getParameter];
    [HKLeSeeViewModel getEnterpriseListByCategory:@{@"categoryId":param.typeId,@"pageNumber":@(param.pageNumber)} success:^(HKPriseHotAdvListRespone *responde) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            [param.questionArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }else{
            if (param.pageNumber>1) {
                param.pageNumber --;
            }
        }
        success();
    }];
}
-(void)tableViewRefresh{
    [self.tableView reloadData];
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
        _tableView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    }
    return _tableView;
}
-(void)selectCategory:(NSString *)ID index:(NSInteger)index{
   
//    self.currentIndex  = index;
    HKCorporateTypeAdvertisingViewController*vc = [[HKCorporateTypeAdvertisingViewController alloc]init];
    vc.ID = ID;
    vc.name = [self.categoryResponse.data[index] name];
    [self.navigationController pushViewController:vc animated:YES];
//    if (index == 0) {
//        [self InitializationData];
//        return;
//    }
//    [SVProgressHUD showWithStatus:@"加载中"];
//    [self loadCategoryDataSuccess:^{
//        [SVProgressHUD dismiss];
//    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.y = scrollView.contentOffset.y;
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return [[[self getParameter]questionArray]count];
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HKAdvertisingScrollTableViewCell*cell = [HKAdvertisingScrollTableViewCell baseCellWithTableView:tableView];
        cell.sowIng = self.sowIng;
        return cell;
    }else if(indexPath.section == 1){
        HKAdvertisingTypeTableViewCell*cell = [HKAdvertisingTypeTableViewCell baseCellWithTableView:tableView];
         cell.currentIndex = self.currentIndex;
        if (self.categoryResponse) {
            
            cell.model = self.categoryResponse;
        }
      
        cell.delegate = self;
        return cell;
    }else if(indexPath.section == 2){
        HKEnterpriseHotAdvTypeListTableViewCell*cell = [HKEnterpriseHotAdvTypeListTableViewCell baseCellWithTableView:tableView];
        if (self.hotRespone) {
            cell.respone = self.hotRespone;
        }
        cell.delegate = self;
        cell.index = self.currentIndex;
        return cell;
    }else{
        
        PriseHotAdvListModel*model = [[self getParameter]questionArray][indexPath.row];;
//        if (self.currentIndex == 0) {r
//        if (model.showType.intValue == 1) {
            HKRecommendType1TableViewCell*cell = [HKRecommendType1TableViewCell baseCellWithTableView:tableView];
            cell.hotModel = model;
            return cell;
//        }else{
//            HKRecommendType2TableViewCell*cell = [HKRecommendType2TableViewCell baseCellWithTableView:tableView];
//            cell.hotModel = model;
//            return cell;
//        }
//        }else{
//            HKRecommendType1TableViewCell*cell = [HKRecommendType1TableViewCell baseCellWithTableView:tableView];
//            cell.hotModel = model;
//            return cell;
//        }
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section<3) {
        return;
    }
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HKCorporateAdvertisingInfoViewController*vc = [[HKCorporateAdvertisingInfoViewController alloc]init];
     PriseHotAdvListModel*model = [[self getParameter]questionArray][indexPath.row];;
    vc.ID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}
-(HKEnterpriseHotAdvListParameter*)getCategoryParameter{
    if (self.categoryParameterArray.count>0) {
        HKEnterpriseHotAdvListParameter*model = self.categoryParameterArray[self.currentIndex-1];
        return model;
    }else{
        HKEnterpriseHotAdvListParameter*model = [[HKEnterpriseHotAdvListParameter alloc]init] ;
        return model;
    }
}
-(HKEnterpriseHotAdvListParameter*)getParameter{
    
    if (self.parameterArray.count>0) {
        HKEnterpriseHotAdvListParameter*model = self.parameterArray[self.hotRespone.selectItem];
        return model;
    }else{
        HKEnterpriseHotAdvListParameter*model = [[HKEnterpriseHotAdvListParameter alloc]init] ;
        return model;
    }
}
-(void)setHotRespone:(EnterpriseHotAdvTypeListRedpone *)hotRespone{
    _hotRespone = hotRespone;
    [self.parameterArray removeAllObjects];
    for (EnterpriseHotAdvTypeListModel*model in hotRespone.data) {
        HKEnterpriseHotAdvListParameter*parameterM = [[HKEnterpriseHotAdvListParameter alloc]init];
        parameterM.pageNumber = 1;
        parameterM.typeId = model.typeId;
        [self.parameterArray addObject:parameterM];
    }
}
- (NSMutableArray *)parameterArray
{
    if(_parameterArray == nil)
    {
        _parameterArray = [ NSMutableArray array];
    }
    return _parameterArray;
}
- (NSMutableArray *)categoryParameterArray
{
    if(_categoryParameterArray == nil)
    {   
        _categoryParameterArray = [ NSMutableArray array];
    }
    return _categoryParameterArray;
}
-(void)updatetypeWithTag:(NSInteger)tag{
    self.hotRespone.selectItem = tag;
    if ([[[self getParameter]questionArray]count]>0) {
        
        [self.tableView reloadData];
    }else{
        [SVProgressHUD showWithStatus:@"加载中"];
        [self loadNewListDataSuccess:^{
            [SVProgressHUD dismiss];
        }];
    }
}
@end
