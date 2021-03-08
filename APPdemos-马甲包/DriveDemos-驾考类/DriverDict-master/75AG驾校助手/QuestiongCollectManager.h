//
//  QuestiongCollectManager.h
//  75AG驾校助手
//
//  Created by again on 16/4/9.
//  Copyright © 2016年 again. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestiongCollectManager : NSObject
+ (NSArray *)getWrongQuestion;
+ (void)addWrongQuestion:(int)mid;
+ (void)removWrongQuestion:(int)mid;

+ (NSArray *)getCollectQuestion;
+ (void)addCollectQuestion:(int)mid;
+ (void)removeCollectQuestion:(int)mid;

+ (int)getMySorce;
+ (void)setMySorce:(int)sorce;
@end
