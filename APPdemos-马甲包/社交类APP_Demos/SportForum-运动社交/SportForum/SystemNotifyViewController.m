//
//  SystemNotifyViewController.m
//  SportForum
//
//  Created by liyuan on 14-7-2.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "SystemNotifyViewController.h"
#import "ArticlePagesViewController.h"
#import "LeftSwipeTableViewController.h"
#import "SystemNotifyCell.h"
#import "SportForum.h"
#import "CommonUtility.h"
#import "AlertManager.h"
#import "UIViewController+SportFormu.h"
#import "AccountPreViewController.h"
#import "RecordReceiveHeartViewController.h"
#import "RunShareViewController.h"
#import "ThumbShareViewController.h"
#import "PKShareViewController.h"
#import "AccountEditViewController.h"

@interface SystemNotifyViewController () <LeftSwipeTableViewDelegate>{
    NSMutableArray * _dataArray;
    NSMutableArray * _dataArticles;
    BOOL _bEdit;
    NSTimer * m_timeGetSystemNotifyInfos;
    
    LeftSwipeTableViewController *m_tableView;
    UIActivityIndicatorView *m_activityIndicatorMain;
}

@end

@implementation SystemNotifyViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _dataArray = [[NSMutableArray alloc]init];
        _dataArticles = [[NSMutableArray alloc]init];
        m_timeGetSystemNotifyInfos = nil;
    }
    
    return self;
}

- (void)viewDidLoadGUI
{
    [self generateCommonViewInParent:self.view Title:@"系统消息" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    rect = CGRectMake(0, 5, viewBody.frame.size.width, viewBody.frame.size.height - 10);
    m_tableView = [[LeftSwipeTableViewController alloc] initWithFrame:rect];
    m_tableView.leftSwipeTableViewDelegate = self;
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.separatorColor = [UIColor clearColor];
    [m_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SystemCell"];
    
    if ([m_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [m_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [viewBody addSubview:m_tableView];
    
    [m_tableView enablePullRefreshHeaderViewTarget:self DidTriggerRefreshAction:@selector(actionPullHeaderRefresh)];
    [m_tableView enablePullRefreshFooterViewTarget:self DidTriggerRefreshAction:@selector(actionPullFooterRefresh)];
    [m_tableView.tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    UIImageView *imgViewNew = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
    [imgViewNew setImage:[UIImage imageNamed:@"nav-eraser-btn"]];
    [self.view addSubview:imgViewNew];
    
    CSButton *btnNew = [CSButton buttonWithType:UIButtonTypeCustom];
    btnNew.frame = CGRectMake(CGRectGetMinX(imgViewNew.frame) - 5, CGRectGetMinY(imgViewNew.frame) - 5, 45, 45);
    btnNew.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnNew];
    [self.view bringSubviewToFront:btnNew];
    
    __weak __typeof(self) weakSelf = self;
    
    btnNew.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;

        strongSelf->_bEdit = !strongSelf->_bEdit;
        [strongSelf->m_tableView reloadData];
    };
    
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 20.0f, 20.0f)];
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 48) / 2, (CGRectGetHeight(viewBody.frame) - 48) / 2, 48, 48)];
    m_activityIndicatorMain.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    m_activityIndicatorMain.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
    m_activityIndicatorMain.hidden = NO;
    m_activityIndicatorMain.hidesWhenStopped = YES;
    [viewBody addSubview:m_activityIndicatorMain];
    
    [m_activityIndicatorMain startAnimating];
}

