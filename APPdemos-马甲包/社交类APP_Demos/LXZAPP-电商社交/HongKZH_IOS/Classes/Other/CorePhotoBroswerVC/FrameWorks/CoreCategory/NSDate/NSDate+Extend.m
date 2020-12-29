//
//  NSDate+Extend.m
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "NSDate+Extend.h"

@interface NSDate ()


/*
 *  清空时分秒，保留年月日
 */
@property (nonatomic,strong,readonly) NSDate *ymdDate;


@end




@implementation NSDate (Extend)


+(void)getdifferenceWithTime:(NSInteger)timeS back:(void(^)(NSString*hour,NSString*minute,NSString*second))timeStr{
    if (timeS>0) {
        NSInteger hour = timeS/3600;
        NSInteger m = (timeS - hour*3600)/60;
        NSInteger s = timeS - hour*3600-m*60;
        NSString*H;
        if (hour>9) {
            H = [NSString stringWithFormat:@"%ld",hour];
        }else{
            H = [NSString stringWithFormat:@"0%ld",hour];
        }
        NSString*Mi;
        if (m>9) {
            Mi = [NSString stringWithFormat:@"%ld",m];
        }else{
            Mi = [NSString stringWithFormat:@"0%ld",m];
        }
        NSString*se;
        if (s>9) {
            se = [NSString stringWithFormat:@"%ld",s];
        }else{
            se = [NSString stringWithFormat:@"0%ld",s];
        }
        timeStr(H,Mi,se);
    }else{
        timeStr(@"00",@"00",@"00");
    }
    
}


/*
 *  时间戳
 */
-(NSString *)timestamp{

    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f",timeInterval];
    
    return [timeString copy];
}





/*
 *  时间成分
 */
-(NSDateComponents *)components{
    
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //定义成分
    NSCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    return [calendar components:unit fromDate:self];
}





/*
 *  是否是今年
 */
-(BOOL)isThisYear{
    
    //取出给定时间的components
    NSDateComponents *dateComponents=self.components;
    
    //取出当前时间的components
    NSDateComponents *nowComponents=[NSDate date].components;
    
    //直接对比年成分是否一致即可
    BOOL res = dateComponents.year==nowComponents.year;
    
    return res;
}





/*
 *  是否是今天
 */
-(BOOL)isToday{

    //差值为0天
    return [self calWithValue:0];
}





/*
 *  是否是昨天
 */
-(BOOL)isYesToday{
    
    //差值为1天
    return [self calWithValue:1];
}


-(BOOL)calWithValue:(NSInteger)value{
    
    //得到给定时间的处理后的时间的components
    NSDateComponents *dateComponents=self.ymdDate.components;
    
    //得到当前时间的处理后的时间的components
    NSDateComponents *nowComponents=[NSDate date].ymdDate.components;
    
    //比较
    BOOL res=dateComponents.year==nowComponents.year && dateComponents.month==nowComponents.month && (dateComponents.day + value)==nowComponents.day;
    
    return res;
}



/*
 *  清空时分秒，保留年月日
 */
-(NSDate *)ymdDate{
    
    //定义fmt
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    
    //设置格式:去除时分秒
    fmt.dateFormat=@"yyyy-MM-dd";
    
    //得到字符串格式的时间
    NSString *dateString=[fmt stringFromDate:self];
    
    //再转为date
    NSDate *date=[fmt dateFromString:dateString];
    
    return date;
}












/**
 *  两个时间比较
 *
 *  @param unit     成分单元
 *  @param fromDate 起点时间
 *  @param toDate   终点时间
 *
 *  @return 时间成分对象
 */
+(NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //直接计算
    NSDateComponents *components = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    
    return components;
}


+(NSInteger)dateTimestampWithTimeString:(NSString*)time separatedByString:(NSString*)separatedByString{
    NSInteger timestamp = 0;
    NSArray* timeArray = [time componentsSeparatedByString:separatedByString];
    if (timeArray.count == 3) {
        timestamp = [timeArray.firstObject integerValue]*60*60+[timeArray.lastObject integerValue]+[timeArray[1] integerValue]*60;
    }else if (timeArray.count == 2){
        timestamp = [timeArray.firstObject integerValue]*60+[timeArray.lastObject integerValue];
    }else if (timeArray.count == 1){
        timestamp = [timeArray.firstObject integerValue];
    }
    return timestamp;
}






























@end
