//
//  TLConversation+TLUser.h
//  TLChat
//
//  Created by 李伯坤 on 16/3/21.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "TLConversation.h"
#import "TLUser+ChatModel.h"
#import "TLGroup+ChatModel.h"

@interface TLConversation (TLUser)

- (void)updateUserInfo:(TLUser *)user;

- (void)updateGroupInfo:(TLGroup *)group;

@end
