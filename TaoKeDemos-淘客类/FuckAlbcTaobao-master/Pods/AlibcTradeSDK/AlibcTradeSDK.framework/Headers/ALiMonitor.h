/*
 * ALiMonitor.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeSDK 
 * 版本号：3.1.1.5
 * 发布时间：2016-10-14
 * 开发团队：阿里巴巴百川商业化团队
 * 阿里巴巴电商SDK答疑群号：1229144682(阿里旺旺)
 * Copyright (c) 2016-2019 阿里巴巴-移动事业群-百川. All rights reserved.
 */

#ifndef ALiMonitor_h
#define ALiMonitor_h


#endif /* ALiMonitor_h */

#define MONITOR_MODULE @"BCTradeSDK"

@interface ALiMonitor : NSObject

//获取监控点标示符，子类请重载
-(NSString*)monitorModule;
//获取监控点标示符，子类请重载
-(NSString*)monitorPoint;

//构建维度，提交数据用，key：维度名；value：维度值
-(void)makeDimension:(NSMutableDictionary*)dimensionDic;
//构建指标，提交数据用，key：指标名；value：指标值
-(void)makeMeasure:(NSMutableDictionary*)measureDic;

-(void)commit;


//维度名称
@property(nonatomic,strong) NSString *dimension_appkey;
@property(nonatomic,strong) NSString *dimension_isv_version;
@property(nonatomic,strong) NSString *dimension_nbsdk_version;
@property(nonatomic,strong) NSString *dimension_platform;
//维度值
@property(nonatomic,strong) NSString *appkey;
@property(nonatomic,strong) NSString *isv_version;
@property(nonatomic,strong) NSString *nbsdk_version;
@property(nonatomic,strong) NSString *platform;//iOS|android
@end