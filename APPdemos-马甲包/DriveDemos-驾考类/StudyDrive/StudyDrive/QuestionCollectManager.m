//
//  QuestionCollectManager.m
//  StudyDrive
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "QuestionCollectManager.h"

@implementation QuestionCollectManager
+(NSArray *)getWrongQuestion{
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"WRONG_QUESTION"];
    if (array!=nil) {
        return array;
    }else{
        return @[];
    }
}

+(void)addWrongQuestion:(int)mid{
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"WRONG_QUESTION"];
    NSMutableArray * muArr = [NSMutableArray arrayWithArray:array];
    [muArr addObject:[NSString stringWithFormat:@"%d",mid]];
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:@"WRONG_QUESTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)removeWrongQustion:(int)mid{
     NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"WRONG_QUESTION"];
     NSMutableArray * muArr = [NSMutableArray arrayWithArray:array];
    for (int i=(int)muArr.count-1; i>=0; i--) {
        if ([muArr[i] intValue]==mid) {
            [muArr removeObjectAtIndex:i];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:@"WRONG_QUESTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+(NSArray *)getCollectQuestion{
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"COLLECT_QUESTION"];
    if (array!=nil) {
        return array;
    }else{
        return @[];
    }
}

+(void)addCollectQuestion:(int)mid{
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"COLLECT_QUESTION"];
    NSMutableArray * muArr = [NSMutableArray arrayWithArray:array];
    [muArr addObject:[NSString stringWithFormat:@"%d",mid]];
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:@"COLLECT_QUESTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)removeCollectQustion:(int)mid{
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"COLLECT_QUESTION"];
    NSMutableArray * muArr = [NSMutableArray arrayWithArray:array];
    for (int i=(int)muArr.count-1; i>=0; i--) {
        if ([muArr[i] intValue]==mid) {
            [muArr removeObjectAtIndex:i];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:@"COLLECT_QUESTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+(int)getMySorce{
     int  sorce = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"MY_SORCE"];
    return sorce;
}
+(void)setMySorce:(int)sorce{
    [[NSUserDefaults standardUserDefaults] setInteger:sorce forKey:@"MY_SORCE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
