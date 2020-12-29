//
//  HKReseaesInfosViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKReseaesInfosViewController.h"
#import "HKReseaInfoCell.h"
#import "HKReleaseViewModel.h"
#import "RecruitInfoRespone.h"
#import "HKEnterpriseRecruitInfoViewController.h"
#import "HKHeadVodeoView.h"
#import "HKDeleverView.h"
#import "HK_RecruitTool.h"
@interface HKReseaesInfosViewController ()<UITableViewDelegate,UITableViewDataSource,HKReseaInfoCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)RecruitInfoRespone *resopne;
@property (nonatomic, strong)HKHeadVodeoView *vodeoView;
@property (nonatomic, strong)HKDeleverView *delevierV;
@end

@implementation HKReseaesInfosViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"招聘信息";
    [self setUI];
    [self loadData];
}
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppUtils setPopHidenNavBarForFirstPageVc:self];
}

-(void)loadData{
    [HKReleaseViewModel getRecruitInfo:@{@"recruitId":self.recruitId,@"loginUid":HKUSERLOGINID} success:^(RecruitInfoRespone *responde) {
        
        if (responde.responeSuc) {
            self.resopne = responde;
            self.vodeoView.uslString = responde.data.imgSrc;
            [self.tableView reloadData];
        }
    }];
}
-(void)setUI{
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50-SafeAreaBottomHeight);
    }];
    [self.view addSubview:self.delevierV];
//  WEAKSELF
    self.delevierV.sendBlock = ^(NSInteger sender,UIButton * btn) {
//        if (![LoginUserDataModel isHasSessionId]) {
//            [AppUtils presentLoadControllerWithCurrentViewController:weakSelf];
//            return ;
//        }
//        if (!sender) {
//            [AppUtils PushChatControllerWithType:ConversationType_PRIVATE uid:weakSelf.resopne.data.uid name:weakSelf.resopne.data.name headImg:weakSelf.resopne.data.headImg andCurrentVc:weakSelf];
//        }else {
//
//            [HK_RecruitTool deliverResumeWithResumeId:weakSelf.recruitId EnterPriseId:weakSelf.resopne.data.enterpriseId SuccessBlock:^{
//                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//                [SVProgressHUD showSuccessWithStatus:@"投递成功"];
//                btn.enabled = NO;
//
//            } fial:^(NSString *fail) {
//                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//                [SVProgressHUD showInfoWithStatus:fail];
//            }];
//        }
    };
}
-(HKDeleverView *)delevierV {
    if (!_delevierV) {
        _delevierV =[[HKDeleverView alloc] initWithFrame:CGRectMake(0,kScreenHeight -NavBarHeight -StatusBarHeight -50-SafeAreaBottomHeight,kScreenWidth,50)];
    }
    return _delevierV;
}

-(void)gotoCompanyInfo{
    HKEnterpriseRecruitInfoViewController*vc = [[HKEnterpriseRecruitInfoViewController alloc]init];
    vc.enterpriseId = self.resopne.data.enterpriseId;
    [self.navigationController pushViewController:vc animated:YES];
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
        _tableView.tableHeaderView = self.vodeoView;
        _tableView.showsVerticalScrollIndicator =NO;
//     WEAKSELF
        self.vodeoView.block = ^{
//            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKReseaInfoCell*cell = [HKReseaInfoCell baseCellWithTableView:tableView];
    if (self.resopne) {
        cell.respone = self.resopne;
    }
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(void)setRecruitId:(NSString *)recruitId{
    _recruitId = recruitId;
}
-(HKHeadVodeoView *)vodeoView{
    if (!_vodeoView) {
        _vodeoView = [[HKHeadVodeoView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
    }
    return _vodeoView;
}
@end