- (void)viewDidLoadData
{
    __weak __typeof(self) thisPointer = self;
    
    if ([ApplicationContext sharedInstance].accountInfo != nil) {
        [[SportForumAPI sharedInstance]eventNewsDetails:^void(int errorCode, EventNewsDetails* eventNewsDetails)
         {
             __typeof(self) strongThis = thisPointer;
             
             if (strongThis == nil) {
                 return;
             }
             
             [m_activityIndicatorMain stopAnimating];
             [m_tableView completePullHeaderRefresh];
             [m_tableView completePullFooterRefresh];
             
             if (errorCode == 0) {
                 [_dataArray removeAllObjects];

                 for (MsgWsInfo *msgWsInfo in eventNewsDetails.event_news.data) {
                     SystemNotifyItem *systemNotifyItem = [[SystemNotifyItem alloc]init];
                     systemNotifyItem.strPid = msgWsInfo.push.pid;
                     systemNotifyItem.strFrom = msgWsInfo.push.from;
                     systemNotifyItem.unReadCount = 1;
                     systemNotifyItem.time = [NSDate dateWithTimeIntervalSince1970:msgWsInfo.time];
                     
                     for (MsgWsBodyItem *msgWsBodyItem in msgWsInfo.push.body.data) {
                         if ([msgWsBodyItem.type isEqualToString:@"image"]) {
                             systemNotifyItem.strImage = msgWsBodyItem.content;
                         }
                         else if([msgWsBodyItem.type isEqualToString:@"new_count"])
                         {
                             systemNotifyItem.unReadCount = [msgWsBodyItem.content intValue];
                         }
                         else if([msgWsBodyItem.type isEqualToString:@"total_count"])
                         {
                             systemNotifyItem.unTotalCount = [msgWsBodyItem.content intValue];
                         }
                         else if([msgWsBodyItem.type isEqualToString:@"nikename"])
                         {
                             systemNotifyItem.strNikeName = msgWsBodyItem.content;
                         }
                         else if([msgWsBodyItem.type isEqualToString:@"userid"])
                         {
                             systemNotifyItem.strUserId = msgWsBodyItem.content;
                         }
                         else if([msgWsBodyItem.type isEqualToString:@"record_id"])
                         {
                             systemNotifyItem.strRecordId = msgWsBodyItem.content;
                         }
                         else if([msgWsBodyItem.type isEqualToString:@"latlng"])
                         {
                             systemNotifyItem.strLatlng = msgWsBodyItem.content;
                         }
                         else if([msgWsBodyItem.type isEqualToString:@"locaddr"])
                         {
                             systemNotifyItem.strLocAddr = msgWsBodyItem.content;
                         }
                         else if([msgWsBodyItem.type isEqualToString:@"article_id"])
                         {
                             systemNotifyItem.strArticleId = msgWsBodyItem.content;
                         }
                         else if([msgWsBodyItem.type isEqualToString:@"time"])
                         {
                             systemNotifyItem.lRunBeginTime = [msgWsBodyItem.content longLongValue];
                         }
                         else if([msgWsBodyItem.type isEqualToString:@"addr_image"])
                         {
                             systemNotifyItem.strMapUrl = msgWsBodyItem.content;
                         }
                     }
                     
                     if ([msgWsInfo.push.type isEqualToString:@"subscribe"]) {
                         systemNotifyItem.eNotifyType = e_notify_subscribe;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"thumb"]){
                         systemNotifyItem.eNotifyType = e_notify_thumb;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"comment"]){
                         systemNotifyItem.eNotifyType = e_notify_comment;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"at"]){
                         systemNotifyItem.eNotifyType = e_notify_at;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"record"]){
                         systemNotifyItem.eNotifyType = e_notify_record;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"coach"]){
                         systemNotifyItem.eNotifyType = e_notify_coach_comment;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"coachpass"]){
                         systemNotifyItem.eNotifyType = e_notify_coach_pass_comment;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"coachnpass"]){
                         systemNotifyItem.eNotifyType = e_notify_coach_npass_comment;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"reward"]){
                         systemNotifyItem.eNotifyType = e_notify_reward;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"tx"]){
                         systemNotifyItem.eNotifyType = e_notify_tx;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"sendheart"])
                     {
                         systemNotifyItem.eNotifyType = e_notify_send_heart;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"recvheart"])
                     {
                         systemNotifyItem.eNotifyType = e_notify_receive_heart;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"runshare"])
                     {
                         systemNotifyItem.eNotifyType = e_notify_runshare;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"runshared"])
                     {
                         systemNotifyItem.eNotifyType = e_notify_runshared;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"postshare"])
                     {
                         systemNotifyItem.eNotifyType = e_notify_postshare;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"postshared"])
                     {
                         systemNotifyItem.eNotifyType = e_notify_postshared;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"pkshare"])
                     {
                         systemNotifyItem.eNotifyType = e_notify_pkshare;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"pkshared"])
                     {
                         systemNotifyItem.eNotifyType = e_notify_pkshared;
                         [_dataArray addObject:systemNotifyItem];
                     }
                     else if([msgWsInfo.push.type isEqualToString:@"info"])
                     {
                         systemNotifyItem.eNotifyType = e_notify_info;
                         systemNotifyItem.strImage = [ApplicationContext sharedInstance].accountInfo.profile_image;
                         [_dataArray addObject:systemNotifyItem];
                     }
                }
                 
                 if ([_dataArray count] > 0) {
                     [_dataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                         SystemNotifyItem *systemNotifyItem1 = obj1;
                         SystemNotifyItem *systemNotifyItem2 = obj2;
                         return [systemNotifyItem2.time compare:systemNotifyItem1.time];
                     }];
                 }
                 
                 [m_tableView reloadData];
                 
                 if ([_dataArray count] == 0) {
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             }
         }];
    }
}

