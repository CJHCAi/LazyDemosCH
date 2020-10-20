//
//  NSString+SXTStringHelpe.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/24.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SXTStringHelpe)

+ (CGFloat)returnLabelTextHeight:(NSString *)text
                           width:(CGFloat)width
                        fontSize:(UIFont *)font;

@end
