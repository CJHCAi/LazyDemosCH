//
//  MessageViewController.m
//  SportForum
//
//  Created by liyuan on 14-6-25.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "IQKeyboardManager.h"
#import "CSButton.h"
#import "CommonUtility.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+SportFormu.h"

#define APP_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define APP_FOOTER_BAR_HEIGHT 50.0
#define UPDATE_TIME_VALUE 60

@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@end

@implementation MessageViewController
{
    UIView* _viewFootBar;
    CGFloat _keyboardHeight;
    UITextView* _tfSMSContent;
    UIImageView * m_imgInputContent;
    CSButton* _buttonSend;
    UILabel *_lbPackageCount;
    
    BOOL _blQuiting;
    BOOL _blKeyboardShow;
    CGFloat _footViewStartY;
    CGFloat _footViewStartHeight;
    
    UITableView* _tvChatList;
    NSString * _strOldInput;
    int m_nMaxHeight;
    
    UITapGestureRecognizer *_tapRecogniser;
    NSMutableArray * _dataArray;
    
    NSString *_strFirstPageId;
    NSString *_strLastPageId;
    
    NSTimer * m_timeGetChatList;
    
    int _nPacket;
    int _nRemain;
    int _nMax;
    
#if USE_EGO_REFRESH
    EGORefreshTableHeaderView* _egoRefreshTableHeaderView;
    BOOL _bUpHandleLoading;
#endif
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self testForumDatas];
        
        _strFirstPageId = @"";
        _strLastPageId = @"";
        m_timeGetChatList = nil;
        _dataArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)testForumDatas {
    /*[_dataArray removeAllObjects];

    MessageItem *messageItem = [[MessageItem alloc]init];
    messageItem.isReceived = YES;
    messageItem.time = @"2014-06-10 19:26:20";
    messageItem.userImage = @"TESTPIC";
    messageItem.content = @"明天有空吗？";
    [_dataArray addObject:messageItem];
    
    messageItem = [[MessageItem alloc]init];
    messageItem.isReceived = NO;
    messageItem.time = @"2014-06-11 19:26:20";
    messageItem.userImage = @"TESTPIC";
    messageItem.content = @"有空的，一起去运动吧";
    [_dataArray addObject:messageItem];
    
    messageItem = [[MessageItem alloc]init];
    messageItem.isReceived = YES;
    messageItem.time = @"2014-06-12 19:26:20";
    messageItem.userImage = @"TESTPIC";
    messageItem.content = @"没问题，明天早上6点不见不散！";
    [_dataArray addObject:messageItem];
    
    messageItem = [[MessageItem alloc]init];
    messageItem.isReceived = NO;
    messageItem.time = @"2014-06-24 19:26:20";
    messageItem.userImage = @"TESTPIC";
    messageItem.content = @"明儿见！";
    [_dataArray addObject:messageItem];
    
    messageItem = [[MessageItem alloc]init];
    messageItem.isReceived = NO;
    messageItem.time = @"2014-06-25 08:26:20";
    messageItem.userImage = @"TESTPIC";
    messageItem.content = @"明儿见！";
    [_dataArray addObject:messageItem];
    
    messageItem = [[MessageItem alloc]init];
    messageItem.isReceived = NO;
    messageItem.time = @"2014-06-25 10:26:20";
    messageItem.userImage = @"TESTPIC";
    messageItem.content = @"明儿见！";
    [_dataArray addObject:messageItem];
    
    messageItem = [[MessageItem alloc]init];
    messageItem.isReceived = NO;
    messageItem.time = @"2014-06-25 13:26:20";
    messageItem.userImage = @"TESTPIC";
    messageItem.content = @"明儿见！";
    [_dataArray addObject:messageItem];
    
    messageItem = [[MessageItem alloc]init];
    messageItem.isReceived = NO;
    messageItem.time = @"2014-06-25 15:26:20";
    messageItem.userImage = @"TESTPIC";
    messageItem.content = @"明儿见！";
    [_dataArray addObject:messageItem];*/
}

