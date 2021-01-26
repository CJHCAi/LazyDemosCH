//
//  CJUseTime.m
//  CJCalendar
//
//  Created by chjsun on 16/5/26.
//  Copyright © 2016年 chjsun. All rights reserved.
//

#import "CJUseTime.h"

@interface CJUseTime()

/** 公历 */
@property (nonatomic, strong) NSCalendar *gregorianCalendar;
/** 农历 */
@property (nonatomic, strong) NSCalendar *chineseCalendar;
/** 格式化 date <--> string */
@property (nonatomic, strong) NSDateFormatter *formatter;

/** 农历年 */
@property (nonatomic, strong) NSArray *chineseYears;
/** 农历月 */
@property (nonatomic, strong) NSArray *chineseMonths;
/** 农历日 */
@property (nonatomic, strong) NSArray *chineseDays;
/** 星期 */
@property (nonatomic, strong) NSArray *chineseWeekDays;
@end

@implementation CJUseTime

static CJUseTime * _sharedInstance = nil;

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (!_sharedInstance) {
        _sharedInstance = [super allocWithZone:zone];
        
        return _sharedInstance;
    }
    
    return nil;
}

+ (CJUseTime *)sharedInstance {
    // 单例模式
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[CJUseTime alloc] init];
    });
    
    return _sharedInstance;
}