-(void)initNotifyMsg
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWebSocketMsgComing:) name:NOTIFY_MESSAGE_WEBSOCKET_COMING object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotifyMsg];
    
    _bEdit = NO;
    [self viewDidLoadGUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewDidLoadData];
    [MobClick beginLogPageView:@"系统通知 - SystemNotifyViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"系统通知 - SystemNotifyViewController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [m_timeGetSystemNotifyInfos invalidate];
    m_timeGetSystemNotifyInfos = nil;
    [MobClick endLogPageView:@"系统通知 - SystemNotifyViewController"];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlEventNewsDetails, nil]];
    [super viewWillDisappear:animated];
}

- (void)handleWebSocketMsgComing:(NSNotification*) notification
{
    NSMutableArray *arrSystemNotifyInfo = [[notification userInfo]objectForKey:@"WSSystemNotifyList"];
    
    for (MsgWsInfo *systemWsInfo in arrSystemNotifyInfo) {
        BOOL bExist = NO;
        e_notify_type eNotifyType = e_notify_comment;
        
        if ([systemWsInfo.push.type isEqualToString:@"thumb"]) {
            eNotifyType = e_notify_thumb;
        }
        else if([systemWsInfo.push.type isEqualToString:@"comment"])
        {
            eNotifyType = e_notify_comment;
        }
        else if([systemWsInfo.push.type isEqualToString:@"at"]){
            eNotifyType = e_notify_at;
        }
        else if([systemWsInfo.push.type isEqualToString:@"record"]){
            eNotifyType = e_notify_record;
        }
        else if([systemWsInfo.push.type isEqualToString:@"coach"])
        {
            eNotifyType = e_notify_coach_comment;
        }
        else if([systemWsInfo.push.type isEqualToString:@"coachpass"]){
            eNotifyType = e_notify_coach_pass_comment;
        }
        else if([systemWsInfo.push.type isEqualToString:@"coachnpass"]){
            eNotifyType = e_notify_coach_npass_comment;
        }
        else if([systemWsInfo.push.type isEqualToString:@"subscribe"])
        {
            eNotifyType = e_notify_subscribe;
        }
        else if([systemWsInfo.push.type isEqualToString:@"reward"])
        {
            eNotifyType = e_notify_reward;
        }
        else if([systemWsInfo.push.type isEqualToString:@"tx"])
        {
            eNotifyType = e_notify_tx;
        }
        else if([systemWsInfo.push.type isEqualToString:@"sendheart"])
        {
            eNotifyType = e_notify_send_heart;
        }
        else if([systemWsInfo.push.type isEqualToString:@"recvheart"])
        {
            eNotifyType = e_notify_receive_heart;
        }
        else if([systemWsInfo.push.type isEqualToString:@"runshare"])
        {
            eNotifyType = e_notify_runshare;
        }
        else if([systemWsInfo.push.type isEqualToString:@"runshared"])
        {
            eNotifyType = e_notify_runshared;
        }
        else if([systemWsInfo.push.type isEqualToString:@"postshare"])
        {
            eNotifyType = e_notify_postshare;
        }
        else if([systemWsInfo.push.type isEqualToString:@"postshared"])
        {
            eNotifyType = e_notify_postshared;
        }
        else if([systemWsInfo.push.type isEqualToString:@"pkshare"])
        {
            eNotifyType = e_notify_pkshare;
        }
        else if([systemWsInfo.push.type isEqualToString:@"pkshared"])
        {
            eNotifyType = e_notify_pkshared;
        }
        else if([systemWsInfo.push.type isEqualToString:@"info"])
        {
            eNotifyType = e_notify_info;
        }

        for (SystemNotifyItem *systemNotifyItem in _dataArray) {
            if ([systemNotifyItem.strPid isEqualToString:systemWsInfo.push.pid] && systemNotifyItem.eNotifyType == eNotifyType) {
                bExist = YES;
                systemNotifyItem.time = [NSDate dateWithTimeIntervalSince1970:systemWsInfo.time];
                
                for (MsgWsBodyItem *msgWsBodyItem in systemWsInfo.push.body.data) {
                    if([msgWsBodyItem.type isEqualToString:@"total_count"])
                    {
                        systemNotifyItem.unTotalCount = [msgWsBodyItem.content intValue];
                    }
                    else if ([msgWsBodyItem.type isEqualToString:@"new_count"]) {
                        systemNotifyItem.unReadCount = [msgWsBodyItem.content intValue];
                    }
                    else if([msgWsBodyItem.type isEqualToString:@"userid"])
                    {
                        systemNotifyItem.strUserId = msgWsBodyItem.content;
                    }
                    else if([msgWsBodyItem.type isEqualToString:@"record_id"])
                    {
                        systemNotifyItem.strRecordId = msgWsBodyItem.content;
                    }
                    else if([msgWsBodyItem.type isEqualToString:@"latlng"])
                    {
                        systemNotifyItem.strLatlng = msgWsBodyItem.content;
                    }
                    else if([msgWsBodyItem.type isEqualToString:@"locaddr"])
                    {
                        systemNotifyItem.strLocAddr = msgWsBodyItem.content;
                    }
                    else if([msgWsBodyItem.type isEqualToString:@"article_id"])
                    {
                        systemNotifyItem.strArticleId = msgWsBodyItem.content;
                    }
                    else if([msgWsBodyItem.type isEqualToString:@"time"])
                    {
                        systemNotifyItem.lRunBeginTime = [msgWsBodyItem.content longLongValue];
                    }
                    else if([msgWsBodyItem.type isEqualToString:@"addr_image"])
                    {
                        systemNotifyItem.strMapUrl = msgWsBodyItem.content;
                    }
                }

                break;
            }
        }
        
        if (!bExist) {
            SystemNotifyItem *systemNotifyItem = [[SystemNotifyItem alloc]init];
            systemNotifyItem.strPid = systemWsInfo.push.pid;
            systemNotifyItem.strFrom = systemWsInfo.push.from;
            systemNotifyItem.time = [NSDate dateWithTimeIntervalSince1970:systemWsInfo.time];
            systemNotifyItem.unReadCount = 1;
            systemNotifyItem.eNotifyType = eNotifyType;
            
            for (MsgWsBodyItem *msgWsBodyItem in systemWsInfo.push.body.data) {
                if ([msgWsBodyItem.type isEqualToString:@"image"]) {
                    systemNotifyItem.strImage = msgWsBodyItem.content;
                }
                else if([msgWsBodyItem.type isEqualToString:@"nikename"])
                {
                    systemNotifyItem.strNikeName = msgWsBodyItem.content;
                }
                else if([msgWsBodyItem.type isEqualToString:@"total_count"])
                {
                    systemNotifyItem.unTotalCount = [msgWsBodyItem.content intValue];
                }
                else if ([msgWsBodyItem.type isEqualToString:@"new_count"]) {
                    systemNotifyItem.unReadCount = [msgWsBodyItem.content intValue];
                }
                else if([msgWsBodyItem.type isEqualToString:@"userid"])
                {
                    systemNotifyItem.strUserId = msgWsBodyItem.content;
                }
                else if([msgWsBodyItem.type isEqualToString:@"record_id"])
                {
                    systemNotifyItem.strRecordId = msgWsBodyItem.content;
                }
                else if([msgWsBodyItem.type isEqualToString:@"latlng"])
                {
                    systemNotifyItem.strLatlng = msgWsBodyItem.content;
                }
                else if([msgWsBodyItem.type isEqualToString:@"locaddr"])
                {
                    systemNotifyItem.strLocAddr = msgWsBodyItem.content;
                }
                else if([msgWsBodyItem.type isEqualToString:@"article_id"])
                {
                    systemNotifyItem.strArticleId = msgWsBodyItem.content;
                }
                else if([msgWsBodyItem.type isEqualToString:@"time"])
                {
                    systemNotifyItem.lRunBeginTime = [msgWsBodyItem.content longLongValue];
                }
                else if([msgWsBodyItem.type isEqualToString:@"addr_image"])
                {
                    systemNotifyItem.strMapUrl = msgWsBodyItem.content;
                }
            }
            
            if(eNotifyType == e_notify_info)
            {
                systemNotifyItem.strImage = [ApplicationContext sharedInstance].accountInfo.profile_image;
            }
            
            [_dataArray insertObject:systemNotifyItem atIndex:0];
        }
    }
    
    if ([arrSystemNotifyInfo count] > 0) {
        if ([_dataArray count] > 0) {
            [_dataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                SystemNotifyItem *systemNotifyItem1 = obj1;
                SystemNotifyItem *systemNotifyItem2 = obj2;
                return [systemNotifyItem2.time compare:systemNotifyItem1.time];
            }];
        }
        
        [m_tableView reloadData];
    }
}

