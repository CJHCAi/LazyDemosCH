//
//  UIColor+Random.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Random)
/**
 *  @brief  随机颜色
 *
 *  @return UIColor
 */
+ (UIColor *)RandomColor;
@end



#define  LMJ_HexColor(hex)        [UIColor colorWithHexString:@#hex]
@interface UIColor (EXtension_LMJ)
// 默认alpha位1
+ (UIColor *)colorWithHexString:(NSString *)color;
@end
