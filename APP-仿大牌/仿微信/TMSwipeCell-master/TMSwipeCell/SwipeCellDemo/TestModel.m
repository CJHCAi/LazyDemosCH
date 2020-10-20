//
//  TestModel.m
//  TMSwipeCell
//
//  Created by cocomanber on 2018/7/7.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "TestModel.h"

NSString *const TMSWIPE_FRIEND = @"TMSWIPE_FRIEND";
NSString *const TMSWIPE_PUBLIC = @"TMSWIPE_PUBLIC";
NSString *const TMSWIPE_OTHERS = @"TMSWIPE_OTHERS";

@implementation TestModel

+ (NSArray *)getAllDatas{
    NSMutableArray *array = @[].mutableCopy;
    
    for (int i = 0; i < 20; i ++) {
        TestModel *model = [TestModel new];
        model.name = [self getNameRand][arc4random()%([[self getNameRand] count])];
        model.headUrl = [self getHeadUrlRand][arc4random()%([[self getHeadUrlRand] count])];
        model.content = [self getContentRand][arc4random()%([[self getContentRand] count])];
        model.time = [self getTimeRand][arc4random()%([[self getTimeRand] count])];
        model.message_id = TMSWIPE_FRIEND;
        if (i % 3 == 0) {
            model.message_id = TMSWIPE_OTHERS;
        }
        [array addObject:model];
    }
    
    TestModel *model = [TestModel new];
    model.name = @"公众号消息";
    model.headUrl = @"006";
    model.content = @"支持XIB，只需继承，支持block和代理";
    model.time = @"00:56";
    model.message_id = TMSWIPE_PUBLIC;
    
    TestModel *model1 = [TestModel new];
    model1.name = @"公众号";
    model1.headUrl = @"006";
    model1.content = @"支持XIB，只需继承，支持block和代理";
    model1.time = @"13:16";
    model1.message_id = TMSWIPE_PUBLIC;
    
    [array insertObject:model atIndex:2];
    [array insertObject:model1 atIndex:5];
    return array.copy;
}

+ (NSArray *)getNameRand{
    return @[@"以柔",@"惜晴",@"巧容",@"向烟",@"寒玉",@"凝薇",@"慕烟",@"凌曼"];
}

+ (NSArray *)getHeadUrlRand{
    return @[@"001",@"002",@"003",@"004",@"005"];
}

+ (NSArray *)getContentRand{
    return @[@"你好",@"一起吃饭吧",@"你在写什么",@"明天去哪儿玩呢，问你呢",@"今天又是星期五了呢，真好"];
}

+ (NSArray *)getTimeRand{
    return @[@"12:31",@"02:23",@"14:56",@"17:34",@"20:56"];
}

@end
