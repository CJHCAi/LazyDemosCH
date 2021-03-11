//
//  QuestionCollectManager.m
//  DriverAssistant
//
//  Created by C on 16/4/3.
//  Copyright © 2016年 C. All rights reserved.
//

#import "QuestionCollectManager.h"

@implementation QuestionCollectManager
#pragma mark - 错题
+ (NSArray *)getWrongQuestion{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"WRONG_QUESTION"];
    if (array!=nil) {
        return  array;
    }
    else{
        return @[];
    }
}
+ (void)addWrongQuestion:(int)mid{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"WRONG_QUESTION"];
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:array];
    [mArr addObject:[NSString stringWithFormat:@"%d", mid]];
    [[NSUserDefaults standardUserDefaults] setObject:mArr forKey:@"WRONG_QUESTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeWrongQuestion:(int)mid{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"WRONG_QUESTION"];
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:array];

    for (int i = (int)mArr.count - 1; i>=0; i--) {
        if ([mArr[i] intValue]==mid) {
            [mArr removeObjectAtIndex:i];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:mArr forKey:@"WRONG_QUESTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

#pragma mark - 收藏
+ (NSArray *)getCollectQuestion{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"COLLECT_QUESTION"];
    if (array!=nil) {
        return  array;
    }
    else{
        return @[];
    }
}

+ (void)addCollectQuestion:(int)mid{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"COLLECT_QUESTION"];
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:array];
    [mArr addObject:[NSString stringWithFormat:@"%d", mid]];
    [[NSUserDefaults standardUserDefaults] setObject:mArr forKey:@"COLLECT_QUESTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeCollectQuestion:(int)mid{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"COLLECT_QUESTION"];
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:array];
    
    for (int i = (int)mArr.count - 1; i>=0; i--) {
        if ([mArr[i] intValue]==mid) {
            [mArr removeObjectAtIndex:i];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:mArr forKey:@"COLLECT_QUESTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (int)getScore{
    int  score = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"MY_SCORE"];
    return score;
}

+(void)setScore:(int)score{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"MY_SCORE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
