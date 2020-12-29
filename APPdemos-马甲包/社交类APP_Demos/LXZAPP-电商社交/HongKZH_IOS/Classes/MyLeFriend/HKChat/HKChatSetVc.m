//
//  HKChatSetVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKChatSetVc.h"
#import "HKBaseRowTableViewCell.h"
#import "HKFriendInfoRowView.h"
#import "LEFriendDbManage.h"
#import "HKLeCircleDbManage.h"
#import "HKMyFriendListViewModel.h"
#import "HKMyCircleViewModel.h"
#import "HKUserContentReportController.h"
#import "HKShareBaseModel.h"
#import "HKCollageShareView.h"
#import "UIAlertView+Blocks.h"
#import "HKMyCircleViewController.h"
#import "HKMyFollowAndFans.h"
#import "HKFrindMainVc.h"
@interface HKChatSetVc ()<UITableViewDelegate,UITableViewDataSource,HKFriendInfoRowViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)HKFriendInfoRowView *headView;
@property (nonatomic, strong)HKFriendModel *friend;
@property (nonatomic, strong)HKClicleListModel *cicle;
@end

@implementation HKChatSetVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"聊天设置";
    [self setUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
        _tableView.tableHeaderView = self.headView;
    }
    return _tableView;
}
-(void)goToInfo{
    if (self.type == 0) {
        HKFrindMainVc*vc = [[HKFrindMainVc alloc]init];
        
        HKMyFollowAndFansList*listM = [[HKMyFollowAndFansList alloc]init];
        listM.uid = self.userId;
        listM.headImg = self.friend.headImg;
        listM.sex = self.friend.sex;
        listM.name = self.friend.name;
        listM.level = self.friend.level;
        vc.listModel = listM;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HKMyCircleViewController*vc = [[HKMyCircleViewController alloc]init];
        vc.circleId = self.cicleId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma tableView--delegate
#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKBaseRowTableViewCell*cell = [HKBaseRowTableViewCell baseCellWithTableView:tableView];
    cell.name = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.type == 0) {
            [self addUserToBlackList];
        }else{
            [self quitCircle];
        }
    }else if(indexPath.row == 1){
        
        if (self.type == 0) {
            HKShareBaseModel*share = [[HKShareBaseModel alloc]init];
            share.subVc = self;
            share.friendM = self.friend;
              [HKCollageShareView showSelfBotomWithselectSheetBlock:nil shareModel:share];
        }else{
            HKUserContentReportController*vc = [[HKUserContentReportController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
      
    }else{
        HKUserContentReportController*vc = [[HKUserContentReportController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)setType:(int)type{
    _type = type;
    if (type == 0) {
        self.dataArray = @[@"加入黑名单",@"推荐TA给朋友",@"举报该人"];
    }else{
        self.dataArray = @[@"退出圈子",@"举报圈子"];
    }
}
-(HKFriendInfoRowView *)headView{
    if (!_headView) {
        _headView = [[HKFriendInfoRowView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
        _headView.delegate = self;
    }
    return _headView;
}
-(void)setCicleId:(NSString *)cicleId{
    _cicleId = cicleId;
     self.type = 1;
    HKClicleListModel*queryM = [[HKClicleListModel alloc]init];
    queryM.circleId = cicleId;
    HKClicleListModel *model  =(HKClicleListModel*) [[LEFriendDbManage sharedZSDBManageBaseModel]queryWithModel:queryM];
    self.cicle = model;
    [self.headView settingInfoWithName:model.circleName sex:-1 desc:@"" headImage:model.coverImgSrc];
    [self.tableView reloadData];
    
}
-(void)setUserId:(NSString *)userId{
    _userId = userId;
    self.type = 0;
    HKFriendModel*queryM = [[HKFriendModel alloc]init];
    queryM.uid = userId;
    HKFriendModel *model  =(HKFriendModel*) [[LEFriendDbManage sharedZSDBManageBaseModel]queryWithModel:queryM];
    self.friend = model;
    [self.headView settingInfoWithName:model.name sex:model.sex.integerValue desc:@"" headImage:model.headImg];
//    [self.tableView reloadData];
}
-(void)quitCircle{
    //退出圈子1d02f8a1ced4423bba4a28114300de7b
    [HKMyCircleViewModel quitCicle:@{kloginUid:HKUSERLOGINID,@"circleId ":self.cicleId} success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
          
           
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [EasyShowTextView showText:@"操作失败"];
        }
    }];

}
-(void)addUserToBlackList {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"确定加入黑名单" cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil] otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
        [HKMyFriendListViewModel addFriendToBlackListWithUserId:self.userId success:^(id response) {
            [EasyShowTextView showText:@"成功加入黑名单"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addBlackList" object:nil];
            [AppUtils hanldeSuccessPopAfterSecond:1.5 WithCunrrentController:self];
            
        } fial:^(NSString *error) {
            [EasyShowTextView showText:error];
        }];
    }], nil];
    [alertView show];

}
@end
