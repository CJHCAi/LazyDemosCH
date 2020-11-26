//
//  HCCountdown.m
//  HCCountdown
//
//  Created by 微微笑了 on 2017/10/13.
//  Copyright © 2017年 微微笑了. All rights reserved.
//

#import "HCCountdown.h"

@interface HCCountdown ()
@property(nonatomic,retain) dispatch_source_t timer;
@property(nonatomic,retain) NSDateFormatter *dateFormatter;

@end

@implementation HCCountdown

/**用时间戳倒计时*/
-(void)countDownWithStratTimeStamp:(long)starTimeStamp finishTimeStamp:(long)finishTimeStamp completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock{
    if (_timer==nil) {
        
        NSDate *finishDate = [self dateWithLong:finishTimeStamp]; //时间戳转时间
        NSDate *startDate  = [self dateWithLong:starTimeStamp];
        NSTimeInterval timeInterval =[finishDate timeIntervalSinceDate:startDate]; //获取两个时间的间隔时间段
        __block int timeout = timeInterval; //倒计时时间
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(0,0,0,0);
                    });
                }else{
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(days,hours,minute,second);
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

-(void)countDownWithPER_SECBlock:(void (^)())PER_SECBlock{
    if (_timer==nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                PER_SECBlock();
            });
        });
        dispatch_resume(_timer);
    }
}


-(NSDate *)dateWithLong:(long)longValue{
    long value = longValue;
    NSNumber *time = [NSNumber numberWithLong:value];
    //转换成NSTimeInterval
    NSTimeInterval nsTimeInterval = [time longValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    return date;
}

/**获取当前时间  格式 yyyy-MM-dd hh:mm:ss*/
- (NSString *) getNowTimeString {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
    
}

/**时间转时间戳*/
- (long)timeStampWithDate:(NSDate *)timeDate {
    
    long timeStamp = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeString = [formatter stringFromDate:timeDate];
    NSDate *date = [formatter dateFromString:timeString];
    timeStamp = (long)[date timeIntervalSince1970];
    
    return timeStamp;
}
/**时间戳转时间*/
- (NSString *)dateWithTimeStamp:(long)longValue {
    
    long value = longValue;
    
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSNumber *time = [NSNumber numberWithLong:value];
    //转换成NSTimeInterval
    NSTimeInterval nsTimeInterval = [time longValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    NSString *dayStr = [formatDay stringFromDate:date];

    return dayStr;
}


/**
 *  销毁定时器
 */
-(void)destoryTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

-(void)dealloc{
    NSLog(@"%s dealloc",object_getClassName(self));
    
}



@end
