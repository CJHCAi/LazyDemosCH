//
//  HKMyCircleViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyCircleViewController.h"
#import "HKMyPostBaseTableViewCell.h"
#import "HKCollageShareView.h"
#import "HKMyCircleViewModel.h"
#import "HKMyCircleRespone.h"
#import "HKMyCircleData.h"
#import "HKMyPostViewModel.h"
#import "MyCocleHeadView.h"
#import "HKShareBaseModel.h"
//#import "HK_GladlyReleasePostView.h"
#import "HKClicleInfoViewController.h"
#import "HKPushViewController.h"
#import "HKMyPostsRespone.h"
#import "HKBaseParameter.h"
#import "HKBaseCartListViewController.h"
#import "HKProductsModel.h"
#import "HKPostPublishController.h"
#import "HKMyFriendListViewModel.h"
#import "HKPostDetailViewController.h"
#import "HKCicleProductController.h"
@interface HKMyCircleViewController ()<UITableViewDelegate,UITableViewDataSource,HKMyPostBaseTableViewCellDelegate,MyCocleHeadViewDelegate,RefreshDataDelegete>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property(nonatomic, assign) int pageNum;
@property (nonatomic, strong)HKMyCircleRespone *respone;
@property (nonatomic, strong)MyCocleHeadView *headView;
@property(nonatomic, assign) int type;
@property (nonatomic, strong)HKBaseParameter *parameter1;
@property (nonatomic, strong)HKBaseParameter *parameter2;
@property (nonatomic, strong)HKBaseParameter *parameter3;
@end

