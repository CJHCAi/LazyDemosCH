//
//  HKCompanyInfoController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCompanyInfoController.h"
#import "HKFrindInfoHeaderView.h"
#import "HKSelfMeidaVodeoViewModel.h"
#import "HKMyFriendListViewModel.h"
#import "SRActionSheet.h"
#import "HKComIntroCell.h"
#import "HKRecommendsCell.h"
#import "HKCorporateAdvertisingInfoViewController.h"
@interface HKCompanyInfoController ()<UITableViewDelegate,UITableViewDataSource,headBtnClickDelegete>

@property (nonatomic, strong)HKFrindInfoHeaderView * head;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)HKCompanyResPonse *reponse;
@property (nonatomic, assign)BOOL isSelect;

@end
@implementation HKCompanyInfoController

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(HKFrindInfoHeaderView *)head {
    if (!_head) {
        _head =[[HKFrindInfoHeaderView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,210)];
        _head.isCompany = YES;
        _head.delegete = self;
    }
    return _head;
}
-(void)TopInfoClickWithSender:(NSInteger)index {
    if (index ==10) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
       //关注..举报企业..
        [SRActionSheet sr_showActionSheetViewWithTitle:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@[@"关注",@"举报"] selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
            if (index ==0) {
                [HKSelfMeidaVodeoViewModel flowAddEnterpriseWithEnterpriseId:self.enterpriseId success:^(HKBaseResponeModel *responde) {
                    if (responde.responeSuc) {
                        [EasyShowTextView showText:@"关注成功"];
                    }
                }];
            }else {
                [HKMyFriendListViewModel addUserContentReportVc:self];
            }
        }];
    }
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    [self.view addSubview:self.tableView];
    [self loadComInfo];
    [self loadPublist];
}
-(void)loadPublist {
    [HKSelfMeidaVodeoViewModel getPublishHistoryWithEnterpriseId:self.enterpriseId andPage:self.page success:^(HKCompanyPublishResponse *responde) {

        if (self.page == responde.data.totalPage || responde.data.totalPage == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        } else {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }
        [self.dataArray addObjectsFromArray:responde.data.list];
        [self.tableView reloadData];
    }];
}
-(void)loadComInfo {
    [HKSelfMeidaVodeoViewModel getCompanyInfoWithEnterpriseId:self.enterpriseId success:^(HKCompanyResPonse *responde) {
        if (responde.code==0) {
            self.head.comRes =responde;
            self.reponse = responde;
            [self.tableView reloadData];
        }else {
        }
    }];
    
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,-StatusBarHeight, kScreenWidth,kScreenHeight+StatusBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource= self;
        _tableView.tableHeaderView = self.head;
        _tableView.bounces = NO;
        _tableView.estimatedRowHeight = 245;
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
        [_tableView registerClass:[HKComIntroCell class] forCellReuseIdentifier:@"info"];
    }
    return _tableView;
}
-(void)loadNextData {
    self.page ++;
    [self loadPublist];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        HKRecommendsCell*cell = [HKRecommendsCell baseCellWithTableView:tableView];
        cell.isPublish = YES;
        HKCompanyPublishList * list =self.dataArray[indexPath.row];
        cell.list = list;
        return cell;
    }
    HKComIntroCell * infoCell =[tableView dequeueReusableCellWithIdentifier:@"info" forIndexPath:indexPath];
    infoCell.response =self.reponse;
    infoCell.block = ^(BOOL isSelect) {
        self.isSelect = isSelect;
        [self.tableView reloadData];
    };
    return infoCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCompanyPublishList * list =self.dataArray[indexPath.row];
    HKCorporateAdvertisingInfoViewController*vc = [[HKCorporateAdvertisingInfoViewController alloc]init];
    vc.ID = list.advId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return self.dataArray.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        return  UITableViewAutomaticDimension;
    }
    if (self.isSelect) {
        return 110;
    }
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * b  =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,50)];
    b.backgroundColor =[UIColor whiteColor];
    UILabel * title =[[UILabel alloc] initWithFrame:CGRectMake(15,0,kScreenWidth-30,50)];
    [AppUtils getConfigueLabel:title font:BoldFont20 aliment:NSTextAlignmentLeft textcolor:[UIColor blackColor] text:@""];
    [b addSubview:title];
    if (section) {
        title.text =@"历史发布";
    }else {
        title.text =@"企业简介";
    }
    return b;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super  viewWillDisappear:animated];
     self.navigationController.navigationBarHidden = NO;
}
@end
