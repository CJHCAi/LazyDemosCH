//
//  SportRecordInfo.m
//  SportForum
//
//  Created by liyuan on 14-7-11.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "SportRecordInfo.h"

@implementation SportRecordInfo

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.sport_pics = [[BaseArray alloc]initWithSubName:@""];
    }
    
    return self;
}

@end

@implementation SportRecordInfoList

-(id)initWithSubClass:(NSString *)subClass
{
    self = [super init];
    
    if(self)
    {
        self.subName = subClass;
        self.record_list = [[BaseArray alloc]initWithSubName:subClass];
    }
    
    return self;
}

@end

@implementation LeaderBoardItem

@end

@implementation LeaderBoardItemList

-(id)initWithSubClass:(NSString *)subClass
{
    self = [super init];
    
    if(self)
    {
        self.subName = subClass;
        self.members_list = [[BaseArray alloc]initWithSubName:subClass];
    }
    
    return self;
}

@end

@implementation RecordStatisticsInfo

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.max_distance_record = [[SportRecordInfo alloc]init];
        self.max_speed_record = [[SportRecordInfo alloc]init];
    }
    
    return self;
}

@end

@implementation VideoInfo

@end

@implementation VideoSearchInfo
@end

@implementation VideoSearchInfoList

-(id)initWithSubClass:(NSString *)subClass
{
    self = [super init];
    
    if(self)
    {
        self.subName = subClass;
        self.videolist = [[BaseArray alloc]initWithSubName:subClass];
    }
    
    return self;
}

@end