//
//  TMExpandModel.m
//  TMSwipeCell
//
//  Created by cocomanber on 2018/9/10.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "TMExpandModel.h"

@implementation TMExpandModel

+ (NSArray *)getAllDatas{
    NSMutableArray *array = @[].mutableCopy;
    
    for (int i = 0; i < 20; i ++) {
        TMExpandModel *model = [TMExpandModel new];
        model.name = [self getNameRand][arc4random()%([[self getNameRand] count])];
        model.headUrl = [self getHeadUrlRand][arc4random()%([[self getHeadUrlRand] count])];
        model.content = [self getContentRand][arc4random()%([[self getContentRand] count])];
        model.time = [self getTimeRand][arc4random()%([[self getTimeRand] count])];
        model.expandType = (arc4random()%10) % 2 == 0;
        [array addObject:model];
    }
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
