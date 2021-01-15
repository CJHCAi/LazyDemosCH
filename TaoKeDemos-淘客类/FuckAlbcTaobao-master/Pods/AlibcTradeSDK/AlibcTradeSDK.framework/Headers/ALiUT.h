/*
 * ALiUT.h 
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

#define ALiTRADE_TRACE_TRACKER_ID @"aliTradesdk"

typedef NSString ALiUTEventID;
@class UIWebView;
@class UIViewController;

/*
 * @brief 用于透出事件埋点
 */
FOUNDATION_EXTERN ALiUTEventID * const ALiUTEventID$2201;

/*
 * @brief 用于点击事件埋点
 */
FOUNDATION_EXTERN ALiUTEventID * const ALiUTEventID$2101;

FOUNDATION_EXTERN NSString * const ALiUTArgsKeyYBHPSS;

FOUNDATION_EXTERN NSString * const ALiUTArgsKeyYBHPSS_LABEL;

@interface ALiUT : NSObject

+ (void)initUT;

+ (BOOL)isThird; //是否三方ut

+ (void)addTraceLog:(NSString *)page
              label:(NSString *)label
           interval:(NSInteger)interval
          propertys:(NSDictionary *)propertyDict;

+ (void)addTraceLog:(NSString *)label propertys:(NSDictionary *)propertyDict;

+ (void)addTraceLog:(NSString *)label;

+ (void)addTradeLogWithEventID:(ALiUTEventID *)eventID arg1:(NSString *)arg1 args:(NSDictionary *)args;

+ (void)addTrack4DAU;

+ (NSString *)ybhpssStringForDictionary:(NSDictionary *)params;

//供jsbridge打点
+ (BOOL) h5UT:(NSDictionary *) dataDict view:(UIWebView *) pView viewController:(UIViewController *) pViewController;

@end
