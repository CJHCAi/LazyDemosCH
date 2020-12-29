//
//  ChatMessageTableViewController.m
//  MessageDisplayExample

#import "ChatMessageTableViewController.h"

#import "XHDisplayTextViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"

#import "XHAudioPlayerHelper.h"
#import "IQKeyboardManager.h"
#import "AlertManager.h"
#import "AccountPreViewController.h"

#define UPDATE_TIME_VALUE 60

@interface ChatMessageTableViewController () <XHAudioPlayerHelperDelegate>

@property (nonatomic, strong) NSArray *emotionManagers;

@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;

@end

@implementation ChatMessageTableViewController
{
    NSString *_strFirstPageId;
    NSString *_strLastPageId;
}

- (id)init {
    self = [super init];
    if (self) {
        // 配置输入框UI的样式
        self.allowsSendVoice = NO;
        self.allowsSendFace = NO;
        self.allowsSendMultiMedia = NO;
        self.allowsPanToDismissKeyboard = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"the-lowest-bg"]];
    
    UIImage *image = [UIImage imageNamed:@"the-lowest-bg"];
    self.view.layer.contents = (id) image.CGImage;

    [self setTitle:_bTutorChat ? @"专家点评" : _useNickName];
    
    if (_bNoSendAction) {
        self.messageInputView.hidden = YES;
    }
    
    // 设置自身用户名
    self.messageSender = @"";
    self.messageInputView.messageInputViewStyle = XHMessageInputViewStyleFlat;
    self.messageInputView.inputTextView.text = _strDefaultText;
    self.messageInputView.inputTextView.placeHolder = @"发送新消息";
    image = [UIImage imageNamed:@"tool-bg-1"];
    self.messageInputView.layer.contents = (id) image.CGImage;
    
    if (_strDefaultText.length > 0) {
        [self.messageInputView.inputTextView becomeFirstResponder];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWebSocketMsgComing:) name:NOTIFY_MESSAGE_WEBSOCKET_COMING object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    _strFirstPageId = @"";
    [self reloadMsgData];
    [MobClick beginLogPageView:@"聊天 - ChatMessageTableViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"聊天 - ChatMessageTableViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlChatGetList, nil]];
    [MobClick endLogPageView:@"聊天 - ChatMessageTableViewController"];
}

- (void)handleWebSocketMsgComing:(NSNotification*) notification
{
    BOOL bMsgLoad = NO;
    NSMutableArray *arrChatInfo = [[notification userInfo]objectForKey:@"WSChatInfoList"];
    
    for (MsgWsInfo *msgWsInfo in arrChatInfo) {
        if([_userId isEqualToString:msgWsInfo.push.from])
        {
            XHMessage *textMessage = [[XHMessage alloc] init];
            textMessage.messageMediaType = XHBubbleMessageMediaTypeText;
            textMessage.avatar = [UIImage imageNamed:@"image-placeholder"];
            textMessage.userId = _userId;
            textMessage.avatarUrl = _useProImage;
            textMessage.bubbleMessageType = XHBubbleMessageTypeReceiving;
            textMessage.timestamp = [NSDate dateWithTimeIntervalSince1970:msgWsInfo.time];

            for (MsgWsBodyItem *msgWsBodyItem in msgWsInfo.push.body.data) {
                if([msgWsBodyItem.type isEqualToString:@"msg_content"])
                {
                    textMessage.text = msgWsBodyItem.content;
                    break;
                }
            }
            
            [self.messages addObject:textMessage];
            
            bMsgLoad = YES;
        }
    }
    
    if (bMsgLoad) {
        [[SportForumAPI sharedInstance]eventChangeStatusReadByEventType:event_type_chat EventTypeStr:@"" EventId:_userId FinishedBlock:^(int errorCode){
            [[ApplicationContext sharedInstance]checkNewEvent:nil];
        }];
        
        [self.messageTableView reloadData];
        [self scrollToBottomAnimated:NO];
    }
}

-(void)reloadMsgData
{
    [self viewDidLoadData:_strFirstPageId LastPageId:@""];
}

-(void)loadMoreMsgData
{
    [self viewDidLoadData:@"" LastPageId:_strLastPageId];
}

