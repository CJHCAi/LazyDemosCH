/*
 * AlibcTradeSDK.h 
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

#import <AlibcTradeSDK/AlibcTradeResult.h>
#import <AlibcTradeSDK/AlibcTradePageFactory.h>
#import <AlibcTradeSDK/AlibcTradeService.h>
#import <AlibcTradeSDK/AlibcTradeError.h>
#import <AlibcTradeSDK/AlibcTradeShowParams.h>


#define ALiSDKVersion @"3.1.1.5"

/** 环境,测试和预发,只有内网有效,外部使用只能用线上环境 */
typedef NS_ENUM (NSUInteger, ALiEnvironment) {
    /** 未定义环境 */
    ALiEnvironmentNone = -1,
    /** 测试环境 */
    ALiEnvironmentDaily = 0,
    /** 预发环境 */
    ALiEnvironmentPreRelease,
    /** 线上环境 */
    ALiEnvironmentRelease
};


@interface AlibcTradeSDK :NSObject

/**
 *  AlibcTradeSDK 的单例对象
 */
+ (instancetype)sharedInstance;

/**
 *  !!!: 已弃用
 *  初始化函数,初始化成功后方可正常使用SDK中的功能
 *
 *  @param appKey    该App对应的AppKey
 *  @param onSuccess 初始化成功的回调
 *  @param onFailure 初始化失败的回调
 */
/*
- (void)asyncInit:(NSString*)appKey
          success:(void (^)())onSuccess
          failure:(void (^)(NSError *error))onFailure DEPRECATED_ATTRIBUTE;
*/

/**
 *  初始化函数,初始化成功后方可正常使用SDK中的功能
 *
 *  @param onSuccess 初始化成功的回调
 *  @param onFailure 初始化失败的回调
 */
- (void)asyncInitWithSuccess:(void (^)())onSuccess
                     failure:(void (^)(NSError *error))onFailure;

/**
 *  获取service对象,该对象包含大部分Trade相关的方法
 */
-(id<AlibcTradeService>)tradeService;

/**
 *  用于处理其他App的回跳
 *
 *  @param url 需要进行判断的URL对象
 *
 *  @return 是否被SDK进行处理
 */
- (BOOL)handleOpenURL:(NSURL *)url;

@end


@interface AlibcTradeSDK (Settings)

- (void)setDebugLogOpen:(BOOL)isDebugLogOpen;

/**
 *  设置环境
 */
- (void)setEnv:(ALiEnvironment)env;

/**
 *  获取当前环境对象
 */
- (ALiEnvironment)getEnv;

/**
 *  设置全局配置,是否强制使用h5
 *
 *  @param isForceH5 是否强制使用h5,show接口的AlibcTradeShowParams参数优先级比这里高,AlibcTradeShowParams设置ALiOpenTypeNative,依然可以跳手淘..
 */
- (void)setIsForceH5:(BOOL)isForceH5;

/*
 *  设置是否对淘客使用同步打点
 *  默认的淘客打点方式,sdk会自己选择合适的方式,调用该接口与否不影响打点,建议开发者不要调用自己配置
 *  只有跟阿里妈妈申请了高分润的才需要设为同步
 *
 *  @param isSync 是否对淘客使用同步打点
 */
- (void)setIsSyncForTaoke:(BOOL)isSync;

/**
 *  设置三方App版本,可用于标识App版本
 *
 *  @param version 版本字段
 */
- (void)setIsvVersion:(NSString*)version;

/**
 *  设置App标识字段,和isvcode同义,可用于区分使用本SDK的具体三方App
 *
 *  @param code isv code 字段
 */
- (void)setISVCode:(NSString *)code;

/**
 *  设置默认淘客参数
 *
 *  @param param 传入一个配置好的AlibcTradeTaokeParams作为默认淘客参数,详见 AlibcTradeTaokeParams.h
 */

- (void)setTaokeParams:(AlibcTradeTaokeParams*)param;

/**
 *  设置渠道信息,渠道专享价专用.
 *
 *  @param type 渠道类型
 *  @param name 渠道名
 */
- (void)setChannel:(NSString *)type name:(NSString *)name;

/**
 *  开启接口免授权模式,
 *  请不要随便设置,没有在后台申请相关的权限的,开启后会导致网络请求失败
 *
 */
- (void)enableAuthVipMode;

/**
 *  设置是否需要 Native AliPay 接口
 *
 *  @param shouldUseAlipay 是否需要 Native AliPay 接口
 */
- (void)setShouldUseAlipayNative:(BOOL)shouldUseAlipayNative;

@end
