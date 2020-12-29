//
//  ChatDetailViewController.m
//  SportForum
//
//  Created by liyuan on 14-6-24.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "ChatDetailViewController.h"
#import "LeftSwipeTableViewController.h"
#import "ChatDetailCell.h"
#import "SystemNotifyViewController.h"
#import "SportForum.h"
#import "CommonUtility.h"
#import "UIViewController+SportFormu.h"
#import "ChatMessageTableViewController.h"

#define TEST_DATA 0
#define UPDATE_TIME_VALUE 60

@interface ChatDetailViewController () <LeftSwipeTableViewDelegate>{
    NSMutableArray * _dataArray;
    ContactInfos* _contactInfos;
    BOOL _bEdit;
    
    NSTimer * m_timeGetRecentChatInfos;
    UIActivityIndicatorView *m_activityIndicatorMain;
}

@property (nonatomic, strong) LeftSwipeTableViewController * tableView;

@end

@implementation ChatDetailViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _dataArray = [[NSMutableArray alloc]init];
        m_timeGetRecentChatInfos = nil;
    }

    return self;
}

-(void)testForumDatas {
    [_dataArray removeAllObjects];
    ChatDetailItem *chatDetailItem = [[ChatDetailItem alloc]init];
    chatDetailItem.userImage =  @"TESTPIC";
    chatDetailItem.nickName = @"大雄";
    chatDetailItem.latestContent = @"昨天我睡过头了，抱歉！";
    chatDetailItem.time = [[CommonUtility sharedInstance]convertStringToNSDate:@"2014-06-29 13:26:20"];
    chatDetailItem.unReadCount = 3;
    chatDetailItem.bSystemMsg = NO;
    [_dataArray addObject:chatDetailItem];
    
    chatDetailItem = [[ChatDetailItem alloc]init];
    chatDetailItem.userImage = @"TESTPIC";
    chatDetailItem.nickName = @"爱跑步的鱼";
    chatDetailItem.time = [[CommonUtility sharedInstance]convertStringToNSDate:@"2014-06-28 10:26:20"];
    chatDetailItem.latestContent = @"后天一块去跑马拉松，去不？";
    chatDetailItem.unReadCount = 0;
    chatDetailItem.bSystemMsg = NO;
    [_dataArray addObject:chatDetailItem];
    
    chatDetailItem = [[ChatDetailItem alloc]init];
    chatDetailItem.userImage = @"TESTPIC";
    chatDetailItem.nickName = @"系统消息";
    chatDetailItem.time = nil;
    chatDetailItem.latestContent = @"您有1个新的赞, 3条新的回复";
    chatDetailItem.unReadCount = 4;
    chatDetailItem.bSystemMsg = YES;
    [_dataArray addObject:chatDetailItem];
    
    [self.tableView reloadData];
}

