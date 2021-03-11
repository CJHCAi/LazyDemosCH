//
//  QuestionCollectManager.h
//  StudyDrive
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionCollectManager : NSObject
+(NSArray *)getWrongQuestion;
+(void)addWrongQuestion:(int)mid;
+(void)removeWrongQustion:(int)mid;

+(NSArray *)getCollectQuestion;
+(void)addCollectQuestion:(int)mid;
+(void)removeCollectQustion:(int)mid;

+(int)getMySorce;
+(void)setMySorce:(int)sorce;
@end
