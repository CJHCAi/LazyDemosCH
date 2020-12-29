//
//  BaseArray.m
//  SportForumApi
//
//  Created by liyuan on 14-1-3.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import "BaseArray.h"

@implementation BaseArray

-(id)initWithSubName:(NSString *)subName
{
    self = [super init];
    
    if(self)
    {
        self.subName = subName;
        self.data = [[NSMutableArray alloc]init];
    }
    
    return self;
}

@end
