//
//  GDLocalizableController.h
//  Internationalization
//
//  Created by Qiulong-CQ on 16/12/2.
//  Copyright © 2016年 xiaoheng. All rights reserved.
//


// ----- 多语言设置
#define CHINESE @"zh-Hans"
#define ENGLISH @"en"
#define GDLocalizedString(key) [[GDLocalizableController bundle] localizedStringForKey:(key) value:@"" table:nil]

#import <Foundation/Foundation.h>

@interface GDLocalizableController : NSObject


+(NSBundle *)bundle;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言

@end
