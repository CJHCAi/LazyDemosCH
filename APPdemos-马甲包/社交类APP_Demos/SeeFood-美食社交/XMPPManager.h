//
//  XMPPManager.h
//  XMPP
//
//  Created by 纪洪波 on 15/11/19.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface XMPPManager : NSObject <XMPPStreamDelegate>
@property (nonatomic, strong) XMPPStream *stream;   //通信管道类
@property (nonatomic, strong) XMPPRoster *roster;   //好友列表
@property (nonatomic, strong) NSManagedObjectContext *context;          //所有消息都储存在CoreData中


//  单例
+ (XMPPManager *)shareXmppManager;

//  登陆
- (void)loginWithUser:(NSString *)user pass:(NSString *)pass;

//  注册
- (void)registWithUser:(NSString *)user pass:(NSString *)pass;
@end
