//
//  HK_GladlyFriendNewsView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_GladlyFriendNewsView.h"
#import <RongIMKit/RongIMKit.h>
//#import "RCConversationViewController.h"
//#import "HK_SelfMediaUserInfoView.h"

@interface HK_GladlyFriendNewsView ()
@end

@implementation HK_GladlyFriendNewsView

-(id)init
{
    self = [super init];
    if (self)
    {        
        //设置需要显示哪些类型的会话
        [self  setDisplayConversationTypes:@[@(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_CHATROOM), @(ConversationType_GROUP), @(ConversationType_APPSERVICE), @(ConversationType_SYSTEM)]];
        [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
        [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;

        [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
        self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}
- (void)viewDidLoad {
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(init) name:@"RCIMFrendNotification" object:nil];
    self.cellBackgroundColor = [UIColor whiteColor];
    self.conversationListTableView.tableFooterView =[[UIView alloc] init];
    self.emptyConversationView =[AppUtils setNoDataViewWithFrame:self.conversationListTableView andImageStr:@"zt_06"];
    
}
-(void)didReceiveMessageNotification:(NSNotification *)notification {
    [super didReceiveMessageNotification:notification];
    DLog(@"...notifi==%@",notification.object);
    
}
-(void)addChat:(RCConversationType)ConversationType targetString:(NSString *)targetid addTitle:(NSString *)title
{
    HK_CladlyChattesView *chat = [[HK_CladlyChattesView alloc] init];
    
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = targetid;
    
    //设置聊天会话界面要显示的标题
    chat.title = title;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

//点击cell的方法
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    HK_CladlyChattesView *chat = [[HK_CladlyChattesView alloc] init];

    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = model.conversationType;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = model.targetId;

    //设置聊天会话界面要显示的标题
    chat.title = model.conversationTitle;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
    
}

- (void)didTapCellPortrait:(RCConversationModel *)model
{
//    HK_SelfMediaUserInfoView* vc = [[HK_SelfMediaUserInfoView alloc] init];
//    [vc addReRequestUserView:model.targetId];
//    [self.navigationController pushViewController:vc animated:YES];
}

//cell即将显示的时候调用
-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
        RCConversationCell *conversationCell = (RCConversationCell *)cell;
        conversationCell.conversationTitle.textColor =UICOLOR_RGB_Alpha(0x333333, 1);

}
//左滑删除
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