- (void)viewDidLoadGUI
{
    [self generateCommonViewInParent:self.view Title:@"个人消息" IsNeedBackBtn:YES];

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
    _tableView = [[LeftSwipeTableViewController alloc] initWithFrame:rect];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.leftSwipeTableViewDelegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [_tableView enablePullRefreshHeaderViewTarget:self DidTriggerRefreshAction:@selector(actionPullHeaderRefresh)];
    [_tableView enablePullRefreshFooterViewTarget:self DidTriggerRefreshAction:@selector(actionPullFooterRefresh)];
    [_tableView.tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [viewBody addSubview:self.tableView];
    
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
        [strongSelf->_tableView reloadData];
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

- (void) viewDidLoadData
{
    if (TEST_DATA) {
        [self testForumDatas];
        [self.tableView completePullHeaderRefresh];
        [self.tableView completePullFooterRefresh];
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        
        if ([ApplicationContext sharedInstance].accountInfo != nil) {
            [[SportForumAPI sharedInstance]chatRecentChatInfos:^void(int errorCode, ContactInfos* contactInfos)
             {
                 __typeof(self) strongSelf = weakSelf;
                 
                 if (strongSelf == nil) {
                     return;
                 }
                 
                 [m_activityIndicatorMain stopAnimating];
                 [self.tableView completePullHeaderRefresh];
                 [self.tableView completePullFooterRefresh];
                 [self restartTimer_updateCellTime];
                 
                 if (errorCode == 0 && [contactInfos.contact_infos.data count] > 0) {
                     _contactInfos = contactInfos;
                     [_dataArray removeAllObjects];
                     
                     for (ContactObject *contactObject in contactInfos.contact_infos.data) {
                         ChatDetailItem *chatDetailItem = [[ChatDetailItem alloc]init];
                         chatDetailItem.userId = contactObject.userid;
                         chatDetailItem.userImage = contactObject.user_profile_image;
                         chatDetailItem.nickName = contactObject.nikename;
                         chatDetailItem.latestContent = contactObject.last_message.content;
                         chatDetailItem.time = [NSDate dateWithTimeIntervalSince1970:contactObject.last_message.time];
                         chatDetailItem.unReadCount = contactObject.new_message_count;
                         chatDetailItem.bSystemMsg = NO;
                         
                         [_dataArray addObject:chatDetailItem];
                     }
                     
                     /*EventNewsInfo *eventNewsInfo = [[ApplicationContext sharedInstance]eventNewsInfo];
                     
                     if (eventNewsInfo.new_comment_count > 0 || eventNewsInfo.new_thumb_count > 0) {
                         ChatDetailItem *chatDetailItem = [[ChatDetailItem alloc]init];
                         chatDetailItem.userId = @"";
                         chatDetailItem.userImage = @"notification-system";
                         chatDetailItem.nickName = @"系统消息";
                         chatDetailItem.time = nil;
                         chatDetailItem.bSystemMsg = YES;
                         chatDetailItem.unReadCount = eventNewsInfo.new_comment_count + eventNewsInfo.new_thumb_count;
                         
                         if (eventNewsInfo.new_comment_count > 0 && eventNewsInfo.new_thumb_count > 0) {
                             chatDetailItem.latestContent = [NSString stringWithFormat:@"您有%d个新的赞, %d条新的回复",
                                                             eventNewsInfo.new_thumb_count, eventNewsInfo.new_comment_count];
                         }
                         else if(eventNewsInfo.new_comment_count > 0)
                         {
                             chatDetailItem.latestContent = [NSString stringWithFormat:@"您有%d条新的回复", eventNewsInfo.new_comment_count];
                         }
                         else
                         {
                             chatDetailItem.latestContent = [NSString stringWithFormat:@"您有%d条新的赞", eventNewsInfo.new_thumb_count];
                         }
                         
                         [_dataArray insertObject:chatDetailItem atIndex:0];
                     }*/
                     
                     if ([_dataArray count] > 0)
                     {
                         [_dataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                             ChatDetailItem *chatData1 = obj1;
                             ChatDetailItem *chatData2 = obj2;
                             return [chatData2.time compare:chatData1.time];
                         }];
                     }
                     
                     [self.tableView reloadData];
                 }
             }];
        }
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
    [MobClick beginLogPageView:@"消息记录 - ChatDetailViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"消息记录 - ChatDetailViewController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (m_timeGetRecentChatInfos != nil && [m_timeGetRecentChatInfos isValid]) {
        [m_timeGetRecentChatInfos invalidate];
        m_timeGetRecentChatInfos = nil;
    }
    
    [MobClick endLogPageView:@"消息记录 - ChatDetailViewController"];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlChatRecentChatInfos, nil]];
}

- (void)handleWebSocketMsgComing:(NSNotification*) notification
{
    NSMutableArray *arrChatInfo = [[notification userInfo]objectForKey:@"WSChatInfoList"];

    for (MsgWsInfo *msgWsInfo in arrChatInfo) {
        BOOL bExist = NO;
        
        for (ChatDetailItem *chatDetailItem in _dataArray) {
            if ([chatDetailItem.userId isEqualToString:msgWsInfo.push.from]) {
                chatDetailItem.unReadCount += 1;
                
                for (MsgWsBodyItem *msgWsBodyItem in msgWsInfo.push.body.data) {
                    if ([msgWsBodyItem.type isEqualToString:@"msg_content"]) {
                        chatDetailItem.latestContent = msgWsBodyItem.content;
                    }
                }
                
                chatDetailItem.time = [NSDate dateWithTimeIntervalSince1970:msgWsInfo.time];
                bExist = YES;
                break;
            }
        }
        
        if (!bExist) {
            ChatDetailItem *chatDetailItem = [[ChatDetailItem alloc]init];
            chatDetailItem.userId = msgWsInfo.push.from;
            chatDetailItem.unReadCount += 1;
            chatDetailItem.time = [NSDate dateWithTimeIntervalSince1970:msgWsInfo.time];
            chatDetailItem.bSystemMsg = NO;
            
            for (MsgWsBodyItem *msgWsBodyItem in msgWsInfo.push.body.data) {
                if ([msgWsBodyItem.type isEqualToString:@"msg_content"]) {
                    chatDetailItem.latestContent = msgWsBodyItem.content;
                }
                else if([msgWsBodyItem.type isEqualToString:@"nikename"])
                {
                    chatDetailItem.nickName = msgWsBodyItem.content;
                }
                else if([msgWsBodyItem.type isEqualToString:@"image"])
                {
                    chatDetailItem.userImage = msgWsBodyItem.content;
                }
            }
            
            [_dataArray insertObject:chatDetailItem atIndex:0];
        }
    }
    
    if ([arrChatInfo count] > 0) {
        [_dataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            ChatDetailItem *chatData1 = obj1;
            ChatDetailItem *chatData2 = obj2;
            return [chatData2.time compare:chatData1.time];
        }];
        
        [self.tableView reloadData];
        [self restartTimer_updateCellTime];
    }
}

