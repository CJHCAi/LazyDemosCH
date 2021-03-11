//
//  Tools.h
//  StudyDrive
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Tools : NSObject
+(NSArray *)getAnswerWithString:(NSString *)str;
+(CGSize)getSizeWithStrng:(NSString *)str with:(UIFont *)font withSize:(CGSize)size;
@end
