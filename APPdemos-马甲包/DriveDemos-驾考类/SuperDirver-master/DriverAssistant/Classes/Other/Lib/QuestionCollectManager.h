//
//  QuestionCollectManager.h
//  DriverAssistant
//
//  Created by C on 16/4/3.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionCollectManager : NSObject
/**
 取得错误题目
 */
+ (NSArray *)getWrongQuestion;
/**
 添加错误题目
 */
+ (void)addWrongQuestion:(int)mid;
/**
 删除错误题目
 */
+ (void)removeWrongQuestion:(int)mid;

/**
 取得收藏题目
 */
+ (NSArray *)getCollectQuestion;
/**
 添加收藏题目
 */
+ (void)addCollectQuestion:(int)mid;
/**
 删除收藏题目
 */
+ (void)removeCollectQuestion:(int)mid;

/**
 获取考试成绩
 */
+ (int)getScore;
/**
 存储考试成绩
 */
+(void)setScore:(int)score;

@end
