//
//  ChatVC.m
//  XMPP
//
//  Created by 纪洪波 on 15/11/20.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "ChatVC.h"
#import "ChatCell.h"
#import "UIView+UIView_Frame.h"

#define KScreenWidth [[UIScreen mainScreen]bounds].size.width
#define KScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface ChatVC () <XMPPStreamDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *array;    //消息列队
@property (nonatomic, strong) XMPPManager *xmpp;
@property (weak, nonatomic) IBOutlet UITextField *input;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //  初始化UI
    [self initUI];

    //  初始化xmpp
    [self initXMPP];

    //  刷新数据
    [self reloadMessage];
    
    //添加通知
    [self addNotification];
    
}

//  初始化xmpp
- (void)initXMPP {
    self.xmpp = [XMPPManager shareXmppManager];
    [self.xmpp.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.array = [NSMutableArray array];
}

//  初始化UI
- (void)initUI {
    //  title显示
    self.navigationItem.title = self.jid.user;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.input.delegate = self;
    
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 40);
    self.toolView.frame = CGRectMake(0, KScreenHeight - 40, KScreenWidth, 40);
    self.input.frame = CGRectMake(5, 5, KScreenWidth - 3 * 5 - 30, 30);
    self.sendButton.frame = CGRectMake(KScreenWidth - 5 - 30, 5, 30, 30);
    self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height - KScreenHeight + 120);
    
    //  添加发送按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(sendMessage)];
    
    //  添加下滑隐藏键盘
    [self hideKeyboradWhenSlideDown];
}


//  添加下滑隐藏键盘
- (void)hideKeyboradWhenSlideDown {
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipAction:)];
    swip.direction = UISwipeGestureRecognizerDirectionDown;
    [self.tableView addGestureRecognizer:swip];
    swip.delegate = (id<UIGestureRecognizerDelegate>)self;
}

//  tableview与触控事件冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

//  发送消息
- (IBAction)sendAction:(id)sender {
    //  创建消息,指定发送对象
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.jid];
    [message addBody:self.input.text];
    [self.xmpp.stream sendElement:message];
    self.input.text = @"";
}

- (void)swipAction:(UISwipeGestureRecognizer *)swipe {
    [self.input resignFirstResponder];
}

//  添加通知
- (void)addNotification {
    //  键盘弹出
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //  键盘高度改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHeightWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //  键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//  键盘弹出
- (void)keyboardWillShow:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}

//  键盘高度改变
- (void)keyboardHeightWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}

//  键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 40);

}

//  移动toolView
- (void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.toolView.frame = CGRectMake(0, KScreenHeight - height - 40, KScreenWidth, 40);
    }];
    self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height - KScreenHeight + height + 40);
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - height - 40);
}

//  发送消息
- (void)sendMessage {
    //  创建消息,指定发送对象
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.jid];
    [message addBody:@"hello"];
    [self.xmpp.stream sendElement:message];
}

//  刷新消息
- (void)reloadMessage {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    //  所有的好友信息都储存在message中,需要通过user检索
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@ and streamBareJidStr = %@", self.jid.bare, self.xmpp.stream.myJID.bare];
    request.predicate = predicate;
    //  根据发送时间对消息进行排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    NSArray *array = [self.xmpp.context executeFetchRequest:request error:nil];
    [self.array removeAllObjects];
    [self.array addObjectsFromArray:array];
    [self.tableView reloadData];
    //  添加信息弹出动画
    NSInteger row = self.array.count -1;
    if (row < 0) {
        row = 0;
    }
    if (self.array.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

//  发送成功(代理)
-(void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    NSLog(@"发送成功");
    //  刷新消息列表
    [self reloadMessage];
}

//  发送失败(代理)
-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error {
    NSLog(@"发送失败:%@", error);
}

//  接受消息(代理)
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    NSLog(@"收到消息:%@", message);
    //  刷新
    [self reloadMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPMessageArchiving_Message_CoreDataObject *message = self.array[indexPath.row];
    return [ChatCell heightForText:message.body];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
    XMPPMessageArchiving_Message_CoreDataObject *message = self.array[indexPath.row];
    
    if (message.isOutgoing) {
        //  发送的消息
        cell.outMessageLable.text = message.body;
        cell.inMessageLable.text = @"";
        cell.outImage.hidden = NO;
        cell.inImage.hidden = YES;
        
    }else {
        //  接受的消息
        cell.inMessageLable.text = message.body;
        cell.outMessageLable.text = @"";
        cell.inImage.hidden = NO;
        cell.outImage.hidden = YES;
        
    }
    [cell updateFrameWithMessage:message.body];
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.input resignFirstResponder];
}


@end