-(void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [_tvChatList numberOfSections];
    if (s<1) return;
    NSInteger r = [_tvChatList numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [_tvChatList scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

-(void)setupSmsSendFooterBar {
    _viewFootBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - APP_FOOTER_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, APP_FOOTER_BAR_HEIGHT)];
    _viewFootBar.backgroundColor =[UIColor clearColor];
    
    UIImage *imgBk = [UIImage imageNamed:@"blog-toolbar-bg"];
    imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_viewFootBar.frame), CGRectGetHeight(_viewFootBar.frame))];
    [imageView setImage:imgBk];
    [_viewFootBar addSubview:imageView];
    
    _tfSMSContent = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 230, 30)];
    _tfSMSContent.backgroundColor = [UIColor clearColor];
    _tfSMSContent.delegate = self;
    _tfSMSContent.font = [UIFont systemFontOfSize:12.0];
    _tfSMSContent.textAlignment = NSTextAlignmentLeft; //水平左对齐
    _tfSMSContent.returnKeyType = UIReturnKeyDefault;
    _tfSMSContent.multipleTouchEnabled = YES;
    _tfSMSContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tfSMSContent.layer.borderWidth = 1.0;
    _tfSMSContent.layer.cornerRadius = 5.0;
    [_viewFootBar addSubview:_tfSMSContent];
    
    UIImage * imgBK = [UIImage imageNamed:@"inputbox-Normal"];
    imgBK = [imgBK stretchableImageWithLeftCapWidth:floorf(imgBK.size.width/2) topCapHeight:floorf(imgBK.size.height/2)];
    m_imgInputContent = [[UIImageView alloc] initWithFrame:_tfSMSContent.frame];
    m_imgInputContent.image = imgBK;
    [_viewFootBar addSubview:m_imgInputContent];
    [_viewFootBar bringSubviewToFront:_tfSMSContent];
    
    _buttonSend = [CSButton buttonWithType:UIButtonTypeCustom];
    _buttonSend.frame = CGRectMake(CGRectGetMaxX(_tfSMSContent.frame)+5, CGRectGetMinY(_tfSMSContent.frame) - 4, 48, 38);
    [_buttonSend setBackgroundImage:[UIImage imageNamed:@"sms-send-btn"] forState:UIControlStateNormal];
    _buttonSend.enabled = NO;
    [_viewFootBar addSubview:_buttonSend];
    
    __typeof__(self) __weak thisPointer = self;
    
    _buttonSend.actionBlock = ^void(){
        __typeof__(self) thisPointerStrong = thisPointer;
        
        if (thisPointerStrong->_tfSMSContent.text.length > 0) {
            [[SportForumAPI sharedInstance]chatSendMessageBySendId:thisPointerStrong->_userId SendType:chat_send_text Content:thisPointerStrong->_tfSMSContent.text FinishedBlock:^void(int errorCode, NSString* strDescErr, NSString*strMsgId){
                if (errorCode == 0 && strMsgId.length > 0) {
                    thisPointerStrong->_tfSMSContent.text = @"";
                    //[thisPointerStrong->_tfMsgContent endEditing:YES];
                    [thisPointerStrong viewDidLoadData:@"" LastPageId:@""];
                }
            }];
        }
    };

    
    _lbPackageCount = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(_buttonSend.frame) - 20, 3, 40, 10)];
    _lbPackageCount.text = [NSString stringWithFormat:@"%d/%d", 1000, 1];
    _lbPackageCount.font = [UIFont boldSystemFontOfSize:11.0];
    _lbPackageCount.backgroundColor = [UIColor clearColor];
    _lbPackageCount.textColor = [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1.0];
    [_viewFootBar addSubview:_lbPackageCount];
    
    [self.view addSubview:_viewFootBar];
    [self.view bringSubviewToFront:_viewFootBar];
    
    _footViewStartY = self.view.frame.size.height - APP_FOOTER_BAR_HEIGHT;
    _footViewStartHeight = APP_FOOTER_BAR_HEIGHT;
}