- (void)restartTimer_updateCellTime
{
    if (m_timeGetRecentChatInfos != nil && [m_timeGetRecentChatInfos isValid]) {
        [m_timeGetRecentChatInfos invalidate];
    }
    
    m_timeGetRecentChatInfos = [NSTimer scheduledTimerWithTimeInterval: UPDATE_TIME_VALUE
                                                               target: self
                                                             selector: @selector(updateCellItemTime)
                                                             userInfo: nil
                                                              repeats: NO];
}

- (void)updateCellItemTime
{
    for (ChatDetailItem *chatDetailItem in _dataArray) {
        chatDetailItem.time = [NSDate dateWithTimeIntervalSince1970:([chatDetailItem.time timeIntervalSince1970] + UPDATE_TIME_VALUE)];
    }
    
    [self.tableView reloadData];
    [self restartTimer_updateCellTime];
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
    NSLog(@"ChatDetailViewController dealloc called!");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source
- (NSInteger) numberOfCells:(LeftSwipeTableViewController *)leftSwipeTableViewController
{
    return _dataArray.count;
}

- (UITableViewCell *) leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView RowIndex:(NSIndexPath *)indexPath
{
    ChatDetailItem *chatDetailItem = _dataArray[indexPath.row];
    ChatDetailCell *cell = [leftSwipeTableView dequeueReusableCellWithIdentifier:@"ChatDetailCell"];
    
    if (cell == nil) {
        cell = [[ChatDetailCell alloc]initWithReuseIdentifier:@"ChatDetailCell"];
    }
    
    __weak __typeof(self) weakSelf = self;
    
    cell.delClickBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->_dataArray removeObjectAtIndex:indexPath.row];
        [leftSwipeTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [leftSwipeTableView reloadData];
        
        [[SportForumAPI sharedInstance]chatDeleteMessageByUserId:chatDetailItem.userId FinishedBlock:^(int errorCode, NSString* strDescErr){
            [[ApplicationContext sharedInstance]checkNewEvent:nil];
        }];
    };
    
    cell.bEditMode = _bEdit;
    cell.chatDetailItem = chatDetailItem;
    return cell;
}

- (void)leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_dataArray removeObjectAtIndex:indexPath.row];
        [leftSwipeTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void) leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView didSelectRow:(NSIndexPath *)indexPath
{
    if(_bEdit)
        return;
    
    ChatDetailItem *chatDetailItem = _dataArray[indexPath.row];
    
    if (![chatDetailItem.nickName isEqualToString:@"系统消息"]) {
        ChatMessageTableViewController *chatMessageTableViewController = [[ChatMessageTableViewController alloc]init];
        chatMessageTableViewController.userId = chatDetailItem.userId;
        chatMessageTableViewController.useProImage = chatDetailItem.userImage;
        chatMessageTableViewController.useNickName = chatDetailItem.nickName;
        [self.navigationController pushViewController:chatMessageTableViewController animated:YES];
    }
    else
    {
        SystemNotifyViewController *systemNotifyViewController = [[SystemNotifyViewController alloc]init];
        [self.navigationController pushViewController:systemNotifyViewController animated:YES];
    }
}

- (CGFloat)leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ChatDetailCell heightOfCell];
}

- (BOOL)leftSwipeTableView:(LeftSwipeTableViewController *)leftSwipeTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
