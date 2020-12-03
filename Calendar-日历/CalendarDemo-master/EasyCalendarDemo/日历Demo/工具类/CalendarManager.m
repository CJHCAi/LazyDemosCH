//
//  CalendarManager.m
//  QianBuXian_V2
//
//  Created by YangTianCi on 2018/4/4.
//  Copyright © 2018年 qbx. All rights reserved.
//

#import "CalendarManager.h"

#define Month_1_3_5_7_8_10_12 31
#define Month_2 2928/4
#define Month_4_6_9_11 30

@interface CalendarManager()

@property (nonatomic, assign) NSInteger current_year;
@property (nonatomic, assign) NSInteger lastMonth_year;
@property (nonatomic, assign) NSInteger nextMonth_year;

@property (nonatomic, assign) NSInteger demoCount;

@end

@implementation CalendarManager

-(NSArray*)CaculateCurrentMonthWithString:(NSString*)string{
    
    //例: string == 2018年03月
    
    //获取当前年份以及月份
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"yyyy年MM月";
    
    NSString *yearString = [string substringWithRange:NSMakeRange(0, 4)];
    
    NSString *monthString = [string substringWithRange:NSMakeRange(5, 2)];
    NSInteger yearNumber = [yearString integerValue];
    NSInteger monthNumebr = [monthString integerValue];
    
    
    self.current_year = yearNumber;
    
    NSInteger last_month = monthNumebr - 1;
    if (monthNumebr == 1) {
        last_month = 12;
        self.lastMonth_year = self.current_year - 1;
    }else{
        self.lastMonth_year = self.current_year;
    }
    
    NSString *lastMonth_key = [NSString stringWithFormat:@"%zd%zd",self.lastMonth_year,last_month];
    
    NSInteger current_month = monthNumebr;
    NSString *currentMonth_key = [NSString stringWithFormat:@"%zd%zd",_current_year,current_month];
    
    NSInteger next_month = monthNumebr + 1;
    if (monthNumebr == 12) {
        next_month = 1;
        self.nextMonth_year = self.current_year + 1;
    }else{
        self.nextMonth_year = self.current_year;
    }
    NSString *nextMonth_key = [NSString stringWithFormat:@"%zd%zd",self.nextMonth_year,next_month];
    
    //缓存结构
    
    CalenderObject *lastMonth;
    if (![[self.cacheData allKeys] containsObject:lastMonth_key]) {
        lastMonth = [self GetMonthDataWithMonth:last_month Year:self.lastMonth_year];
        [self.cacheData setObject:lastMonth forKey:lastMonth_key];
    }else{
        lastMonth = self.cacheData[lastMonth_key];
    }
    
    CalenderObject *currentMonth;
    if (![[self.cacheData allKeys] containsObject:currentMonth_key]) {
        currentMonth = [self GetMonthDataWithMonth:current_month Year:self.current_year];
        [self.cacheData setObject:currentMonth forKey:currentMonth_key];
    }else{
        currentMonth = self.cacheData[currentMonth_key];
    }
    
    CalenderObject *nextMonth;
    if (![[self.cacheData allKeys] containsObject:nextMonth_key]) {
        nextMonth = [self GetMonthDataWithMonth:next_month Year:self.nextMonth_year];
        [self.cacheData setObject:nextMonth forKey:nextMonth_key];
    }else{
        nextMonth = self.cacheData[nextMonth_key];
    }
    
    //缺少缓存智能删除功能_等待添加_具体可以使用
    NSArray *resultArray = @[lastMonth, currentMonth, nextMonth];
    
    return resultArray;
}

