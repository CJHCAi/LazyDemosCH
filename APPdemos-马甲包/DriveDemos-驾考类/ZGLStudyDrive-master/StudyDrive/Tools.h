//
//  Tools.h
//  StudyDrive
//
//  Created by zgl on 16/1/7.
//  Copyright © 2016年 sj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject

+(NSArray *)getAnswerWithString:(NSString *)str;
+(CGSize)getSizeWithString:(NSString *)str withFont:(UIFont *)font withSize:(CGSize)size;

@end
