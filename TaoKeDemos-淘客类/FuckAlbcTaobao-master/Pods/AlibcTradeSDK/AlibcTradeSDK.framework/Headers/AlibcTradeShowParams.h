/*
 * AlibcTradeShowParams.h 
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

/**
 *  打开页面的类型
 */
typedef NS_ENUM(NSUInteger, ALiOpenType) {
    /** 智能判断 */
    ALiOpenTypeAuto,
    /** 强制跳手淘 */
    ALiOpenTypeNative,
    /** 强制h5展示 */
    ALiOpenTypeH5
};

@interface AlibcTradeShowParams : NSObject
/** 
 * 是否为push方式打开新页面
 * 当show page时传入自定义webview时,本参数没有实际意义
 *
 * NO : 在当前view controller上present新页面
 * YES: 在传入的UINavigationController中push新页面
 * 默认值:NO
 */
@property(nonatomic,assign) BOOL isNeedPush;
/** 
 * 打开页面的方式,详见ALiOpenType
 * 默认值:Auto 
 */
@property(nonatomic,assign) ALiOpenType openType;
/**
 * 指定手淘回跳的地址，跳转至isv指定的url
 * 规则: tbopen${appkey}://xx.xx.xx
 */
@property(nonatomic,strong) NSString *backUrl;

/**
 * applink使用，优先拉起的linkKey，手淘：@"taobao_scheme"
 */
@property(nonatomic,strong) NSString *linkKey;

@end
