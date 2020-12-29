//
//  HK_GladlyFriendNewsView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface HK_GladlyFriendNewsView : RCConversationListViewController
-(void)addChat:(RCConversationType)ConversationType targetString:(NSString *)targetid addTitle:(NSString *)title;
@end