-(NSCalendar *)gregorianCalendar{
    if (!_gregorianCalendar) {
        _gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [_gregorianCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [_gregorianCalendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    }
    return _gregorianCalendar;
}


-(NSCalendar *)chineseCalendar{
    if (!_chineseCalendar) {
        _chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        [_chineseCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [_chineseCalendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    }
    return _chineseCalendar;
}

-(NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [_formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    }
    return _formatter;
}

//农历年数据，加载一次足矣
-(NSArray *)chineseYears{
    if (!_chineseYears) {
        _chineseYears = [NSArray arrayWithObjects:
                                 @"甲子鼠年", @"乙丑牛年", @"丙寅虎年", @"丁卯兔年",  @"戊辰龙年",  @"己巳蛇年",  @"庚午马年",  @"辛未羊年",  @"壬申猴年",  @"癸酉鸡年",
                                 @"甲戌狗年",   @"乙亥猪年",  @"丙子鼠年",  @"丁丑牛年", @"戊寅虎年",   @"己卯兔年",  @"庚辰龙年",  @"辛己蛇年",  @"壬午马年",  @"癸未羊年",
                                 @"甲申猴年",   @"乙酉鸡年",  @"丙戌狗年",  @"丁亥猪年",  @"戊子鼠年",  @"己丑牛年",  @"庚寅虎年",  @"辛卯兔年",  @"壬辰龙年",  @"癸巳蛇年",
                                 @"甲午马年",   @"乙未羊年",  @"丙申猴年",  @"丁酉鸡年",  @"戊戌狗年",  @"己亥猪年",  @"庚子鼠年",  @"辛丑牛年",  @"壬寅虎年",  @"癸卯兔年",
                                 @"甲辰龙年",   @"乙巳蛇年",  @"丙午马年",  @"丁未羊年",  @"戊申猴年",  @"己酉鸡年",  @"庚戌狗年",  @"辛亥猪年",  @"壬子鼠年",  @"癸丑牛年",
                                 @"甲寅虎年",   @"乙卯兔年",  @"丙辰龙年",  @"丁巳蛇年",  @"戊午马年",  @"己未羊年",  @"庚申猴年",  @"辛酉鸡年",  @"壬戌狗年",  @"癸亥猪年", nil];
    }
    return _chineseYears;
}
//农历月数据，加载一次足矣
-(NSArray *)chineseMonths{
    if (!_chineseMonths) {
        _chineseMonths = [NSArray arrayWithObjects:
                                 @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                                  @"九月", @"十月", @"冬月", @"腊月", nil];

    }
    return _chineseMonths;
}
//农历日数据，加载一次足矣
-(NSArray *)chineseDays{
    if (!_chineseDays) {
        _chineseDays = [NSArray arrayWithObjects:
                                @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                                @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                                @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    }
    return _chineseDays;
}
//星期数据，加载一次足矣
-(NSArray *)chineseWeekDays{
    if (!_chineseWeekDays) {
        _chineseWeekDays = [NSArray arrayWithObjects:
                                    @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    }
    return _chineseWeekDays;
}

/**
 *  根据给定字符串返回字符串代表月的天数
 *
 *  @param dateStr @"xxxx-xx-xx"
 *
 *  @return 28 or 29 or 30 or 31
 */
-(NSInteger) timeNumberOfDaysInString:(NSString *)dateStr{
    NSDate *date = [self strToDate:dateStr];
    return [self timeNumberOfDaysInDate:date];
}


//获取给定日期所在月有多少天
- (NSInteger)timeNumberOfDaysInDate:(NSDate *)date
{
    // 只要个时间给日历,就会帮你计算出来。这里的时间取当前的时间。
    NSRange range = [self.gregorianCalendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:date];
    return range.length;
}

-(NSInteger) timeMonthWeekDayOfFirstDay:(NSString *)dateStr{
    NSDate *date = [self strToDate:dateStr];
    return [self getDateInfo:date];
    
}

//获取给定日期的详细信息，可以得到是周几
- (NSInteger) getDateInfo:(NSDate *)date
{
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comps = [self.gregorianCalendar components:NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday fromDate:date];

    // weekday 1 是周日，2是周一 3.以此类推
    return comps.weekday - 1;
}

// 字符串转日期
- (NSDate *) strToDate:(NSString *)dateStr
{
    [self.formatter setDateFormat:@"yyyy-MM-dd"]; // 年-月-日 时:分:秒
    // 这个格式可以随便定义,比如：@"yyyy,MM,dd,HH,mm,ss"
    return [self.formatter dateFromString:dateStr];
}

// 日期转字符串
- (NSString *) dataToString:(NSDate *)date
{
    [self.formatter setDateFormat:@"yyyy-MM-dd"]; // 年-月-日 时:分:秒
    // 这个格式可以随便定义,比如：@"yyyy,MM,dd,HH,mm,ss"
    return [self.formatter stringFromDate:date];
}

//获得一个月“占”几个星期
-(NSInteger)timeFewWeekInMonth:(NSString *)dateStr{
    
    NSDate *date = [self strToDate:dateStr];
    //一个月多少天
    NSInteger dayNumber = [self timeNumberOfDaysInDate:date];
    
    NSInteger weekday = [self getDateInfo:date];
    
    NSInteger weeks = 0;
    
    if (weekday) {
        weeks += 1;
        dayNumber -= (7-weekday);
    }
    weeks += dayNumber/7;
    weeks += dayNumber % 7? 1: 0;

    return weeks;
    
}

// 农历－－获取给定日期的详细信息，可以得到是几号
- (NSInteger) timeDateOfDay:(NSString *)dateStr{
    NSDate *date = [self strToDate:dateStr];
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comps = [self.chineseCalendar components:NSCalendarUnitDay fromDate:date];
    
    // weekOfMonth 本日处在第几周，不足一周按一周算，最大是6周
    return comps.day;
}

/**
 *  根据给定字符串返回字符串代表的农历的日期
 *
 *  @param dateStr @"xxxx-xx-xx"
 *
 *  @return 丙寅虎年 四月廿四 星期三
 */
- (NSString *) timeChineseCalendarWithString:(NSString *)dateStr{
    NSDate *date = [self strToDate:dateStr];
    return [self timeChineseCalendarWithDate:date];
    
}
// get Chinese calendar
- (NSString *) timeChineseCalendarWithDate:(NSDate *)date{
    
    NSInteger dayOfWeek  =[self getDateInfo:date];
    

    NSDateComponents *localeComp = [self.chineseCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:date];
    
    NSString *y_str = [self.chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [self.chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [self.chineseDays objectAtIndex:(localeComp.day==0? 29: localeComp.day-1)];
    NSString *dw_str = [self.chineseWeekDays objectAtIndex:dayOfWeek];
    
    return [NSString stringWithFormat:@"%@ %@%@ %@", y_str, m_str, d_str, dw_str];
}

/**
 *  根据给定字符串返回字符串代表的农历的日
 *
 *  @param dateStr @"xxxx-xx-xx"
 *
 *  @return 1～30
 */

-(NSString *)timeChineseDaysWithDate:(NSString *)dateStr{
    NSDate *date = [self strToDate:dateStr];
    return [self getChineseWeekDaysWithDate:date];
}

// get chinese day
-(NSString *)getChineseWeekDaysWithDate:(NSDate *)date{
    
    NSDateComponents *localeComp = [self.chineseCalendar components: NSCalendarUnitDay fromDate:date];
    
    return [self.chineseDays objectAtIndex:(localeComp.day==0? 29: localeComp.day-1)];
}




@end
