//
//  UILabel+MBIBnsepectable.m
//  XiaoMaBao
//
//  Created by 张磊 on 15/5/1.
//  Copyright (c) 2015年 MakeZL. All rights reserved.
//

#import "UILabel+MBIBnsepectable.h"

@implementation UILabel (MBIBnsepectable)
#pragma mark - hexRgbColor
- (void)setTextHexColor:(NSString *)textHexColor{
//    NSScanner *scanner = [NSScanner scannerWithString:textHexColor];
//    unsigned hexNum;
//    if (![scanner scanHexInt:&hexNum]) return;
//    self.textColor = [self colorWithRGBHex:hexNum];

    if (textHexColor.length<=0) {
        return;
    }
    self.textColor = [UIColor colorWithHexString:textHexColor];
}

- (UIColor *)colorWithRGBHex:(UInt32)hex {

    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


- (NSString *)textHexColor{
    return @"0xffffff";
}

- (void)setLocalizedString:(NSString *)localizedString {
    self.text = CustomLocalizedString(localizedString, nil);
}

- (NSString *)localizedString {
    return self.text;
}










@end
