//
//  HK_LogoFormModel.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_LogoFormModel.h"

@implementation HK_LogoFormModel

- (BOOL)hasImage {
    if (self.value) {
        return YES;
    }
    return NO;
}

@end
