//
//  UserInfo.m
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import "UserInfo.h"

@implementation UserRanks : BaseObject

@end

@implementation SysConfig

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.level_score = [[BaseArray alloc]initWithSubName:@""];
        self.pk_effects = [[BaseArray alloc]initWithSubName:@""];
    }
    
    return self;
}

@end

@implementation EventNotices

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.notices = [[BaseArray alloc]initWithSubName:@"MsgWsInfo"];
    }
    
    return self;
}

@end

@implementation MsgWsBodyItem

@end

@implementation MsgWsContent

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.body = [[BaseArray alloc]initWithSubName:@"MsgWsBodyItem"];
    }
    
    return self;
}

@end

@implementation MsgWsInfo

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.push = [[MsgWsContent alloc]init];
    }
    
    return self;
}

@end

@implementation EquipmentInfo

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.run_shoe = [[BaseArray alloc]initWithSubName:@""];
        self.ele_product = [[BaseArray alloc]initWithSubName:@""];
        self.step_tool = [[BaseArray alloc]initWithSubName:@""];
    }
    
    return self;
}

@end

@implementation PropertiesInfo

@end

@implementation  AuthInfo

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.auth_images = [[BaseArray alloc]initWithSubName:@""];
    }
    
    return self;
}

@end

@implementation AuthInfoList

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.idcard = [[AuthInfo alloc]init];
        self.cert = [[AuthInfo alloc]init];
        self.record = [[AuthInfo alloc]init];
    }
    
    return self;
}

@end

@implementation UserInfo

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.user_equipInfo = [[EquipmentInfo alloc]init];
        self.proper_info = [[PropertiesInfo alloc]init];
        self.auth_info = [[AuthInfoList alloc]init];
        self.user_images = [[BaseArray alloc]initWithSubName:@""];
    }
    
    return self;
}

@end

@implementation UserUpdateInfo

@end

@implementation ExpEffect

@end

@implementation TasksInfo

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.task_pics = [[BaseArray alloc]initWithSubName:@""];
    }
    
    return self;
}

@end

@implementation TasksInfoList

-(id)initWithSubClass:(NSString *)subClass
{
    self = [super init];
    
    if(self)
    {
        self.subName = subClass;
        self.task_list = [[BaseArray alloc]initWithSubName:subClass];
    }
    
    return self;
}

@end

@implementation TaskStatistics

@end

@implementation TasksCurInfo

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.task = [[TasksInfo alloc]init];
        self.stat = [[TaskStatistics alloc]init];
    }
    
    return self;
}

@end

@implementation TasksReferList

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.referrals = [[BaseArray alloc]initWithSubName:@"TasksReferInfo"];
    }
    
    return self;
}

@end

@implementation TasksReferInfo

@end

@implementation ImportContactList

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.users = [[BaseArray alloc]initWithSubName:@"UserInfo"];
    }
    
    return self;
}

@end

@implementation GameResultInfo

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.total_list = [[BaseArray alloc]initWithSubName:@"LeaderBoardItem"];
        self.friends_list = [[BaseArray alloc]initWithSubName:@"LeaderBoardItem"];
    }
    
    return self;
}

@end

@implementation PayHistory

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.payCoinList = [[BaseArray alloc]initWithSubName:@"PayCoinInfo"];
    }
    
    return self;
}

@end

@implementation PayCoinInfo

@end
