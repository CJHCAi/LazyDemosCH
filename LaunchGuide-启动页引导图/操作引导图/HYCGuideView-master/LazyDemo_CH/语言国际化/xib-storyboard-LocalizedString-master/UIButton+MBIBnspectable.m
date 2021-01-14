//
//  UIButton+MBIBnspectable.m
//  iBestProduct
//
//  Created by xiekunpeng on 2018/6/19.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "UIButton+MBIBnspectable.h"

@implementation UIButton (MBIBnspectable)
- (void)setLocalizedString:(NSString *)localizedString {
    [self setTitle:CustomLocalizedString(localizedString, nil) forState:UIControlStateNormal];
}


- (NSString *)localizedString {
    return self.titleLabel.text;
}


@end