@implementation HKMyCircleViewController


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
//    [AppUtils setPopHidenNavBarForFirstPageVc:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = 1;
    self.title =@"圈子详情";
    self.tableView.mj_footer.hidden = YES;
    [self setUI];
    [self loadData];
    [self loadNewData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextData)];
    self.tableView.mj_footer.hidden = YES;
}
-(void)loadNewData{
    self.view.userInteractionEnabled = NO;
    [[self getHKBaseParameter].questionArray removeAllObjects];
    self.pageNum = 1;
    [self loadPostSuccess:^{
      self.view.userInteractionEnabled = YES;
    }];
}
-(void)loadNextData{
    self.view.userInteractionEnabled = NO;
    self.pageNum ++;
    [self loadPostSuccess:^{
        self.view.userInteractionEnabled = YES;
    }];
}
-(void)loadPostSuccess:(void (^)(void))success{
   HKBaseParameter*parameter = [self getHKBaseParameter];
    [HKMyCircleViewModel getCirclePost:@{@"loginUid":HKUSERLOGINID,@"circleId":self.circleId,@"pageNumber":@(parameter.pageNumber),@"state":@(self.type)} success:^(HKMyPostsRespone *responde) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        success();
        if (responde.responeSuc) {
            if (responde.data.lastPage) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
            
            [[[self getHKBaseParameter]questionArray] addObjectsFromArray:responde.data.list];
            [self.tableView reloadData];
        }else{
            if (self.pageNum >1) {
                self.pageNum--;
            }
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
        }
    }];
}
-(void)loadData{
    
    DLog(@"self.cicleId ==%@",self.circleId);
    
    [HKMyCircleViewModel myCircle:@{@"loginUid":HKUSERLOGINID,@"circleId":self.circleId} success:^(HKMyCircleRespone *responde) {
        self.respone = responde;
        self.headView.model = responde.data;
        self.tableView.tableHeaderView = self.headView;
    
    }];

}
-(void)setUI{
    UIButton *bbt = [HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectMake(-10, 0, 30, 30) taget:self action:@selector(publish) supperView:nil];
    [bbt setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_more"] forState:0];
    UIButton *bbt2 = [HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectMake(-10, 0, 30, 30) taget:self action:@selector(notice) supperView:nil];
    [bbt2 setBackgroundImage:[UIImage imageNamed:@"self_push"] forState:0];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:bbt],[[UIBarButtonItem alloc]initWithCustomView:bbt2]]; ;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)notice{
    HKPushViewController *pushVc = [[HKPushViewController alloc]init];
    [self.navigationController pushViewController:pushVc animated:YES];
}
-(void)publish{
    [self gotoRightView];
}
-(void)toAddGroup{
    if (self.respone.data.state==1) {
#pragma mark 掉加入圈子接口 完成刷新列表
        [HKMyCircleViewModel addGroup:@{@"loginUid":HKUSERLOGINID,@"circleId":self.circleId} success:^(HKBaseResponeModel *responde) {
            if (responde.responeSuc) {
                [SVProgressHUD  setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showSuccessWithStatus:(NSString *)responde.data];
                [self loadData];
            }
        }];
//     //未加入进入圈子资料界面
//        HKClicleInfoViewController *chat = [[HKClicleInfoViewController alloc] init];
//        chat.circleId = self.circleId;
//        chat.dataModel = self.respone.data;
//        chat.block = ^(int state) {
//            [self loadData];
//        };
//        [self.navigationController pushViewController:chat animated:YES];
    }
#pragma mark   已经是成员 直接聊天
    else {
        
        [self jionGroup];
    }
}
-(void)toVcheadBtnClick{
    [self gotoDataView];
}
-(void)shareWithModel:(HKMyPostModel *)model{
    HKShareBaseModel*shareM = [[HKShareBaseModel alloc]init];
    shareM.postModel = model;
    shareM.subVc = self;
    [HKCollageShareView showSelfBotomWithselectSheetBlock:nil shareModel:shareM];
    
}
-(void)commitWithModel:(HKMyPostModel *)model{
    
    [self pushPostDetailWithPostId:model.postId];
}
-(void)praiseWithModel:(HKMyPostModel *)model{
    [self pushPostDetailWithPostId:model.postId];
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
        _tableView.tableHeaderView = self.headView;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self getHKBaseParameter]questionArray]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKMyPostModel*model = [[self getHKBaseParameter]questionArray][indexPath.row];
    HKMyPostBaseTableViewCell *cell = [HKMyPostViewModel tableView:tableView cellForRowAtIndexPath:indexPath model:model];
    cell.delegate = self;
    cell.model = model;
    return cell;
}
//弹出底部actionSheet
-(void)showActionSheetWithModel:(HKMyPostModel *)model andIndexPath:(NSIndexPath *)path{
    [SRActionSheet sr_showActionSheetViewWithTitle:@"" cancelButtonTitle:@"取消" destructiveButtonTitle:@"" otherButtonTitles:@[@"加入黑名单",@"举报该动态"] selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger index) {
        if (index ==0) {
            [self addUserToBlackListWithUid:model.uid];
        }else {
            [self ReportUser];
        }
    }];
}
#pragma mark 加入黑名单
-(void)addUserToBlackListWithUid:(NSString *)uid {
    
    [HKMyFriendListViewModel addFriendToBlackListWithUserId:uid success:^(id response) {
        [EasyShowTextView showText:@"成功加入黑名单"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addBlackList" object:nil];
        [AppUtils hanldeSuccessPopAfterSecond:1.5 WithCunrrentController:self];
        
    } fial:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
#pragma mark 举报
-(void)ReportUser {
    
    [HKMyFriendListViewModel addUserContentReportVc:self];
}
-(void)showUserDetailWithModel:(HKMyPostModel *)model {
    HKMyFollowAndFansList *list =[[HKMyFollowAndFansList alloc] init];
    list.headImg = model.headImg;
    list.uid = model.uid;
    list.name =model.uName;
    [AppUtils pushUserDetailInfoVcWithModel:list andCurrentVc:self];
}
-(void)gotoShoppingVc:(NSInteger)tag{
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HKProductsModel*model = self.respone.data.products[tag];
    HKCicleProductController *vc =[[HKCicleProductController alloc] init];
    vc.productId =model.productId;
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)swichSenderTag:(NSInteger)index {
    self.type =(int)index;
    [self loadNewData];
}

#pragma mark  点击置顶 和公告 进入post
-(void)pushNoticeWithPostId:(NSString *)postId {
    
    [self pushPostDetailWithPostId:postId];
}
-(void)pushTopPostWithPostId:(NSString *)postId {
    [self pushPostDetailWithPostId:postId];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    HKMyPostModel*model = [[self getHKBaseParameter]questionArray][indexPath.row];
    [self pushPostDetailWithPostId:model.postId];
}
-(void)pushPostDetailWithPostId:(NSString *)postId {
    HKPostDetailViewController *detailVc =[[HKPostDetailViewController alloc] init];
    detailVc.postID  =postId;
    detailVc.block = ^{
         [self loadNewData];
    };
    [self.navigationController pushViewController:detailVc animated:YES];
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [ NSMutableArray array];
    }
    return _questionArray;
}
-(MyCocleHeadView *)headView{
    if (!_headView) {
        _headView  = [[MyCocleHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 375)];
        _headView.delegate = self;
    }
    return _headView;
}
-(void)gotoRightView
{
     HKPostPublishController *pubVc =[[HKPostPublishController alloc] init];
    pubVc.circleId = self.circleId;
    pubVc.respone = self.respone;
    pubVc.delegete = self;
    [self.navigationController pushViewController:pubVc animated:YES];
    
}
-(void)getNewPost {
    [self loadNewData];
}
-(void)jionGroup
{
    HK_CladlyChattesView *chat = [[HK_CladlyChattesView alloc] init];
    
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_GROUP;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = self.respone.data.ID;
    
    //设置聊天会话界面要显示的标题
    chat.title = self.respone.data.name;
    //显示聊天会话界面
    chat.cicleId = self.circleId;
    RCGroup *user = [[RCGroup alloc] init];
    user.groupId = self.respone.data.ID;
    user.groupName = self.respone.data.name;
    user.portraitUri = self.respone.data.coverImgSrc;
    [[RCIM sharedRCIM] refreshGroupInfoCache:user withGroupId:self.respone.data.ID];
  
    //退出圈子刷新数据
    chat.block = ^{
        [self loadData];
    };
    [self.navigationController pushViewController:chat animated:YES];
}
-(void)gotoDataView
{
    HKClicleInfoViewController *chat = [[HKClicleInfoViewController alloc] init];
//    [chat addReRequest:self.circleId];
    chat.circleId = self.circleId;
    chat.dataModel = self.respone.data;
    chat.block = ^(int state) {
        [self loadData];
    };
    [self.navigationController pushViewController:chat animated:YES];
}
-(HKBaseParameter*)getHKBaseParameter{
    if (self.type == 1) {
        return self.parameter1;
    }else if (self.type == 2){
        return self.parameter2;
    }else{
        return self.parameter3;
    }
}
-(HKBaseParameter *)parameter1{
    if (!_parameter1) {
        _parameter1 = [[HKBaseParameter alloc]init];;
        _parameter1.staueType = 1;
        _parameter1.pageNumber = 1;
    }
    return _parameter1;
}
-(HKBaseParameter *)parameter2{
    if (!_parameter2) {
        _parameter2 = [[HKBaseParameter alloc]init];;
        _parameter2.staueType = 2;
        _parameter2.pageNumber = 1;
    }
    return _parameter2;
}
-(HKBaseParameter *)parameter3{
    if (!_parameter3) {
        _parameter3 = [[HKBaseParameter alloc]init];;
        _parameter3.staueType = 3;
        _parameter3.pageNumber = 1;
    }
    return _parameter3;
}
@end