#pragma mark ===== 主体函数, 给定月份返回当月具体数据
-(CalenderObject*)GetMonthDataWithMonth:(NSInteger)month Year:(NSInteger)year{
    
    NSLog(@"计算次数 >>>>>>>>>>> %zd",_demoCount++);
    
    //先计算当前月份第一天为周几 --- begin
    NSString *firstDay_string = [NSString stringWithFormat:@"%04zd-%02zd-01",year,month];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *firstDay_date = [formatter dateFromString:firstDay_string];
    NSInteger weekDay = [self WeekMethodWithDate:firstDay_date];
    //获取到当前月份第一天为周几 ---> end
    
    CalenderObject *BigObject = [[CalenderObject alloc]init];
    //标题
    BigObject.title = [NSString stringWithFormat:@"%zd年%zd月",year,month];
    //数据时间
    BigObject.yearInt = year;
    BigObject.monthInt = month;
    
    //天数合计--->只含当月
    NSInteger totalDayCPure = [self monthDayCountWithMonth:month Year:year];
    BigObject.totalDayCount = totalDayCPure;
    
    //上月为多少天--->多余天数
    NSInteger lastMonth;
    NSInteger lastMonth_Year = year;
    if (month == 1) {
        lastMonth = 12;
        lastMonth_Year --;
    }else{
        lastMonth = month - 1;
    }
    NSInteger lastMonthCount = [self monthDayCountWithMonth:lastMonth Year:year];
    NSInteger lastMonthRemain;
    switch (weekDay) {
        case 1:
            lastMonthRemain = 0;
            break;
        case 2:
            lastMonthRemain = 1;
            break;
        case 3:
            lastMonthRemain = 2;
            break;
        case 4:
            lastMonthRemain = 3;
            break;
        case 5:
            lastMonthRemain = 4;
            break;
        case 6:
            lastMonthRemain = 5;
            break;
        case 7:
            lastMonthRemain = 6;
            break;
        default:
            lastMonthRemain = 0;
            break;
    }
    
    BigObject.lastMonthCount = lastMonthRemain;
    NSMutableArray *lastMonthDayArray = [NSMutableArray array];
    if (lastMonthRemain == 0) {
        lastMonthDayArray = nil;
    }else{
        for (NSInteger i = lastMonthCount - lastMonthRemain + 1; i <= lastMonthCount; i++) {
            [lastMonthDayArray addObject:@(i)];
        }
    }
    
    //下月为多少天--->多余天数
    NSInteger nextMonth;
    NSInteger nextMonth_Year = year;
    if (month == 12) {
        nextMonth = 1;
        nextMonth_Year ++;
    }else{
        nextMonth = month + 1;
    }
    
    NSString *dateString = [NSString stringWithFormat:@"%04zd-%02zd-%02zd",year,month,totalDayCPure];
    NSDateFormatter *formatter_last = [[NSDateFormatter alloc]init];
    formatter_last.dateFormat = @"yyyy-MM-dd";
    NSDate *lastDayDate = [formatter_last dateFromString:dateString];
    NSInteger lastDayWeek = [self WeekMethodWithDate:lastDayDate];
    
    NSInteger nextMonthRemain;
    switch (lastDayWeek) {
        case 1:
            nextMonthRemain = 6;
            break;
        case 2:
            nextMonthRemain = 5;
            break;
        case 3:
            nextMonthRemain = 4;
            break;
        case 4:
            nextMonthRemain = 3;
            break;
        case 5:
            nextMonthRemain = 2;
            break;
        case 6:
            nextMonthRemain = 1;
            break;
        case 7:
            nextMonthRemain = 0;
            break;
        default:
            nextMonthRemain = 0;
            break;
    }
    
    BigObject.nextMonthCount = nextMonthRemain;
    NSMutableArray *nextMonthDayArray = [NSMutableArray array];
    if (nextMonthRemain == 0) {
        nextMonthDayArray = nil;
    }else{
        for (int i = 1; i <= nextMonthRemain; i++) {
            [nextMonthDayArray addObject:@(i)];
        }
    }
    
    //天数合计--->含其他月
    BigObject.totalDayCountAll = BigObject.totalDayCount + BigObject.lastMonthCount + BigObject.nextMonthCount;
    
    //第一天为周几
    BigObject.weekName = weekDay;
    
    //需要多少行 ---> 实际上一定会是 7 的倍数
    NSInteger remainderNumber = BigObject.totalDayCountAll%7;
    NSInteger orginalRow = BigObject.totalDayCountAll/7;
    NSInteger Row = remainderNumber == 0 ? orginalRow : orginalRow ++;
    BigObject.RowCount = Row;
    
    //当前月份的所有日期对象数组
    NSMutableArray *totalDayObjectArray = [NSMutableArray array];
    
    // >>> 上月
    for (NSNumber *number in lastMonthDayArray) {
        NSInteger dayInt = [number integerValue];
        CalenderObject *object = [[CalenderObject alloc]init];
        object.DayNumber = dayInt;
        object.DayString = [NSString stringWithFormat:@"%zd",dayInt];
        object.isCurrentMonth = NO;
        object.isLastMonth = YES;
        object.yearInt = lastMonth_Year;
        object.monthInt = lastMonth;
        object.dayInt = dayInt;
        //事件属性需要数据配合添加
        [totalDayObjectArray addObject:object];
    }
    
    // >>> 本月
    for (int i = 1; i <= BigObject.totalDayCount; i++) {
        CalenderObject *object = [[CalenderObject alloc]init];
        object.DayNumber = i;
        object.DayString = [NSString stringWithFormat:@"%zd",i];
        object.isCurrentMonth = YES;
        object.yearInt = year;
        object.monthInt = month;
        object.dayInt = i;
        //事件属性需要数据配合添加
        [totalDayObjectArray addObject:object];
    }
    
    // >>> 下月
    for (NSNumber *number in nextMonthDayArray) {
        NSInteger dayInt = [number integerValue];
        CalenderObject *object = [[CalenderObject alloc]init];
        object.DayNumber = dayInt;
        object.DayString = [NSString stringWithFormat:@"%zd",dayInt];
        object.isCurrentMonth = NO;
        object.isLastMonth = NO;
        object.yearInt = nextMonth_Year;
        object.monthInt = nextMonth;
        object.dayInt = dayInt;
        //事件属性需要数据配合添加
        [totalDayObjectArray addObject:object];
    }
    BigObject.DayArray = totalDayObjectArray;
    
    //到此为止, 已经配置了给定月份的所有日期

    return BigObject;
}


#pragma mark ----- 计算当前月份为多少天
-(NSInteger)monthDayCountWithMonth:(NSInteger)month Year:(NSInteger)year{
    NSInteger totalDayCPure = 0;
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 ) {
        totalDayCPure = Month_1_3_5_7_8_10_12;//31
    }else if (month == 4 || month == 6 || month == 9 || month == 11 ){
        totalDayCPure = Month_4_6_9_11;//30
    }else if (month == 2){
        BOOL is_leapyear;
        if (self.current_year%4 != 0) {
            is_leapyear = NO;//28
        }else{
            is_leapyear = YES;//29
        }
        
        if (is_leapyear) {
            totalDayCPure = 29;
        }else{
            totalDayCPure = 28;
        }
    }
    return totalDayCPure;
}

#pragma mark ----- 根据日期计算当前日期为星期几
-(NSInteger)WeekMethodWithDate:(NSDate*)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    //2016-01-22为星期五，因为美国的第一天是从星期天开始算，所以换算到我们中国的星期需要减1
    return theComponents.weekday;
    
}

-(NSMutableDictionary *)cacheData{
    if (!_cacheData) {
        _cacheData = [NSMutableDictionary dictionary];
    }
    return _cacheData;
}




@end