-(void)viewDidLoadData:(NSString*)strFirstrPageId LastPageId:(NSString*)strLastPageId
{
    __weak __typeof(self) thisPointer = self;
    
    if (_bTutorChat) {
        [[SportForumAPI sharedInstance]articleCommentsByArticleId:_strArticleId FirstPageId:strFirstrPageId LastPageId:strLastPageId PageItemNum:20 Type:@"coach"FinishedBlock:^(int errorCode, ArticlesInfo *articlesInfo) {
            __typeof(self) strongThis = thisPointer;
            
            if (strongThis == nil) {
                return;
            }
            
            self.loadingMoreMessage = NO;
            
            if(errorCode == 0 && [articlesInfo.articles_without_content.data count] > 0)
            {
                [[ApplicationContext sharedInstance]checkNewEvent:nil];
                
                if (strFirstrPageId.length == 0 && strLastPageId.length == 0) {
                    [self.messages removeAllObjects];
                    
                    _strFirstPageId = articlesInfo.page_frist_id;
                    _strLastPageId = articlesInfo.page_last_id;
                }
                else if (strFirstrPageId.length == 0 && strLastPageId.length > 0)
                {
                    _strLastPageId = articlesInfo.page_last_id;
                }
                else if(strFirstrPageId.length > 0 && strLastPageId.length == 0)
                {
                    _strFirstPageId = articlesInfo.page_frist_id;
                }
                
                for (ArticlesObject *articlesObject in articlesInfo.articles_without_content.data) {
                    BOOL bReceived = ![articlesObject.authorInfo.userid isEqualToString:_userId];
                    
                    NSMutableString *strBody = [[NSMutableString alloc]init];
                    
                    for (int index = 0; index < articlesObject.article_segments.data.count; index++) {
                        ArticleSegmentObject* segobj = articlesObject.article_segments.data[index];
                        
                        if([segobj.seg_type isEqualToString:@"TEXT"]) {
                            [strBody appendString:segobj.seg_content];
                            break;
                        }
                    }
                    
                    XHMessage *textMessage = [[XHMessage alloc] initWithText:strBody sender:@"" timestamp:[NSDate dateWithTimeIntervalSince1970:articlesObject.time]];
                    textMessage.avatar = [UIImage imageNamed:@"image-placeholder"];
                    textMessage.avatarUrl = bReceived ? articlesObject.authorInfo.profile_image : _useProImage;
                    textMessage.bubbleMessageType = bReceived ? XHBubbleMessageTypeReceiving : XHBubbleMessageTypeSending;
                    textMessage.userId = bReceived ? articlesObject.authorInfo.userid : @"";
                    [self.messages addObject:textMessage];
                }
                
                [self.messages sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    XHMessage *textMessage1 = obj1;
                    XHMessage *textMessage2 = obj2;
                    return [textMessage1.timestamp compare:textMessage2.timestamp];
                }];
                
                [self.messageTableView reloadData];
                
                if (strFirstrPageId.length == 0 && strLastPageId.length == 0) {
                    [self scrollToBottomAnimated:NO];
                }
            }
        }];
    }
    else
    {
        if ([ApplicationContext sharedInstance].accountInfo != nil && _userId.length > 0) {
            [[SportForumAPI sharedInstance]chatGetListByUserId:_userId FirstPageId:strFirstrPageId LastPageId:strLastPageId PageItemCount:20 FinishedBlock:^void(int errorCode, ChatMessagesList* chatMessagesList)
             {
                 __typeof(self) strongThis = thisPointer;
                 
                 if (strongThis == nil) {
                     return;
                 }
                 
                 self.loadingMoreMessage = NO;
                 
                 if (errorCode == 0 && strLastPageId.length == 0 && [chatMessagesList.messages.data count] > 0) {
                     [[SportForumAPI sharedInstance]eventChangeStatusReadByEventType:event_type_chat EventTypeStr:@"" EventId:_userId FinishedBlock:^(int errorCode){
                         [[ApplicationContext sharedInstance]checkNewEvent:nil];
                     }];
                 }
                 
                 if(errorCode == 0 && [chatMessagesList.messages.data count] > 0)
                 {
                     if (strFirstrPageId.length == 0 && strLastPageId.length == 0) {
                         [self.messages removeAllObjects];
                         
                         _strFirstPageId = chatMessagesList.page_frist_id;
                         _strLastPageId = chatMessagesList.page_last_id;
                     }
                     else if (strFirstrPageId.length == 0 && strLastPageId.length > 0)
                     {
                         _strLastPageId = chatMessagesList.page_last_id;
                     }
                     else if(strFirstrPageId.length > 0 && strLastPageId.length == 0)
                     {
                         _strFirstPageId = chatMessagesList.page_frist_id;
                     }
                     
                     for (ChatMessage *chatMessage in chatMessagesList.messages.data) {
                         BOOL bReceived = [chatMessage.from_id isEqualToString:_userId];
                         XHMessage *textMessage = [[XHMessage alloc] initWithText:chatMessage.content sender:@"" timestamp:[NSDate dateWithTimeIntervalSince1970:chatMessage.time]];
                         textMessage.avatar = [UIImage imageNamed:@"image-placeholder"];
                         textMessage.avatarUrl = bReceived ? _useProImage : [ApplicationContext sharedInstance].accountInfo.profile_image;
                         textMessage.bubbleMessageType = bReceived ? XHBubbleMessageTypeReceiving : XHBubbleMessageTypeSending;
                         textMessage.userId = bReceived ? _userId : @"";
                         [self.messages addObject:textMessage];
                     }
                     
                     [self.messages sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                         XHMessage *textMessage1 = obj1;
                         XHMessage *textMessage2 = obj2;
                         return [textMessage1.timestamp compare:textMessage2.timestamp];
                     }];
                     
                     [self.messageTableView reloadData];
                     
                     if (strFirstrPageId.length == 0 && strLastPageId.length == 0) {
                         [self scrollToBottomAnimated:NO];
                     }
                 }
             }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"ChatMessageTableViewController dealloc called!");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.emotionManagers = nil;
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
}

