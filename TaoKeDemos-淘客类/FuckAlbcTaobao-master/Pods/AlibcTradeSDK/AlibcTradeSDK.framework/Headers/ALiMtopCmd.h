/*
 * ALiMtopCmd.h 
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

@interface ALiMtopCmd : NSObject
@property(nonatomic, strong) NSString *_Nonnull name; // mtop命令
@property(nonatomic, strong) NSString *_Nonnull version; //版本,默认是@"1.0"
@property(nonatomic, assign) BOOL needLogin;             //是否需要登录,默认值:NO
@property(nonatomic, assign) BOOL needAuth;              //是否需要授权,默认值:NO
@property(nonatomic, assign) BOOL needWUA;    //是否需要人机识别,默认是NO

+ (nonnull instancetype)cmd;

@end