-(void)viewDidLoadGui
{
    [self generateCommonViewInParent:self.view Title:_useNickName IsNeedBackBtn:YES];
        
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    [self setupSmsSendFooterBar];
    
    rect = CGRectMake(0, 5, viewBody.frame.size.width, APP_SCREEN_HEIGHT - CGRectGetMinY(viewBody.frame) - APP_FOOTER_BAR_HEIGHT - 10);
    
    _tvChatList = [[UITableView alloc]initWithFrame:rect];
    _tvChatList.backgroundColor = [UIColor clearColor];
    _tvChatList.separatorColor = [UIColor clearColor];
    _tvChatList.delegate = self;
    _tvChatList.dataSource = self;
    _tvChatList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tvChatList.allowsSelection = NO;
    _tvChatList.scrollsToTop = NO;
    
#if USE_EGO_REFRESH
    _egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tvChatList.frame.size.height, _tvChatList.frame.size.width, _tvChatList.frame.size.height)];
    _egoRefreshTableHeaderView.egoDelegate = (id<EGORefreshTableHeaderDelegate>)self;
    _egoRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
    [_tvChatList addSubview:_egoRefreshTableHeaderView];
    //  update the last update date
    [_egoRefreshTableHeaderView refreshLastUpdatedDate];
#endif

    [viewBody addSubview:_tvChatList];
}

-(void)reloadMsgData
{
    [self viewDidLoadData:_strFirstPageId LastPageId:@""];
}

