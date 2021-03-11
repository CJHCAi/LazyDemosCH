//
//  QuestiongCollectManager.m
//  75AG驾校助手
//
//  Created by again on 16/4/9.
//  Copyright © 2016年 again. All rights reserved.
//

#import "QuestiongCollectManager.h"

@implementation QuestiongCollectManager
+ (NSArray *)getWrongQuestion
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"WRONG_QUESTION"];
    if (array!=nil) {
        return array;
    } else {
        return @[];
    }
}

+ (void)addWrongQuestion:(int)mid
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"WRONG_QUESTION"];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:array];
    [muArr addObject:[NSString stringWithFormat:@"%d", mid]];
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:@"WRONG_QUESTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removWrongQuestion:(int)mid
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"WRONG_QUESTION"];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:array];
    for (int i = (int)(muArr.count-1); i>=0; i--) {
        if ([muArr[i] intValue] == mid) {
            [muArr removeObjectAtIndex:i];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:@"WRONG_QUESTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)getCollectQuestion
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"COLLECT_QUESTION"];
    if (array != nil) {
        return array;
    } else {
        return nil;
    }
}
//#warning 判断是否存在相同的题
+ (void)addCollectQuestion:(int)mid
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"COLLECT_QUESTION"];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:array];
    if ([muArr containsObject:[NSString stringWithFormat:@"%d", mid]]) {
        return;
    }
    [muArr addObject:[NSString stringWithFormat:@"%d", mid]];

    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:@"COLLECT_QUESTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"%@", muArr);
    if (muArr ==nil) return;
}

+ (void)removeCollectQuestion:(int)mid
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"COLLECT_QUESTION"];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:array];
    for (int i =(int)(muArr.count-1); i>=0; i--) {
        if ([muArr[i] intValue] ==mid) {
            [muArr removeObjectAtIndex:i];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:@"COLLECT_QUESTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)getMySorce
{
    int sorce = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"MY_SORCE"];
    return sorce;
}

+ (void)setMySorce:(int)sorce
{
    [[NSUserDefaults standardUserDefaults] setInteger:sorce forKey:@"MY_SORCE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
