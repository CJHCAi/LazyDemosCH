//
//  LocalizationManager.h
//  mxchipApp
//
//  Created by 黄坚 on 2018/3/16.
//  Copyright © 2018年 黄坚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizationManager : NSObject
/// 获取当前资源文件
+ (NSBundle *)bundle;
/// 初始化语言文件
+ (void)initUserLanguage;
/// 获取应用当前语言
+ (NSString *)userLanguage;
/// 设置当前语言
+ (void)setUserlanguage:(NSString *)language;
/// 通过Key获得对应的string
+ (NSString *)getStringByKey:(NSString *)key table:(NSString *)fileName;

+ (NSString *)getSystemLanguage;
@end