- (void)restartTimer_updateCellTime
{
    if (m_timeGetSystemNotifyInfos != nil && [m_timeGetSystemNotifyInfos isValid]) {
        [m_timeGetSystemNotifyInfos invalidate];
    }
    
    m_timeGetSystemNotifyInfos = [NSTimer scheduledTimerWithTimeInterval: 10
                                                                target: self
                                                              selector: @selector(viewDidLoadData)
                                                              userInfo: nil
                                                               repeats: NO];
}

-(void)actionPullHeaderRefresh {
    NSLog(@"loading header.....");
    //[self.tableView completePullHeaderRefresh];
    [self viewDidLoadData];
}

-(void)actionPullFooterRefresh {
    NSLog(@"loading footer.....");
    [self viewDidLoadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"SystemNotifyViewController dealloc called!");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source
- (NSInteger) numberOfCells:(LeftSwipeTableViewController *)leftSwipeTableViewController
{
    return _dataArray.count;
}

- (UITableViewCell *) leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView RowIndex:(NSIndexPath *)indexPath
{
    SystemNotifyItem *systemNotifyItem = _dataArray[indexPath.row];
    SystemNotifyCell *cell = [leftSwipeTableView dequeueReusableCellWithIdentifier:@"SystemNotifyCell"];
    
    if (cell == nil) {
        cell = [[SystemNotifyCell alloc]initWithReuseIdentifier:@"SystemNotifyCell"];
    }
    
    __weak __typeof(self) weakSelf = self;
    
    cell.delClickBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->_dataArray removeObjectAtIndex:indexPath.row];
        [leftSwipeTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [leftSwipeTableView reloadData];
        
        event_type eEventType = event_type_subscribe;
        
        if (systemNotifyItem.eNotifyType == e_notify_comment) {
            eEventType = event_type_comment;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_coach_comment) {
            eEventType = event_type_coach_comment;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_coach_pass_comment){
            eEventType = event_type_coach_pass_comment;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_coach_npass_comment){
            eEventType = event_type_coach_npass_comment;
        }
        else if (systemNotifyItem.eNotifyType == e_notify_thumb) {
            eEventType = event_type_thumb;
        }
        else if (systemNotifyItem.eNotifyType == e_notify_subscribe) {
            eEventType = event_type_subscribe;
        }
        else if (systemNotifyItem.eNotifyType == e_notify_reward) {
            eEventType = event_type_reward;
        }
        else if (systemNotifyItem.eNotifyType == e_notify_tx) {
            eEventType = event_type_tx;
        }
        else if (systemNotifyItem.eNotifyType == e_notify_at) {
            eEventType = event_type_at;
        }
        else if (systemNotifyItem.eNotifyType == e_notify_record) {
            eEventType = event_type_record;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_send_heart)
        {
            eEventType = event_type_send_heart;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_receive_heart)
        {
            eEventType = event_type_receive_heart;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_runshare)
        {
            eEventType = event_type_run_share;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_runshared)
        {
            eEventType = event_type_run_shared;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_postshare)
        {
            eEventType = event_type_post_share;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_postshared)
        {
            eEventType = event_type_post_shared;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_pkshare)
        {
            eEventType = event_type_pk_share;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_pkshared)
        {
            eEventType = event_type_pk_shared;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_info)
        {
            eEventType = event_type_info;
        }
        
        [[SportForumAPI sharedInstance]eventChangeStatusReadByEventType:eEventType EventTypeStr:@"" EventId:systemNotifyItem.strPid FinishedBlock:^(int errorCode){
            [[ApplicationContext sharedInstance]checkNewEvent:nil];
        }];
        
        if (eEventType == event_type_send_heart) {
            [[SportForumAPI sharedInstance]userReceiveHeartBySendId:systemNotifyItem.strUserId IsAccept:NO FinishedBlock:^(int errorCode)
             {
                 
             }];
        }
        else if(eEventType == e_notify_runshare || eEventType == e_notify_postshare || eEventType == e_notify_pkshare)
        {
            e_accept_type eAcceptType = e_accept_physique;
            
            if (eEventType == e_notify_runshare) {
                eAcceptType = e_accept_physique;
            }
            else if(eEventType == e_notify_postshare)
            {
                eAcceptType = e_accept_literature;
            }
            else if(eEventType == e_notify_pkshare)
            {
                eAcceptType = e_accept_pk;
            }
            
            [[SportForumAPI sharedInstance]tasksSharedByType:eAcceptType SenderId:systemNotifyItem.strFrom ArticleId:@"" AddDesc:@"" ImgUrl:@"" RunBeginTime:0 IsAccept:NO FinishedBlock:^(int errorCode, ExpEffect* expEffect)
             {
                 
             }];
        }
    };
    
    cell.bEditMode = _bEdit;
    cell.systemNotifyItem = systemNotifyItem;
    return cell;
}

