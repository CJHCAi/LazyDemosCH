//
//  CFDayEntity.h
//  CFCalendar
//
//  Created by MountainCao on 2017/8/22.
//  Copyright © 2017年 深圳中业兴融互联网金融服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFDayEntity : NSObject
/** 当前天所在的年份 */
@property (nonatomic, assign) NSInteger year;
/** 当前天所在的月份 */
@property (nonatomic, assign) NSInteger month;
/** 天 */
@property (nonatomic, assign) NSInteger day;
/** 当前周几 */
@property (nonatomic, assign) NSInteger week;
/** 是否是当月的天 */
@property (nonatomic, assign) BOOL currentMonthDay;
/** 是否是当月的天 */
@property (nonatomic, assign) BOOL currentDay;
/** 被选中的天 */
@property (nonatomic, assign) BOOL selectedDay;

@end
