//
//  EventNewsInfo.m
//  SportForumApi
//
//  Created by liyuan on 14-6-16.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import "EventNewsInfo.h"

@implementation EventNewsInfo

@end

@implementation EventNewsDetails

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.event_news = [[BaseArray alloc]initWithSubName:@"MsgWsInfo"];
    }
    
    return self;
}

@end