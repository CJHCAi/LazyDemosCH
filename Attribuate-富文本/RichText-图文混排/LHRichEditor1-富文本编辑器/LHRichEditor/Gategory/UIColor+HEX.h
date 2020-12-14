//
//  UIColor+HEX.h
//  XDZHBook
//
//  Created by 刘昊 on 2018/4/24.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HEX)
- (NSString *)HEXString;

+ (UIColor *)colorWithHexString:(NSString *)hexString;
@end
