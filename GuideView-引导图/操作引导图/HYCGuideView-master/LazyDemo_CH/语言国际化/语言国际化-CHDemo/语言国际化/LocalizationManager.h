//
//  CHLanguageManager.h
//  语言国际化
//
//  Created by ylh on 2019/12/12.
//  Copyright © 2019 ch. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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
+ (NSString *)getStringByKey:(NSString *)key;
///获取系统语言
+ (NSString *)getSystemLanguage;
@end

NS_ASSUME_NONNULL_END
