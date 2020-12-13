//
//  YIMEditerSetting.m
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerSetting.h"

@implementation YIMEditerSetting

static YIMEditerSetting *_yimEditerSettingAppearance;
+(instancetype)appearance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _yimEditerSettingAppearance = [[YIMEditerSetting alloc]init];
        _yimEditerSettingAppearance.tintColor = [UIColor colorWithRed:0x91/255.0 green:0xC1/255.0 blue:0xE1/255.0 alpha:1];
    });
    return _yimEditerSettingAppearance;
}

@end
