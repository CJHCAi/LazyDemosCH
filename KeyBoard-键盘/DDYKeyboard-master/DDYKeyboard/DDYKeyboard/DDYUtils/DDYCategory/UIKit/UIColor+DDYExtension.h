//
//  UIColor+DDYExtension.h
//  DDYCategory
//
//  Created by SmartMesh on 2018/7/13.
//  Copyright © 2018年 com.smartmesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DDYExtension)

/** 16进制color */
+ (nullable UIColor *)ddy_ColorWithHexString:(NSString *)hexString;
/** [0, 1]范围 */
+ (UIColor *)ddy_ColorFloatR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;
/** [0, 255]范围 */
+ (UIColor *)ddy_ColorIntR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b a:(NSInteger)a;

@end
