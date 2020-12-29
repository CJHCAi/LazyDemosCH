//
//  ArticlesInfo.m
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import "ArticlesInfo.h"

@implementation ArticlesInfo

-(id)initWithSubClass:(NSString *)subClass
{
    self = [super init];
    
    if(self)
    {
        self.subName = subClass;
        self.articles_without_content = [[BaseArray alloc]initWithSubName:subClass];
    }
    
    return self;
}

@end

@implementation ArticlesObject

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.subName = @"ArticleSegmentObject";
        self.article_segments = [[BaseArray alloc]initWithSubName:@"ArticleSegmentObject"];
        self.thumb_users = [[BaseArray alloc]initWithSubName:@""];
        self.authorInfo = [[UserInfo alloc]init];
        self.record = [[SportRecordInfo alloc]init];
    }
    
    return self;
}

@end


@implementation ArticleSegmentObject

@end