/*
 * AlibcTradeError.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeSDK 
 * 版本号：3.1.1.5
 * 发布时间：2016-10-14
 * 开发团队：阿里巴巴百川商业化团队
 * 阿里巴巴电商SDK答疑群号：1229144682(阿里旺旺)
 * Copyright (c) 2016-2019 阿里巴巴-移动事业群-百川. All rights reserved.
 */

#ifndef ALiError_h
#define ALiError_h


#import <Foundation/Foundation.h>

/** 交易错误码 */
typedef NS_ENUM (NSUInteger, AlibcTradeError) {
    /** 交易链路失败 */
    ALiErrorProcessFailed = 3001,
    /** 交易链路中用户取消了操作 */
    ALiErrorCancelled     = 3002,
    /** 交易链路中发生支付但是支付失败 */
    ALiErrorPaymentFailed = 3003,
    /** itemId无效 */
    ALiErrorInvalidItemID = 3004,
    /** page url为空 */
    ALiErrorNullPageURL   = 3005,
    /** shopId无效 */
    ALiErrorInvalidShopID = 3006,
};

extern NSString * const AlibcTradeErrorDomain;

#endif /* ALiError_h */
