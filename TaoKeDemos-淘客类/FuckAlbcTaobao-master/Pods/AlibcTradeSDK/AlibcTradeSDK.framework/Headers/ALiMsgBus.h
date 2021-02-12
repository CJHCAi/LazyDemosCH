/*
 * ALiMsgBus.h 
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

typedef NS_ENUM(NSInteger, MsgBusItemType) {
    MsgBusItemTypeFilter,  //过滤器
    MsgBusItemTypeTop, //top监听,首先被串行通知,通知完后才通知normal
    MsgBusItemTypeNormal  //普通监听,并发通知
};


@interface ALiMsgBus : NSObject
+(instancetype)sharedInstance;
- (void) registerNotify:(NSString*)eventID target:(NSObject*)target action:(SEL) action dataType:(Class)dataType mainThread:(BOOL)bMain type:(MsgBusItemType)type;

- (void) registerNotify:(NSString*)eventID target:(NSObject*)target action:(SEL) action dataType:(Class)dataType1  dataType:(Class)dataType2 mainThread:(BOOL)bMain  type:(MsgBusItemType)type;

- (void) registerNotify:(NSString*)eventID target:(NSObject*)target action:(SEL) action dataType:(Class)dataType1  dataType:(Class)dataType2 dataType:(Class)dataType3 mainThread:(BOOL)bMain  type:(MsgBusItemType)type;


- (void) unregisterEventNotifyByTarget:(NSString*)eventID target:(NSObject*)target;
- (BOOL) fireEventNotify:(NSString*)eventID data:(id) data;
- (BOOL) fireEventNotify:(NSString*)eventID data1:(id) data1 data2:(id) data2;
- (BOOL) fireEventNotify:(NSString*)eventID data1:(id) data1 data2:(id) data2 data3:(id) data3;

@end
