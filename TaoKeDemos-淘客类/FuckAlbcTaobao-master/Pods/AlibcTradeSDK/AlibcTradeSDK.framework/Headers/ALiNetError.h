/*
 * ALiNetError.h 
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

@interface ALiNetError : NSObject

/**
 *  错误码
 */
@property (nonatomic, copy) NSString *code;

/**
 *  错误信息
 */
@property (nonatomic, copy) NSString *msg;

/**
 *  原始错误对象
 */
@property (nonatomic, strong) NSError *rawError;

/**
 *  是否取消了登录
 */
@property (assign, nonatomic) BOOL                                               isLoginCancel;

/**
 *  是否取消了授权
 */
@property (assign, nonatomic) BOOL                                               isAuthCancel;

@end