/*- (void)leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_dataArray removeObjectAtIndex:indexPath.row];
        [leftSwipeTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        SystemNotifyItem *systemNotifyItem = _dataArray[indexPath.row];
        event_type eEventType = event_type_subscribe;

        if (systemNotifyItem.eNotifyType == e_notify_comment) {
            eEventType = event_type_comment;
        }
        else if(systemNotifyItem.eNotifyType == e_notify_coach_comment) {
            eEventType = event_type_coach_comment;
        }
        else if (systemNotifyItem.eNotifyType == e_notify_thumb) {
            eEventType = event_type_thumb;
        }
        else if (systemNotifyItem.eNotifyType == e_notify_subscribe) {
            eEventType = event_type_subscribe;
        }
        else if (systemNotifyItem.eNotifyType == e_notify_reward) {
            eEventType = event_type_reward;
        }
        else if (systemNotifyItem.eNotifyType == e_notify_tx) {
            eEventType = event_type_tx;
        }
        
        [[SportForumAPI sharedInstance]eventChangeStatusReadByEventType:eEventType EventId:systemNotifyItem.strPid FinishedBlock:^(int errorCode){
            [[ApplicationContext sharedInstance]checkNewEvent:nil];
        }];
        
        [[SportForumAPI sharedInstance]userReceiveHeartBySendId:systemNotifyItem.strUserId IsAccept:NO FinishedBlock:^(int errorCode)
         {
             
         }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}*/

