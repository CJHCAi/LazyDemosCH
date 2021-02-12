/*
 * AlibcTradeTrackService.h 
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


/** 内容曝光 */
extern NSString * const AlibcTradeEventId_Exposure ;
/** 内容点击 */
extern NSString * const AlibcTradeEventId_ContentClick;


@interface AlibcTrackParams : NSObject
/**必填: 供计算效果用，由推荐模块输出内容后，曝光埋点使用 */
@property (nonatomic,strong)NSString* scm;
/**必填: 供计算效果用，由推荐模块输出内容后，曝光埋点使用 */
@property (nonatomic,strong)NSString* pvid;
/**必填: 三方app的用户识别id，用于百川识别该用户行为并对推荐效果进行优化 */
@property (nonatomic,strong)NSString* puid;
/** 三方app页面名称*/
@property (nonatomic,strong)NSString* page;
/** 三方app控件名称 */
@property (nonatomic,strong)NSString* label;


/**
 *  生成Dictionary
 */
- (NSDictionary*)toDictionary;
@end


@interface AlibcTradeTrackService : NSObject

/**
 *  isv添加自定义ut打点..
 *
 *  @param eventId 事件名,系统自带事件名,见最上面的几个常量字符串
 *  @param Params 埋点参数
 */
+ (void)addTraceLog:(NSString*)eventId param:(AlibcTrackParams *)params;

@end
