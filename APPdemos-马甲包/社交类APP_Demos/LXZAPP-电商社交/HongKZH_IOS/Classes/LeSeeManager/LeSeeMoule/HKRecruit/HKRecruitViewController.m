//
//  HKRecruitViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRecruitViewController.h"
#import "HKLeSeeViewModel.h"
#import "HKSowingRespone.h"
#import "HKRecruitParameter.h"
#import "HKRecruitRespone.h"
#import "HKRecruitTableViewCell.h"
#import "HKRecruitScreenView.h"
#import "HKReseaesInfosViewController.h"
#import "HKSelectbaseViewController.h"
#import "getChinaList.h"
@interface HKRecruitViewController ()<UITableViewDelegate,UITableViewDataSource,HKRecruitScreenViewDelegate,HKSelectbaseViewControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKRecruitParameter *recruitParameter;
@end

@implementation HKRecruitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self loadNewData];
     [self setUI];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
}

-(void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)loadNewData{
    self.recruitParameter.pageNumber = 1;
    [self.recruitParameter.questionArray removeAllObjects];
    [self loadRecruit];
}
-(void)loadNextData{
    self.recruitParameter.pageNumber++;
    [self loadRecruit];
}
-(void)loadRecruit{
    NSDictionary*dict = [self.recruitParameter mj_keyValues];
    [HKLeSeeViewModel getEnterpriseRecruitList:dict success:^(HKRecruitRespone *responde) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            [self.recruitParameter.questionArray addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }else{
            if (self.recruitParameter.pageNumber>1) {
                self.recruitParameter.pageNumber--;
            }
        }
       
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 190;
  if(scrollView.contentOffset.y<=-40&&scrollView.contentOffset.y>=-190) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
      
  } else if (scrollView.contentOffset.y>=-40) {
      scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
}
    
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
//        _tableView.tableHeaderView = self.headView;
    }
    return _tableView;
}
-(void)gotoVc:(NSMutableArray *)array type:(HKSelectbaseType)type{
    self.recruitParameter = nil;
    switch (type) {
        case HKSelectbaseType_salary:
            {
              
                self.recruitParameter.salaryId = [array.firstObject ID];
        
            }
            break;
        case HKSelectbaseType_city:
        {
            getChinaListAreas*area =array.lastObject;
            self.recruitParameter.areaId = area.code ;
        }
            break;
        case HKSelectbaseType_position:
        {
            self.recruitParameter.categoryId = [[array lastObject] ID];
        }
            break;
        default:
            break;
    }
    [self loadRecruit];
}
-(void)goToClick:(NSInteger)tag{
    HKSelectbaseViewController*vc = [[HKSelectbaseViewController alloc]init];
    vc.delegate = self;
    vc.type = (HKSelectbaseType)tag;
    self.navigationController.definesPresentationContext = YES;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
#pragma tableView--delegate
#pragma tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HKRecruitScreenView*view = [[HKRecruitScreenView alloc]init];
    view.delegate = self;
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recruitParameter.questionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKRecruitTableViewCell*cell = [HKRecruitTableViewCell baseCellWithTableView:tableView];
    cell.model = self.recruitParameter.questionArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKReseaesInfosViewController* vc = [[HKReseaesInfosViewController alloc] init];
    RecruitDataModel*item = self.recruitParameter.questionArray[indexPath.row];
    vc.recruitId = item.recruitId;
//    HK_RecruitPlayerView* vc = [[HK_RecruitPlayerView alloc] init];
//    RecruitDataModel*item = self.recruitParameter.questionArray[indexPath.row];
//    if (item.recruitId.length > 0) {
//        [vc addReRequestRecruiView:item.recruitId];
//    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(HKRecruitParameter *)recruitParameter{
    if (!_recruitParameter) {
        _recruitParameter = [[HKRecruitParameter alloc]init];
        _recruitParameter.loginUid = HKUSERLOGINID;
        _recruitParameter.pageNumber = 1;
    }
    return _recruitParameter;
}
@end
