//
//  ContactInfos.h
//  SportForumApi
//
//  Created by liyuan on 14-6-16.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "BaseArray.h"

@interface ChatMessagesList : BaseObject

@property(strong, nonatomic) NSString *page_frist_id;
@property(strong, nonatomic) NSString *page_last_id;

//id type ChatMessage
@property(strong, nonatomic) BaseArray *messages;

-(id)initWithSubClass:(NSString *)subClass;

@end

@interface ContactInfos : BaseObject

//id type ContactObject
@property(strong, nonatomic) BaseArray *contact_infos;

-(id)initWithSubClass:(NSString *)subClass;

@end

@interface ChatMessage : BaseObject

@property(strong, nonatomic) NSString *message_id;
@property(strong, nonatomic) NSString *from_id;
@property(strong, nonatomic) NSString *to_id;
@property(strong, nonatomic) NSString *type;
@property(strong, nonatomic) NSString *content;
@property(assign, nonatomic) long long time;



@end

@interface ContactObject : BaseObject

@property(strong, nonatomic) NSString *userid;
@property(strong, nonatomic) NSString *nikename;
@property(strong, nonatomic) NSString *user_profile_image;
@property(assign, nonatomic) NSUInteger new_message_count;
@property(strong, nonatomic) ChatMessage *last_message;

-(id)init;

@end
