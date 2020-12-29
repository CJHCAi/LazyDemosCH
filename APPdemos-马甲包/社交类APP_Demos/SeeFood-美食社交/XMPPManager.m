//
//  XMPPManager.m
//  XMPP
//
//  Created by 纪洪波 on 15/11/19.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "XMPPManager.h"

typedef NS_ENUM(NSInteger, connectionPurpose) {
    ConnectionPurposeLogin,
    ConnectionPurposeRegist
};

@interface XMPPManager () {
    connectionPurpose connectionP;
}
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *registPassword;
@property (nonatomic, strong) XMPPMessageArchiving *messageArchiving;   //聊天信息
@end

@implementation XMPPManager 
//  单例
+ (XMPPManager *)shareXmppManager {
    static XMPPManager *xmpp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xmpp = [[XMPPManager alloc]init];
    });
    return xmpp;
}

//  初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        //  初始化通信管道
        self.stream = [[XMPPStream alloc]init];
        self.stream.hostName = kHostName;
        self.stream.hostPort = kHostPort;
        //  添加代理
        [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //  初始化好友列表(使用CoreData保存列表信息)
        XMPPRosterCoreDataStorage *coreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        self.roster = [[XMPPRoster alloc]initWithRosterStorage:coreDataStorage dispatchQueue:dispatch_get_main_queue()];
        //  将好友列表与通信管道相连接
        [self.roster activate:self.stream];
        
        //  初始化聊天信息类
        XMPPMessageArchivingCoreDataStorage *messageCoreData = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        self.messageArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:messageCoreData dispatchQueue:dispatch_get_main_queue()];
        //  加入通信管道
        [self.messageArchiving activate:self.stream];
        self.context = messageCoreData.mainThreadManagedObjectContext;
    }
    return self;
}

//  登陆
- (void)loginWithUser:(NSString *)user pass:(NSString *)pass {
    self.password = pass;
    //  连接服务器
    [self connectToServerWithUser:user];
    //  登陆状态枚举
    connectionP = ConnectionPurposeLogin;
}

//  注册
- (void)registWithUser:(NSString *)user pass:(NSString *)pass {
    self.registPassword = pass;
    //  连接服务器
    [self connectToServerWithUser:user];
    //  登陆状态枚举
    connectionP = ConnectionPurposeRegist;
}

//  连接服务器
- (void)connectToServerWithUser:(NSString *)user {
    //  判断服务器是否连接
    if (self.stream.isConnected) {
        //  断开
        [self disConnectToServer];
    }
    //  验证身份
    //  创建XMPPJID用户
    XMPPJID *jid = [XMPPJID jidWithUser:user domain:kDomin resource:kResource];
    self.stream.myJID = jid;
    //  设置timeout
    [self.stream connectWithTimeout:30 error:nil];
}

//  断开服务器
- (void)disConnectToServer {
    [self.stream disconnect];
}

//  连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSLog(@"connection succese");
    if (connectionP == ConnectionPurposeLogin) {
        //  开始登陆
        [sender authenticateWithPassword:self.password error:nil];
    }else if(connectionP == ConnectionPurposeRegist){
        //  开始注册
        [sender registerWithPassword:self.registPassword error:nil];
    }
}

//  连接失败
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    NSLog(@"connection failed: %@",error);
}
@end
