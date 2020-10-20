//
//  HCCountdown.h
//  HCCountdown
//
//  Created by 微微笑了 on 2017/10/13.
//  Copyright © 2017年 微微笑了. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//通过RGB返回UIColor
#ifndef RGB
#define RGB(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#endif

#define SCREEN [UIScreen mainScreen]
#define WIDTH   self.view.frame.size.width
#define HEIGHT  self.view.frame.size.height

#define textFontWeightSize(X,W) [UIFont systemFontOfSize:X *([UIScreen mainScreen].bounds.size.width / 320.0) weight:W]


@interface HCCountdown : NSObject

/**
 * 获取当前时间  格式 yyyy-MM-dd hh:mm:ss
 */

- (NSString *) getNowTimeString;


/**
 * 时间转时间戳
 */

- (long) timeStampWithDate:(NSDate *) timeDate;

/**
 * 时间戳转时间
 */

- (NSString *) dateWithTimeStamp:(long) longValue;

/**
 * 用时间戳倒计时
 * starTimeStamp 开始的时间戳
 * finishTimeStamp 结束的时间戳
 */
-(void)countDownWithStratTimeStamp:(long)starTimeStamp finishTimeStamp:(long)finishTimeStamp completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;


/**
 * 每秒走一次，回调block
 */
-(void)countDownWithPER_SECBlock:(void (^)())PER_SECBlock;

/**
 * 销毁倒计时
 */
-(void)destoryTimer;



@end
