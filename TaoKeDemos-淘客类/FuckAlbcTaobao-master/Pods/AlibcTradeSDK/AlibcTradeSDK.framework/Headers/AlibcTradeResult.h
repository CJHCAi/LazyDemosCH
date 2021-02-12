/*
 * AlibcTradeResult.h 
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

/** 交易结果类型 */
typedef NS_ENUM (NSUInteger, ALiTradeResultType) {
    /** 成功添加到购物车 */
    ALiTradeResultTypeAddCard,
    /** 成功支付 */
    ALiTradeResultTypePaySuccess
} ;

/** 支付结果 */
@interface AlibcTradePayResult : NSObject
/** 支付成功订单 */
@property (nonatomic, copy, nullable, readonly) NSArray *paySuccessOrders;
/** 支付失败订单 */
@property (nonatomic, copy, nullable, readonly) NSArray *payFailedOrders;

@end

/** 交易结果 */
@interface AlibcTradeResult : NSObject
/** 交易结果的类型 */
@property (nonatomic, assign) ALiTradeResultType result;
/** 支付结果,只有Result为 ALiTradeResultTypePaySuccess时有效 */
@property (nonatomic, strong, nullable) AlibcTradePayResult *payResult;

@end