/*
 [self removeMessageAtIndexPath:indexPath];
 [self insertOldMessages:self.messages];
 */

#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    return;
    UIViewController *disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypePhoto: {
            DLog(@"message : %@", message.photo);
            DLog(@"message : %@", message.videoConverPhoto);
            XHDisplayMediaViewController *messageDisplayTextView = [[XHDisplayMediaViewController alloc] init];
            messageDisplayTextView.message = message;
            disPlayViewController = messageDisplayTextView;
            break;
        }
            break;
        case XHBubbleMessageMediaTypeVoice: {
            DLog(@"message : %@", message.voicePath);
            
            // Mark the voice as read and hide the red dot.
            message.isRead = YES;
            messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
            
            [[XHAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self];
            if (_currentSelectedCell) {
                [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
            }
            if (_currentSelectedCell == messageTableViewCell) {
                [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
                [[XHAudioPlayerHelper shareInstance] stopAudio];
                self.currentSelectedCell = nil;
            } else {
                self.currentSelectedCell = messageTableViewCell;
                [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
                [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
            }
            break;
        }
        case XHBubbleMessageMediaTypeEmotion:
            DLog(@"facePath : %@", message.emotionPath);
            break;
        case XHBubbleMessageMediaTypeLocalPosition: {
            DLog(@"facePath : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        default:
            break;
    }
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}

- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    return;
    DLog(@"text : %@", message.text);
    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
    displayTextViewController.message = message;
    [self.navigationController pushViewController:displayTextViewController animated:YES];
}

- (void)didSelectedAvatarOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath : %@", indexPath);
    UserInfo* userInfo = [[ApplicationContext sharedInstance]accountInfo];
    AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
    accountPreViewController.strUserId = [message userId].length > 0 ? [message userId] : (_bTutorChat ? _userId : userInfo.userid);
    [self.navigationController pushViewController:accountPreViewController animated:YES];
}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType {
    
}

#pragma mark - XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    if (!_currentSelectedCell) {
        return;
    }
    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}

#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}

#pragma mark - XHMessageTableViewController Delegate

- (BOOL)shouldLoadMoreMessagesScrollToTop {
    return YES;
}

- (void)loadMoreMessagesScrollTotop {
    if (!self.loadingMoreMessage) {
        self.loadingMoreMessage = YES;
        
        [self performSelector:@selector(loadMoreMsgData) withObject:nil afterDelay:0.3];
    }
}

-(void)publishTutorComment:(NSString*)strContent onDate:(NSDate *)date
{
    NSMutableArray* articleSegments = [[NSMutableArray alloc]init];
    
    ArticleSegmentObject* segobj = [ArticleSegmentObject new];
    segobj.seg_type = @"TEXT";
    segobj.seg_content = strContent;
    [articleSegments addObject:segobj];
    
    id processWin = [AlertManager showCommonProgress];
    
    [[SportForumAPI sharedInstance]articleNewByParArticleId:_strArticleId
                                             ArticleSegment:articleSegments
                                                 ArticleTag:[NSArray arrayWithObject:[CommonFunction ConvertArticleTagTypeToString:e_article_log]] Type:@"coach" AtNameList:nil
                                              FinishedBlock:^(int errorCode, NSString* strDescErr, ExpEffect* expEffect) {
                                                  [AlertManager dissmiss:processWin];
                                                  
                                                  if (errorCode == RSA_ERROR_NONE) {
                                                      UserInfo* userInfo = [[ApplicationContext sharedInstance]accountInfo];
                                                      XHMessage *textMessage = [[XHMessage alloc] initWithText:strContent sender:@"" timestamp:date];
                                                      textMessage.avatar = [UIImage imageNamed:@"image-placeholder"];
                                                      textMessage.avatarUrl = userInfo.profile_image;
                                                      [self addMessage:textMessage];
                                                      [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
                                                  } else {
                                                      [self.messageInputView.inputTextView endEditing:YES];
                                                      [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                  }
                                              }];
}

/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    BOOL bSending = NO;
    NSMutableDictionary *dictOperations = [[[SportForumAPI sharedInstance]getAllOperation] objectForKey:_bTutorChat ? urlArticleNew : urlChatSendMessage];
    
    for (NSString *strUUID in [dictOperations allKeys]) {
        NSOperation* request = [dictOperations objectForKey:strUUID];
        
        if ([request isExecuting]) {
            bSending = YES;
            break;
        }
    }
    
    if (bSending) {
        [AlertManager showAlertText:@"正在发送中，请稍等..."];
        return;
    }
    
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    
    if (userInfo != nil) {
        if (userInfo.ban_time > 0) {
            [self.messageInputView.inputTextView endEditing:YES];
            [JDStatusBarNotification showWithStatus:@"用户已被禁言，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
        else if(userInfo.ban_time < 0)
        {
            [self.messageInputView.inputTextView endEditing:YES];
            [JDStatusBarNotification showWithStatus:@"用户已进入黑名单，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
    }
    
    if (_bTutorChat) {
        [self publishTutorComment:text onDate:date];
    }
    else
    {
        [[SportForumAPI sharedInstance]chatSendMessageBySendId:_userId SendType:chat_send_text Content:text FinishedBlock:^void(int errorCode, NSString* strDescErr, NSString*strMsgId){
            if (errorCode == 0 && strMsgId.length > 0) {
                XHMessage *textMessage = [[XHMessage alloc] initWithText:text sender:sender timestamp:date];
                textMessage.avatar = [UIImage imageNamed:@"image-placeholder"];
                textMessage.avatarUrl = [ApplicationContext sharedInstance].accountInfo.profile_image;
                [self addMessage:textMessage];
                [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
            }
            else
            {
                //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages indexOfObject:textMessage] inSection:0];
                //[self removeMessageAtIndexPath:indexPath];
                [self.messageInputView.inputTextView endEditing:YES];
                [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
            }
        }];
    }
}

/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *photoMessage = [[XHMessage alloc] initWithPhoto:photo thumbnailUrl:nil originPhotoUrl:nil sender:sender timestamp:date];
    photoMessage.avatar = [UIImage imageNamed:@"avatar"];
    photoMessage.avatarUrl = @"http://www.pailixiu.com/jack/meIcon@2x.png";
    [self addMessage:photoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *videoMessage = [[XHMessage alloc] initWithVideoConverPhoto:videoConverPhoto videoPath:videoPath videoUrl:nil sender:sender timestamp:date];
    videoMessage.avatar = [UIImage imageNamed:@"avatar"];
    videoMessage.avatarUrl = @"http://www.pailixiu.com/jack/meIcon@2x.png";
    [self addMessage:videoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *voiceMessage = [[XHMessage alloc] initWithVoicePath:voicePath voiceUrl:nil voiceDuration:voiceDuration sender:sender timestamp:date];
    voiceMessage.avatar = [UIImage imageNamed:@"avatar"];
    voiceMessage.avatarUrl = @"http://www.pailixiu.com/jack/meIcon@2x.png";
    [self addMessage:voiceMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
}

/**
 *  发送第三方表情消息的回调方法
 *
 *  @param facePath 目标第三方表情的本地路径
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *emotionMessage = [[XHMessage alloc] initWithEmotionPath:emotionPath sender:sender timestamp:date];
    emotionMessage.avatar = [UIImage imageNamed:@"avatar"];
    emotionMessage.avatarUrl = @"http://www.pailixiu.com/jack/meIcon@2x.png";
    [self addMessage:emotionMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
}

/**
 *  有些网友说需要发送地理位置，这个我暂时放一放
 */
- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date {
    XHMessage *geoLocationsMessage = [[XHMessage alloc] initWithLocalPositionPhoto:geoLocationsPhoto geolocations:geolocations location:location sender:sender timestamp:date];
    geoLocationsMessage.avatar = [UIImage imageNamed:@"avatar"];
    geoLocationsMessage.avatarUrl = @"http://www.pailixiu.com/jack/meIcon@2x.png";
    [self addMessage:geoLocationsMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeLocalPosition];
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */
- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

}

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}

@end
