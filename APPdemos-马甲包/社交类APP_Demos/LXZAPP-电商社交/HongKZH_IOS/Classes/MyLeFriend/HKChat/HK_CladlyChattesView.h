//
//  HK_CladlyChattesView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/5/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

typedef void(^CicleQuitBlock)(void);

@interface HK_CladlyChattesView : RCConversationViewController

@property (nonatomic, copy) NSString *cicleId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, assign)NSInteger level;
@property (nonatomic, copy) CicleQuitBlock block;
@end
