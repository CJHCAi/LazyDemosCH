//
//  EventNewsInfo.h
//  SportForumApi
//
//  Created by liyuan on 14-6-16.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "BaseArray.h"

@interface EventNewsInfo : BaseObject

@property(assign, nonatomic) NSUInteger new_chat_count;
@property(assign, nonatomic) NSUInteger new_comment_count;
@property(assign, nonatomic) NSUInteger new_thumb_count;
@property(assign, nonatomic) NSUInteger new_reward_count;
@property(assign, nonatomic) NSUInteger new_attention_count;

@end

@interface EventNewsDetails : BaseObject

//id type MsgWsInfo
@property(strong, nonatomic) BaseArray *event_news;

-(id)init;

@end