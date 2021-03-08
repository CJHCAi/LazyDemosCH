//
//  Tools.h
//  75AG驾校助手
//
//  Created by again on 16/4/8.
//  Copyright © 2016年 again. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tools : NSObject
+ (NSArray *)getAnswerWithString:(NSString *)str;
+ (CGSize)getSizeWithString:(NSString *)str with:(UIFont *)font withSize:(CGSize)size;
@end
