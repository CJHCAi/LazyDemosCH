/*
 * ALiSecurityGuardBridge.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeSDK 
 * 版本号：3.1.1.5
 * 发布时间：2016-10-14
 * 开发团队：阿里巴巴百川商业化团队
 * 阿里巴巴电商SDK答疑群号：1229144682(阿里旺旺)
 * Copyright (c) 2016-2019 阿里巴巴-移动事业群-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface ALiSecurityGuardBridge : NSObject


#pragma mark - Life Cycle

+ (void)pInitialize:(void (^)(NSError *))handler;


#pragma mark - Info

+ (BOOL)isSecurityGuardAvaleable;

+ (NSString *)authCode;

+ (NSString *)getAppKey;


#pragma mark - Encryption & Decryption

+ (NSNumber *)analyzeItemId:(NSString *)itemId;


#pragma mark - Storage

+ (NSString*) getString: (NSString*) key;

+ (int) putString: (NSString*) value forKey: (NSString*) key;

+ (NSData*) getData: (NSString*) key;

+ (int) putData: (NSData*) value forKey: (NSString*) key;

@end