- (void) leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView didSelectRow:(NSIndexPath *)indexPath
{
    if(_bEdit)
        return;

    if ([_dataArray count] > 0) {
        SystemNotifyItem *systemNotifyItem = _dataArray[indexPath.row];
        
        if (systemNotifyItem.eNotifyType == e_notify_comment || systemNotifyItem.eNotifyType == e_notify_coach_comment || systemNotifyItem.eNotifyType == e_notify_coach_pass_comment || systemNotifyItem.eNotifyType == e_notify_coach_npass_comment || systemNotifyItem.eNotifyType == e_notify_thumb
            || systemNotifyItem.eNotifyType == e_notify_reward || systemNotifyItem.eNotifyType == e_notify_at || systemNotifyItem.eNotifyType == e_notify_record) {
            
            __weak __typeof(self) weakSelf = self;
            
            UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
            id processWin = [AlertManager showCommonProgressInView:viewBody];
            
            [[SportForumAPI sharedInstance]articleGetByArticleId:systemNotifyItem.strPid FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
                __typeof(self) strongSelf = weakSelf;
                
                [AlertManager dissmiss:processWin];
                
                if (strongSelf != nil) {
                    if (errorCode == 0) {
                        ArticlePagesViewController* articlePagesViewController = [[ArticlePagesViewController alloc] init];
                        articlePagesViewController.currentIndex = 0;
                        articlePagesViewController.arrayArticleInfos = [NSMutableArray arrayWithObject:articlesObject];
                        [self.navigationController pushViewController:articlePagesViewController animated:YES];
                    }
                    else
                    {
                        [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                        
                        [strongSelf->_dataArray removeObjectAtIndex:indexPath.row];
                        [leftSwipeTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [leftSwipeTableView reloadData];

                        [[SportForumAPI sharedInstance]eventChangeStatusReadByEventType:-1 EventTypeStr:systemNotifyItem.eNotifyType == e_notify_reward ? @"wallet" : @"article" EventId:systemNotifyItem.strPid FinishedBlock:^(int errorCode){
                            [[ApplicationContext sharedInstance]checkNewEvent:nil];
                        }];
                    }
                }
            }];
        }
        else
        {
            event_type eEventType = event_type_subscribe;
            
            if (systemNotifyItem.eNotifyType == e_notify_subscribe) {
                eEventType = event_type_subscribe;
            }
            else if (systemNotifyItem.eNotifyType == e_notify_tx) {
                eEventType = event_type_tx;
            }
            else if(systemNotifyItem.eNotifyType == e_notify_send_heart)
            {
                eEventType = event_type_send_heart;
            }
            else if(systemNotifyItem.eNotifyType == e_notify_receive_heart)
            {
                eEventType = event_type_receive_heart;
            }
            else if(systemNotifyItem.eNotifyType == e_notify_runshare)
            {
                eEventType = event_type_run_share;
            }
            else if(systemNotifyItem.eNotifyType == e_notify_runshared)
            {
                eEventType = event_type_run_shared;
            }
            else if(systemNotifyItem.eNotifyType == e_notify_postshare)
            {
                eEventType = event_type_post_share;
            }
            else if(systemNotifyItem.eNotifyType == e_notify_postshared)
            {
                eEventType = event_type_post_shared;
            }
            else if(systemNotifyItem.eNotifyType == e_notify_pkshare)
            {
                eEventType = event_type_pk_share;
            }
            else if(systemNotifyItem.eNotifyType == e_notify_pkshared)
            {
                eEventType = event_type_pk_shared;
            }
            else if(systemNotifyItem.eNotifyType == e_notify_info)
            {
                eEventType = event_type_info;
            }
            
            [[SportForumAPI sharedInstance]eventChangeStatusReadByEventType:eEventType EventTypeStr:@"" EventId:systemNotifyItem.strPid FinishedBlock:^(int errorCode){
                [[ApplicationContext sharedInstance]checkNewEvent:nil];
            }];
            
            if (eEventType == event_type_send_heart) {
                RecordReceiveHeartViewController * recordReceiveHeartViewController = [[RecordReceiveHeartViewController alloc]init];
                recordReceiveHeartViewController.strSendId = systemNotifyItem.strUserId;
                recordReceiveHeartViewController.strRecordId = systemNotifyItem.strRecordId;
                [self.navigationController pushViewController:recordReceiveHeartViewController animated:YES];
            }
            else if(eEventType == event_type_run_share)
            {
                RunShareViewController *runShareViewController = [[RunShareViewController alloc]init];
                runShareViewController.strSendId = systemNotifyItem.strFrom;
                runShareViewController.strRecordId = systemNotifyItem.strRecordId;
                runShareViewController.strLocAddr = systemNotifyItem.strLocAddr;
                runShareViewController.lRunBeginTime = systemNotifyItem.lRunBeginTime;
                runShareViewController.strImgAddr = systemNotifyItem.strMapUrl;
                runShareViewController.strLatlng = systemNotifyItem.strLatlng;
                [self.navigationController pushViewController:runShareViewController animated:YES];
            }
            else if(eEventType == event_type_post_share)
            {
                ThumbShareViewController *thumbShareViewController = [[ThumbShareViewController alloc]init];
                thumbShareViewController.strSendId = systemNotifyItem.strFrom;
                thumbShareViewController.strArticleId = systemNotifyItem.strArticleId;
                [self.navigationController pushViewController:thumbShareViewController animated:YES];
            }
            else if(eEventType == event_type_pk_share)
            {
                PKShareViewController *pkShareViewController = [[PKShareViewController alloc]init];
                pkShareViewController.strSendId = systemNotifyItem.strFrom;
                pkShareViewController.strRecordId = systemNotifyItem.strRecordId;
                [self.navigationController pushViewController:pkShareViewController animated:YES];
            }
            else if(eEventType == event_type_info)
            {
                AccountEditViewController *accountEditViewController = [[AccountEditViewController alloc]init];
                [self.navigationController pushViewController:accountEditViewController animated:YES];
            }
            else
            {
                AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
                accountPreViewController.strUserId = systemNotifyItem.strFrom;
                [self.navigationController pushViewController:accountPreViewController animated:YES];
            }
        }
    }
}

- (CGFloat)leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SystemNotifyCell heightOfCell];
}

- (BOOL)leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
