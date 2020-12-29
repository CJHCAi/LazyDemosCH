//
//  HKLeSearchAllViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeSearchAllViewController.h"
#import "HKSearchAllViewTableViewCell.h"
#import "UIImage+CH.h"
#import "HKSearchView.h"
#import "HKLEFriendSearchViewModel.h"
#import "HKSearchTypeTableViewCell.h"
#import "HKLESearchBaseModel.h"
#import "SearchNabarView.h"
#import "HKSearchFootView.h"
#import "HKSearchCliFootView.h"
#import "HK_searchFriendView.h"
#import "HKCleSearch.h"
#import "HKSearchMessageViewController.h"
#import "HKSearchMessageInfoViewController.h"
#import "LEFriendSearchModel.h"
#import "HKMyCircleViewController.h"
#import "LEFriendSearchModel.h"
@interface HKLeSearchAllViewController ()<UITableViewDelegate,UITableViewDataSource,HKSearchAllViewTableViewCellDelegate,SearchNabarViewDelegate,HKSearchFootViewDelegate,HKSearchCliFootViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)SearchNabarView *nabarView;
@property (copy, nonatomic) NSString *searchText;
@end

@implementation HKLeSearchAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}

-(void)setUI{
    [self.view addSubview:self.nabarView];
    [self.view addSubview:self.tableView];
    [self.nabarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_offset(64);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.nabarView.mas_bottom);
    }];
//    self.avigationItem.titleView = searchView;
    
}
- (void)textChangeWithText:(NSString *)textStr{
    _searchText = textStr;
    [HKLEFriendSearchViewModel leFriendSearch:@{@"loginUid":HKUSERLOGINID,@"name":textStr} success:^(NSMutableArray *array) {
        self.dataArray = array;
        [self.tableView reloadData];
    }];
    
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchFriend {
    HK_searchFriendView *friendVc = [[HK_searchFriendView alloc]init];
    friendVc.searchText = _searchText;
    [self.navigationController pushViewController:friendVc animated:YES];
}
- (void)seachMessage {
    HKSearchMessageViewController*vc = [[HKSearchMessageViewController alloc]init];
    vc.searchText = self.searchText;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchcCicle {
    HKCleSearch*vc = [[HKCleSearch alloc]init];
    vc.searchText = _searchText;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count == 0) {
        return 1;
    }
 return   self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return 1;
    }
    HKLESearchBaseModel*model = self.dataArray[section];
    return [model.modelArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count == 0) {
        HKSearchAllViewTableViewCell*cell = [HKSearchAllViewTableViewCell searchAllViewTableViewCellWithTableView:tableView];
        
        cell.delegate = self;
        return cell;
    }
  
    HKSearchTypeTableViewCell *cell = [HKSearchTypeTableViewCell searchTypeCellWithTableView:tableView];
    HKLESearchBaseModel*model = self.dataArray[indexPath.section];
    [cell setModelWithType:model.type andModel:model.modelArray[indexPath.row]];
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return  nil;
    }
    UIView *view = [[UIView alloc]init];
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [view addSubview:label];
    UIView*lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    [view addSubview:lineView];
    view.backgroundColor = [UIColor whiteColor];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.right.bottom.equalTo(view);
        make.height.mas_equalTo(1);
    }];
    HKLESearchBaseModel*baseM = self.dataArray[section];
    if (baseM.type == 0) {
        label.text = @"好友";
    }else if (baseM.type == 1){
        label.text = @"消息";
    }else{
        label.text = @"圈子";
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return  0;
    }
    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return nil;
    }
    HKLESearchBaseModel*baseM = self.dataArray[section];
 
    
        if (baseM.type == 2) {
            HKSearchCliFootView *footerView = [[HKSearchCliFootView alloc]init];
            footerView.frame = CGRectMake(0, 0, kScreenWidth, 60);
            footerView.delegate = self;
            return footerView;
        }else{
            HKSearchFootView*footerView = [[HKSearchFootView alloc]init];
            footerView.frame = CGRectMake(0, 0, kScreenWidth, 50);
            footerView.type = baseM.type;
            footerView.delegate = self;
            return footerView;
        }
    return nil;
}
//-(UIView*)tableView:(UITableView *)tableView viewForInSection:(NSInteger)section{
//    HKLESearchBaseModel*baseM = self.dataArray[section];
//    if (baseM.type == 2) {
//        
//    }else{
//        
//    }
//    return nil;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return 0;
    }
    HKLESearchBaseModel*baseM = self.dataArray[section];
    if (baseM.type == 2) {
        return 60;
    }else {
        return 50;
    }
     
}
-(void)footerClick{
    [self searchcCicle];
    DLog(@"");
}
-(void)footerClickWithType:(int)type{
    if (type == 0) {
        [self searchFriend];
    }else{
        [self seachMessage];
    }
    DLog(@"");
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count == 0) {
        return;
    }
     HKLESearchBaseModel*baseM = self.dataArray[indexPath.section];
    
    
    if (baseM.type == 1) {
    RCSearchConversationResult *model = baseM.modelArray[indexPath.row];
//        HKSearchMessageInfoModel *messageM = [[HKSearchMessageInfoModel alloc]init];
//        messageM.rcModel = model;
//        messageM.count = 50;
//        messageM.searchText = self.searchText;
//        HKSearchMessageInfoViewController*vc = [[HKSearchMessageInfoViewController alloc]init];
//        vc.model = messageM;
//        [self.navigationController pushViewController:vc animated:YES];
        //进入聊天界面.
        HK_CladlyChattesView *chat = [[HK_CladlyChattesView alloc] init];
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = model.conversation.conversationType;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = model.conversation.targetId;
        //设置聊天会话界面要显示的标题
        if (model.conversation.conversationTitle.length) {
             chat.title = model.conversation.conversationTitle;
            
        }else {
            chat.title =@"消息";
        }
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
    }else if (baseM.type == 0){
      
        
        FriendsModel*frindM = baseM.modelArray[indexPath.row];
        
        HK_CladlyChattesView *chat = [[HK_CladlyChattesView alloc] init];
        
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = frindM.uid;
        
        //设置聊天会话界面要显示的标题
        chat.title = frindM.name;
        //显示聊天会话界面
        RCUserInfo *user = [[RCUserInfo alloc] init];
        user.userId = frindM.uid;
        user.name = frindM.name;
        user.portraitUri = frindM.headImg;
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:frindM.uid];
        
        HKMyFollowAndFansList *model =[[HKMyFollowAndFansList alloc] init];
        model.uid =frindM.uid;
        model.name =frindM.name;
        model.headImg =frindM.headImg;
        [AppUtils pushUserDetailInfoVcWithModel:model andCurrentVc:self];
        
      //  [self.navigationController pushViewController:chat animated:YES];
    }else if (baseM.type == 2){
   //进入圈子..
        CirclesModel* cirModel =baseM.modelArray[indexPath.row];
        HKMyCircleViewController*vc = [[HKMyCircleViewController alloc]init];
        vc.circleId = cirModel.circleId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return kScreenHeight - 64;
    }
    return 60;
}
@synthesize dataArray = _dataArray;

- (NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [ NSMutableArray array];
    }
    return _dataArray;
}
- (SearchNabarView *)nabarView
{
    if(_nabarView == nil)
    {
        _nabarView = [[ SearchNabarView alloc]init];
        _nabarView.delegate = self;
    }
    return _nabarView;
}
@end