-(void)viewDidLoadData:(NSString*)strFirstrPageId LastPageId:(NSString*)strLastPageId
{
    if ([ApplicationContext sharedInstance].accountInfo != nil && _userId.length > 0) {
        [[SportForumAPI sharedInstance]chatGetListByUserId:_userId FirstPageId:strFirstrPageId LastPageId:strLastPageId PageItemCount:20 FinishedBlock:^void(int errorCode, ChatMessagesList* chatMessagesList)
        {
            [self restartTimer_updateCellTime];

            if (errorCode == 0 && strLastPageId.length == 0 && [chatMessagesList.messages.data count] > 0) {
                [[SportForumAPI sharedInstance]eventChangeStatusReadByEventType:event_type_chat EventId:_userId FinishedBlock:^(int errorCode){
                    [[ApplicationContext sharedInstance]checkNewEvent:nil];
                }];
            }
            
            if(errorCode == 0 && [chatMessagesList.messages.data count] > 0)
            {
                if (strFirstrPageId.length == 0 && strLastPageId.length == 0) {
                    [_dataArray removeAllObjects];
                    
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
                    MessageItem *messageItem = [[MessageItem alloc]init];
                    messageItem.isReceived = [chatMessage.from_id isEqualToString:_userId] ? YES : NO;
                    messageItem.nMsgType =  [CommonFunction ConvertStringToChatSendType:chatMessage.type];
                    messageItem.msgId = chatMessage.message_id;
                    messageItem.userImage = messageItem.isReceived ? _useProImage : [ApplicationContext sharedInstance].accountInfo.profile_image;
                    messageItem.content = chatMessage.content;
                    messageItem.time = [NSDate dateWithTimeIntervalSince1970:chatMessage.time];
                    
                    [_dataArray addObject:messageItem];
                }
                
                [_dataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    MessageItem *messageItem1 = obj1;
                    MessageItem *messageItem2 = obj2;
                    return [messageItem1.time compare:messageItem2.time];
                }];
                
                [_tvChatList reloadData];
                [self moveToEndOfTable];
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
    
    //Load Gui
    [self viewDidLoadGui];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadMsgData];
    m_nMaxHeight = self.view.bounds.size.height;
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (m_timeGetChatList != nil && [m_timeGetChatList isValid]) {
        [m_timeGetChatList invalidate];
        m_timeGetChatList = nil;
    }
    
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _nPacket = 1;
    _nRemain = 160;
    _nMax = 1000;
    
    [_tfSMSContent endEditing:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_tfSMSContent endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [_tfSMSContent endEditing:NO];
    [IQKeyboardManager sharedManager].enable = YES;
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
}

- (void)handleWebSocketMsgComing:(NSNotification*) notification
{
    BOOL bMsgLoad = NO;
    NSMutableArray *arrChatInfo = [[notification userInfo]objectForKey:@"WSChatInfoList"];
    
    for (MsgWsInfo *msgWsInfo in arrChatInfo) {
        if([_userId isEqualToString:msgWsInfo.push.from])
        {
            MessageItem *messageItem = [[MessageItem alloc]init];
            messageItem.isReceived = YES;
            messageItem.msgId = msgWsInfo.push.pid;
            messageItem.userImage = _useProImage;
            messageItem.time = [NSDate dateWithTimeIntervalSince1970:msgWsInfo.time];
            
            for (MsgWsBodyItem *msgWsBodyItem in msgWsInfo.push.body.data) {
                if ([msgWsBodyItem.type isEqualToString:@"msg_type"]) {
                    messageItem.nMsgType = [CommonFunction ConvertStringToChatSendType:msgWsBodyItem.content];
                }
                else if([msgWsBodyItem.type isEqualToString:@"msg_content"])
                {
                    messageItem.content = msgWsBodyItem.content;
                }
            }
            
            [_dataArray addObject:messageItem];
            
            bMsgLoad = YES;
        }
    }
    
    if (bMsgLoad) {
        [_tvChatList reloadData];
        [self moveToEndOfTable];
        [self restartTimer_updateCellTime];
    }
}

- (void)restartTimer_updateCellTime
{
    if (m_timeGetChatList != nil && [m_timeGetChatList isValid]) {
        [m_timeGetChatList invalidate];
    }
    
    m_timeGetChatList = [NSTimer scheduledTimerWithTimeInterval: UPDATE_TIME_VALUE
                                                                target: self
                                                              selector: @selector(updateCellItemTime)
                                                              userInfo: nil
                                                               repeats: NO];
}

-(void)handleHideKeyboard
{
    [_tfSMSContent resignFirstResponder];
}

-(void)moveToEndOfTable
{
    if (_tvChatList.contentSize.height > _tvChatList.frame.size.height) {
        [_tvChatList setContentOffset:CGPointMake(0, _tvChatList.contentSize.height - _tvChatList.frame.size.height)];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25]; // if you want to slide up the view
    [UIView setAnimationDelegate:self];
    
    CGRect rect = _viewFootBar.frame;
    rect.origin.y = _footViewStartY - _keyboardHeight;
    if (movedUp)
    {
        _tapRecogniser= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTapGesture:)];
        [self.view addGestureRecognizer:_tapRecogniser];
    }
    else
    {
        // revert back to the normal state.
        [self.view removeGestureRecognizer:_tapRecogniser];
        _tapRecogniser = nil;
    }
    
    _viewFootBar.frame = rect;
    [UIView commitAnimations];
    [self updateHeightWithTextView];
}

-(void)keyboardWillHide: (NSNotification*)aNotification {
    _blKeyboardShow = NO;
    _tvChatList.scrollEnabled = YES;
    _keyboardHeight = 0;
    m_nMaxHeight = self.view.bounds.size.height;
    [self setViewMovedUp:NO];
}

-(void)keyboardWillShow: (NSNotification*)aNotification {
    // Animate the current view out of the way
    _blKeyboardShow = YES;
    _tvChatList.scrollEnabled = NO;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _keyboardHeight = kbSize.height;
    
    m_nMaxHeight = self.view.bounds.size.height - _keyboardHeight;
    [self setViewMovedUp:YES];
}

- (void)updateCellItemTime
{
    for (MessageItem *messageItem in _dataArray) {
        messageItem.time = [NSDate dateWithTimeIntervalSince1970:([messageItem.time timeIntervalSince1970] + UPDATE_TIME_VALUE)];;
    }
    
    [_tvChatList reloadData];
    [self restartTimer_updateCellTime];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSMutableString *newtxt = [NSMutableString stringWithString:textView.text];
    [newtxt replaceCharactersInRange:range withString:text];
    NSString * strFinalContent = [NSString stringWithString:newtxt];
    
    if([newtxt length] <= _nMax)
    {
        NSString * strFixedContent = [[CommonUtility sharedInstance]disable_emoji:strFinalContent];
        
        if([strFinalContent isEqualToString:strFixedContent])
        {
            _buttonSend.enabled = ([newtxt length] > 0);
            return YES;
        }
    }
    
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:_tfSMSContent])
    {
        UIImage * imgBK = [UIImage imageNamed:@"inputbox-Focused"];
        imgBK = [imgBK stretchableImageWithLeftCapWidth:floorf(imgBK.size.width/2) topCapHeight:floorf(imgBK.size.height/2)];
        m_imgInputContent.image = imgBK;
        
        //move the main view, so that the keyboard does not hide it.
        if  (!_blKeyboardShow)
        {
            [self setViewMovedUp:YES];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView isEqual:_tfSMSContent])
    {
        UIImage * imgBK = [UIImage imageNamed:@"inputbox-Normal"];
        imgBK = [imgBK stretchableImageWithLeftCapWidth:floorf(imgBK.size.width/2) topCapHeight:floorf(imgBK.size.height/2)];
        m_imgInputContent.image = imgBK;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *markedRange = [textView markedTextRange];
    NSString * newText = [textView textInRange:markedRange];

    _lbPackageCount.text = [NSString stringWithFormat:@"%ld/%d", newText.length, 10000];
    [self updateHeightWithTextView];
}

