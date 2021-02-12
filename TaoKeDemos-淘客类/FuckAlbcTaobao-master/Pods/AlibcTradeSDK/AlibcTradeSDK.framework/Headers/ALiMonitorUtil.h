/*
 * ALiMonitorUtil.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeSDK 
 * 版本号：3.1.1.5
 * 发布时间：2016-10-14
 * 开发团队：阿里巴巴百川商业化团队
 * 阿里巴巴电商SDK答疑群号：1229144682(阿里旺旺)
 * Copyright (c) 2016-2019 阿里巴巴-移动事业群-百川. All rights reserved.
 */

#ifndef ALiMonitorUtil_h
#define ALiMonitorUtil_h


#endif /* ALiMonitorUtil_h */

#import "ALiMonitor.h"

@interface ALiMonitorUtil : NSObject

+ (instancetype)shareInstance ;

/**
 * 注册性能监控点
 @param ponit 监控点，例：@"init"
 @param moudle 模块名，例：@"BCTradeSDK"
 @param measureSet 指标集合，例：@"securityInitTime"
 @param dimensionSet 维度集合，例：[@"appkey" @"clientVersion" @"sdkVersion" @"platform"]
 */
-(void)registMonitorPoint:(ALiMonitor*)monitor;



/**
 *  记录业务操作成功接口
 *
 *  @param module   模块名称,安卓iOS要相同. 命名规范:若之前埋点有页面名,则用原来的; 否则用"业务名_页面名"(无页面则"业务名"); 采用首字母大写驼峰方式. 如Shop_Detail, Shop_List
 *  @param monitorPoint 监控点名称,安卓iOS要相同,从@雷曼 获取
 *  @arg 附加参数，用于做横向扩展
 */
- (void)commitSuccessWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint arg:(NSString *)arg;

/**
 *  记录业务操作失败接口
 *
 *  @param module   模块名称,安卓iOS要相同. 命名规范:若之前埋点有页面名,则用原来的; 否则用"业务名_页面名"(无页面则"业务名"); 采用首字母大写驼峰方式. 如Shop_Detail, Shop_List
 *  @param monitorPoint 监控点名称,安卓iOS要相同,从@雷曼 获取
 *  @param errorCode 错误码，若为MTOP请求则传MTOP的错误码,否则请业务方对错误进行分类编码,方便统计错误类型占比
 *  @param errorMsg  错误信息，若位MTOP请求则传MTOP的错误信息, 否则请业务方自己描述错误, 方便自己查找原因
 *  @arg 附加参数，用于做横向扩展
 */
- (void)commitFailWithModule:(NSString *)module monitorPoint:(NSString *)monitorPoint errorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg arg:(NSString *)arg;


/**
 * 提交多维度，多指标
 * @param module 监控模块
 * @param monitorPoint 监控点名称
 * @param dimensionValues key:维度名 value：值
 * @param measureValues key:指标名 value：值
 */
-(void)commitWithMonitor:(ALiMonitor*)monitor;

/**
 * 开始监控
 * @param key，计算时间的标示符，不能重复
 * @return 是否加入监控，key重复，会覆盖
 */
-(BOOL)beginTimeMonitor:(NSString*)key;

/**
 * 结束监控，清楚监控key
 * @param key，计算时间的标示符，必须有begin，否则返回0
 * @return 返回耗时，毫秒数
 */
-(NSString*)endTimeMonitor:(NSString*)key;

/**
 * 清除所有监控key
 */
-(void)clearAllTimeMonitor;

/**
 * 清除指定监控key
 */
-(void)clearTimeMonitor:(NSString*)key;

@end