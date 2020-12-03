//
//  CFMonthEntity.h
//  CFCalendar
//
//  Created by MountainCao on 2017/8/22.
//  Copyright © 2017年 深圳中业兴融互联网金融服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFMonthEntity : NSObject
/** 当前月份所在的年份 */
@property (nonatomic, assign) NSInteger year;
/** 当前月份 */
@property (nonatomic, assign) NSInteger month;
/** 当前月的天数 */
@property (nonatomic, assign) NSInteger daysSum;

@end