- (void)updateHeightWithTextView
{
    int nSpacer = 3;
    int nSpacer2 = 20;
    int nSpacer3 = 4;
    int nMax = m_nMaxHeight;
    CGSize textSize = [_tfSMSContent sizeThatFits:CGSizeMake(_tfSMSContent.frame.size.width, nMax)];
    
    if(textSize.height < _buttonSend.frame.size.height - 2 * nSpacer3)
    {
        textSize.height = _buttonSend.frame.size.height - 2 * nSpacer3;
    }
    
    if(textSize.height > nMax - (50 + 3 * nSpacer + _lbPackageCount.frame.size.height))
    {
        textSize.height = nMax - (50 + 3 * nSpacer + _lbPackageCount.frame.size.height);
    }
    
    CGRect rect = _viewFootBar.frame;
    rect.size.height = MAX(2 * nSpacer + nSpacer2 + textSize.height + _lbPackageCount.frame.size.height, UPDATE_TIME_VALUE);
    rect.origin.y = _footViewStartY - _keyboardHeight + UPDATE_TIME_VALUE - rect.size.height;
    _viewFootBar.frame = rect;
    
    rect = _lbPackageCount.frame;
    rect.origin.y = nSpacer;
    _lbPackageCount.frame = rect;
    
    rect = _tfSMSContent.frame;
    rect.origin.y = nSpacer * 2 + _lbPackageCount.frame.size.height + nSpacer3;
    rect.size.height = textSize.height;
    _tfSMSContent.frame = rect;
    m_imgInputContent.frame = rect;
    
    rect = _buttonSend.frame;
    rect.origin.y = _tfSMSContent.frame.origin.y + (_tfSMSContent.frame.size.height - _buttonSend.frame.size.height) / 2;
    _buttonSend.frame = rect;
    
    rect = _tvChatList.frame;
    rect.size.height = _viewFootBar.frame.origin.y - rect.origin.y;
    rect.size.width = self.view.frame.size.width;
    _tvChatList.frame = rect;
    [self moveToEndOfTable];
}

-(void)userDidTapGesture:(UITapGestureRecognizer*) tapgesture {
    [_tfSMSContent endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageItem *messageItem = _dataArray[indexPath.row];
    return [MessageCell heightOfCell:messageItem.content];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageItem *messageItem = _dataArray[indexPath.row];
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageDetailCell"];
    
    if (cell == nil) {
        cell = [[MessageCell alloc]initWithReuseIdentifier:@"MessageDetailCell"];
    }
    
    cell.messageItem = messageItem;
    cell.tag = indexPath.row;
    return cell;
}

// system callback function
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    NSLog(@"%@ dealloced!!", NSStringFromClass([self class]));
}

@end
