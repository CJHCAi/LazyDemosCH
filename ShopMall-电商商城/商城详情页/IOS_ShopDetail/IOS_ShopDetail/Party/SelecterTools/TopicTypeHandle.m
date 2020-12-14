//
//  TopicTypeHandle.m
//  xtd_app_ios_financePeopleios
//
//  Created by 苟应航 on 2017/11/24.
//  Copyright © 2017年 Xtd. All rights reserved.
//

#import "TopicTypeHandle.h"
static TopicTypeHandle *sharedObj = nil;

@implementation TopicTypeHandle

+ (TopicTypeHandle*) sharedInstance  // 实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}



//设计感知
- (TopicTypeModel *) getDesignPerceptionListByType: (int)type{
    TopicTypeModel *model =[[TopicTypeModel alloc]init];
    model.topicType = type;
    model.subTitle = [NSArray arrayWithObjects:@"未使用", @"已使用", @"已过期",nil];
    model.cellType = [NSArray arrayWithObjects:@"RecommendViewController", @"TopicViewController", @"OriginateDesignViewController",nil];
    model.listViewType = [NSArray arrayWithObjects: [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    return model;
}
@end
