//
//  EasemobManager.m
//  环信测试
//
//  Created by tarena on 16/9/1.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "EasemobManager.h"
static EasemobManager *_manager;
@implementation EasemobManager
+(EasemobManager *)shareManager{
    
    @synchronized(self) {
        if (!_manager) {
            _manager = [[EasemobManager alloc]init];
            [[EaseMob sharedInstance].chatManager addDelegate:_manager delegateQueue:nil];
            
        }
    }
    return _manager;
}

-(NSMutableArray *)requets{
    if (!_requets) {
        _requets = [NSMutableArray array];
    }
    
    return _requets;
}

-(void)logingWithName:(NSString *)name andPW:(NSString *)pw{
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:name password:pw completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            NSLog(@"登录成功");
            
            // 设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            //发出登录成功的广播
            [[NSNotificationCenter defaultCenter]postNotificationName:@"登录成功" object:nil];
            
            
        }else{//如果登录失败 注册一下
            
            [self registerWithName:name andPW:pw];
            
            
        }
        
    } onQueue:nil];
    
    
}
-(void)addFriendWithName:(NSString *)name{
    NSLog(@"%@",name);
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:name message:@"我想加您为好友" error:&error];
    if (isSuccess && !error) {
        NSLog(@"添加成功");
    }
}

-(void)deleteFirendWithName:(NSString *)name{
    
    // 删除好友
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:name removeFromRemote:YES error:&error];
    if (isSuccess && !error) {
        NSLog(@"删除成功");
    }
    
    
}
-(void)logout{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
        }
    } onQueue:nil];
    
}
-(void)registerWithName:(NSString *)name andPW:(NSString *)pw{
    
    
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:name  password:pw withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
            //注册成功后直接登录
            [self logingWithName:name andPW:pw];
            
        }
    } onQueue:nil];
    
}

#pragma mark Delegate
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    if (!message) {
        message = @"";
    }
    
    [self.requets addObject:@{@"username":username,@"message":message}];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"好友状态改变" object:nil];
}



- (void)didAcceptedByBuddy:(NSString *)username{
    
    //需要让好友列表页面更新
    [[NSNotificationCenter defaultCenter]postNotificationName:@"好友状态改变" object:nil];
    
}


- (void)didRejectedByBuddy:(NSString *)username{
    NSLog(@"对方拒绝了请求");
    
}


-(EMMessage *)sendMessageWithText:(NSString *)text andUsername:(NSString *)username{
    EMChatText *txtChat = [[EMChatText alloc] initWithText:text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:username bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:self];
    
    return message;
    
}

-(EMMessage *)sendMessageWithImage:(UIImage *)image andUsername:(NSString *)username{
    
    EMChatImage *imgChat = [[EMChatImage alloc] initWithUIImage:image displayName:@"abc.jpg"];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithChatObject:imgChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:username bodies:@[body]];
    message.messageType = eMessageTypeChat;
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:self];
    
    return message;
}

-(EMMessage *)sendMessageWithVoiceData:(NSData *)data andTime:(float)time andUsername:(NSString *)username{
    
    EMChatVoice *voice = [[EMChatVoice alloc] initWithData:data displayName:@"a.amr"];
    voice.duration = time;
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:username bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:self];
    return message;
    
    
}

- (void)setProgress:(float)progress
         forMessage:(EMMessage *)message
     forMessageBody:(id<IEMMessageBody>)messageBody{
    NSLog(@"发送进度：%f",progress);
    
}

//接收消息的协议方法
- (void)didReceiveMessage:(EMMessage *)message{
    
    NSString *alertBody = nil;
    //得到消息的具体内容
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch ((int)msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            alertBody = [NSString stringWithFormat:@"%@:%@",message.from,txt];
        }
            break;
        case eMessageBodyType_Image:
        {
            alertBody = [NSString stringWithFormat:@"%@:[图片消息]",message.from];
        }
            break;
        case eMessageBodyType_Voice:
        {
            alertBody = [NSString stringWithFormat:@"%@:[语音消息]",message.from];
        }
            break;
    }
    
    //判断程序是否在后台执行
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        
        NSLog(@"后台收到消息");
        UILocalNotification *noti = [[UILocalNotification alloc]init];
        //设置显示时间  立即显示
        noti.fireDate = [NSDate new];
        //设置显示内容
        noti.alertBody = alertBody;
        //设置传递的参数
        noti.userInfo = @{@"username":message.from};
        //把通知添加到日程
        [[UIApplication sharedApplication]scheduleLocalNotification:noti];
        //设置icon上显示的数量
        [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"接收消息" object:message ];
    
}

@end

