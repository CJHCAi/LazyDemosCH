//
//  UIColor+TLChat.m
//  TLChat
//
//  Created by 李伯坤 on 16/1/27.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "UIColor+TLChat.h"

@implementation UIColor (TLChat)

#pragma mark - # 字体
+ (UIColor *)colorTextBlack {
    return [UIColor blackColor];
}

+ (UIColor *)colorTextGray {
    return [UIColor grayColor];
}

+ (UIColor *)colorTextGray1 {
    return RGBAColor(160, 160, 160, 1.0);
}

#pragma mark - 灰色
+ (UIColor *)colorGrayBG {
    return RGBAColor(239.0, 239.0, 244.0, 1.0);
}

+ (UIColor *)colorGrayCharcoalBG {
    return RGBAColor(235.0, 235.0, 235.0, 1.0);
}

+ (UIColor *)colorGrayLine {
    return [UIColor colorWithWhite:0.5 alpha:0.3];
}

+ (UIColor *)colorGrayForChatBar {
    return RGBAColor(245.0, 245.0, 247.0, 1.0);
}

+ (UIColor *)colorGrayForMoment {
    return RGBAColor(243.0, 243.0, 245.0, 1.0);
}




#pragma mark - 绿色
+ (UIColor *)colorGreenDefault {
    return RGBAColor(2.0, 187.0, 0.0, 1.0f);
}

+ (UIColor *)colorGreenHL {
    return RGBAColor(46, 139, 46, 1.0f);
}

#pragma mark - 蓝色
+ (UIColor *)colorBlueMoment {
    return RGBAColor(74.0, 99.0, 141.0, 1.0);
}

#pragma mark - 黑色
+ (UIColor *)colorBlackForNavBar {
    return RGBAColor(20.0, 20.0, 20.0, 1.0);
}

+ (UIColor *)colorBlackBG {
    return RGBAColor(46.0, 49.0, 50.0, 1.0);
}

+ (UIColor *)colorBlackAlphaScannerBG {
    return [UIColor colorWithWhite:0 alpha:0.6];
}

+ (UIColor *)colorBlackForAddMenu {
    return RGBAColor(71, 70, 73, 1.0);
}

+ (UIColor *)colorBlackForAddMenuHL {
    return RGBAColor(65, 64, 67, 1.0);
}


#pragma mark - # 红色
+ (UIColor *)colorRedForButton {
    return RGBColor(228, 68, 71);
}

+ (UIColor *)colorRedForButtonHL {
    return RGBColor(205, 62, 64);
}

@end
