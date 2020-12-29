//
//  ContactInfos.m
//  SportForumApi
//
//  Created by liyuan on 14-6-16.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import "ContactInfos.h"

@implementation ChatMessagesList

-(id)initWithSubClass:(NSString *)subClass
{
    self = [super init];
    
    if(self)
    {
        self.subName = subClass;
        self.messages = [[BaseArray alloc]initWithSubName:subClass];
    }
    
    return self;
}

@end

@implementation ContactInfos

-(id)initWithSubClass:(NSString *)subClass
{
    self = [super init];
    
    if(self)
    {
        self.subName = subClass;
        self.contact_infos = [[BaseArray alloc]initWithSubName:subClass];
    }
    
    return self;
}

@end

@implementation ChatMessage

@end

@implementation ContactObject

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.last_message = [[ChatMessage alloc]init];
    }
    
    return self;
}

@end