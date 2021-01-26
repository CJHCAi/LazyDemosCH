//
//  LTSCalendarDayView.m
//  LTSCalendar
//
//  Created by leetangsong_macbk on 16/5/24.
//  Copyright © 2016年 leetangsong. All rights reserved.
//

#import "LTSCalendarDayView.h"
#import "LTSCircleView.h"
#import "LTSCalendarManager.h"
@interface LTSCalendarDayView(){
    UIView *backgroundView;
    LTSCircleView *circleView;
    UILabel *textLabel;
    UILabel *lunarTextLabel;
    LTSCircleView *dotView;
    
    BOOL isSelected;
    
    int isToday;
    NSString *cacheCurrentDateText;
 
}

@end

static NSString *const kLTSCalendarDaySelected = @"kLTSCalendarDaySelected";
@implementation LTSCalendarDayView

- (instancetype)init
{
   
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)commonInit{
    isSelected = NO;
    self.isOtherMonth = NO;
    
    backgroundView = [UIView new];
    [self addSubview:backgroundView];
    
    circleView = [LTSCircleView new];
    [self addSubview:circleView];
    circleView.color = [UIColor clearColor];

    textLabel = [UILabel new];
    textLabel.font = [UIFont systemFontOfSize:18];
    
    
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];

    lunarTextLabel = [UILabel new];
    lunarTextLabel.font = [UIFont systemFontOfSize:12];
    lunarTextLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lunarTextLabel];
    
    dotView = [LTSCircleView new];
    [self addSubview:dotView];
    dotView.hidden = YES;
    
    //添加点击事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:gesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDaySelected:) name:kLTSCalendarDaySelected object:nil];
    
    
    
    
    
    
}


- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    

    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        dateFormatter.dateFormat = @"yyyy.MM.dd";
       
    }
   

   
    
}

/**
 *  点击事件
 */
- (void)didTouch
{
   
    
    
    [self setSelected:YES animated:YES];
    
   
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLTSCalendarDaySelected object:self.date];
    
       
    if(!self.isOtherMonth){
         self.calendarManager.lastSelectedWeekOfMonth = [self.calendarManager getWeekFromDate:self.date];
         [self.calendarManager setCurrentDateSelected:self.date];
        return;
    }
    
    [self.calendarManager setCurrentDateSelected:self.date];
    
    NSInteger currentMonthIndex = [self monthIndexForDate:self.date];
    NSInteger calendarMonthIndex = [self monthIndexForDate:self.calendarManager.currentDate];
    
    currentMonthIndex = currentMonthIndex % 12;
    
    if(currentMonthIndex == (calendarMonthIndex + 1) % 12){
        [self.calendarManager loadNextPage];
    }
    else if(currentMonthIndex == (calendarMonthIndex + 12 - 1) % 12){
        [self.calendarManager loadPreviousPage];
    }
}

- (void)didDaySelected:(NSNotification *)notification
{
    NSDate *dateSelected = [notification object];
    
    if([self isSameDate:dateSelected]){
        if(!isSelected){
            [self setSelected:YES animated:YES];
        }
    }
    else if(isSelected){
        [self setSelected:NO animated:YES];
    }
    
}

- (void)configureConstraintsForSubviews{
    backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
   textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.calendarManager.calendarAppearance.dayTextFont.pointSize-4);
    
    lunarTextLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.calendarManager.calendarAppearance.lunarDayTextFont.pointSize);
    
    
    
    
   CGFloat sizeCircle = self.calendarManager.calendarAppearance.dayCircleSize;
    
   CGFloat sizeDot = self.calendarManager.calendarAppearance.dayDotSize;
    

    
    circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    circleView.center = CGPointMake(self.frame.size.width / 2., circleView.center.y);
    circleView.layer.cornerRadius = sizeCircle / 2.;
    circleView.layer.masksToBounds = YES;
    
    circleView.layer.borderWidth = 1;
    
#warning TODO:判断农历是否显示
    //是否显示农历
    
    if (self.calendarManager.calendarAppearance.isShowLunarCalender) {
        lunarTextLabel.hidden =  NO;
        textLabel.center =  CGPointMake(circleView.center.x, circleView.center.y- CGRectGetHeight(textLabel.frame)/2);
        lunarTextLabel.center = CGPointMake(circleView.center.x, circleView.center.y + CGRectGetHeight(lunarTextLabel.frame)/2+2);
    }
    else{
        textLabel.center = circleView.center;
        
        lunarTextLabel.hidden = YES;
    }
   
    
    dotView.frame = CGRectMake(0, CGRectGetMaxY(circleView.frame)+1, sizeDot, sizeDot);
    dotView.center = CGPointMake(self.frame.size.width / 2., dotView.center.y );
    
    dotView.layer.cornerRadius = sizeDot / 2.;
    
}

- (void)setDate:(NSDate *)date
{
    static NSArray *dayArray;
    static NSArray *monthArray;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
    dayArray  = @[ @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",@"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
        
        monthArray = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"];
    });

    
    

    
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:@"dd"];
    }
    
    _date = date;
    
    textLabel.text = [dateFormatter stringFromDate:date];
 
    //获取农历
#ifdef __IPHONE_8_0
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
#else
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
#endif
  
    lunarTextLabel.text = dayArray[localeComp.day-1];
    if (localeComp.day-1 == 0) {
        lunarTextLabel.text = monthArray[localeComp.month-1];
    }
    
    
    isToday = -1;
    cacheCurrentDateText = nil;
    
    
    
    
}




- (void)setIsOtherMonth:(BOOL)isOtherMonth
{
    self->_isOtherMonth = isOtherMonth;
    [self setSelected:isSelected animated:NO];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if(isSelected == selected){
        animated = NO;
    }
    
    isSelected = selected;
    circleView.transform = CGAffineTransformIdentity;
    CGAffineTransform tr = CGAffineTransformIdentity;
    CGFloat opacity = 1.;
    if(selected){
        if(!self.isOtherMonth){
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorSelected];
            circleView.layer.borderColor = [UIColor clearColor].CGColor;
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelected];
            lunarTextLabel.textColor = self.calendarManager.calendarAppearance.lunarDayTextColorSelected;
            dotView.color = [self.calendarManager.calendarAppearance dayDotColorSelected];
        }
        else {
            
            
        }
        circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        tr = CGAffineTransformIdentity;
    }else {
        circleView.color = [UIColor clearColor];
        if ([self isToday]){
            
           circleView.layer.borderColor = [self.calendarManager.calendarAppearance dayBorderColorToday].CGColor;
            
            dotView.color = [self.calendarManager.calendarAppearance dayDotColor];
            
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColor];
            lunarTextLabel.textColor = self.calendarManager.calendarAppearance.lunarDayTextColor;
            
        
            
            
        }
        else{
            if(!self.isOtherMonth ){
                
                textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColor];
                lunarTextLabel.textColor = self.calendarManager.calendarAppearance.lunarDayTextColor;
                dotView.color = [self.calendarManager.calendarAppearance dayDotColor];
            }
            else{
                
                
                
                textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
                lunarTextLabel.textColor = self.calendarManager.calendarAppearance.lunarDayTextColorOtherMonth;
                dotView.color = [self.calendarManager.calendarAppearance dayDotColor];
            }
            
            circleView.layer.borderColor = [UIColor clearColor].CGColor;
            
        }
        
    }
    if(animated){
        [UIView animateWithDuration:.1 animations:^{
            circleView.layer.opacity = opacity;
            circleView.transform = tr;
        }];
    }
    else{
        circleView.layer.opacity = opacity;
        circleView.transform = tr;
    }

    
}

- (void)reloadData
{
    
    
    dotView.hidden = ![self.calendarManager.dataCache haveEvent:self.date];
    
    BOOL selected = [self isSameDate:[self.calendarManager currentDateSelected]];
   [self setSelected:selected animated:NO];
    
}

- (BOOL)isToday
{
    if(isToday == 0){
        return NO;
    }
    else if(isToday == 1){
        return YES;
    }
    else{
        if([self isSameDate:[NSDate date]]){
            isToday = 1;
            return YES;
        }
        else{
            isToday = 0;
            return NO;
        }
    }
}

- (BOOL)isSameDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    
    if(!cacheCurrentDateText){
        cacheCurrentDateText = [dateFormatter stringFromDate:self.date];
    }
    
    NSString *dateText2 = [dateFormatter stringFromDate:date];
    
    if ([cacheCurrentDateText isEqualToString:dateText2]) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)monthIndexForDate:(NSDate *)date
{
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

- (void)reloadAppearance
{
    
    
    
    
    textLabel.font = self.calendarManager.calendarAppearance.dayTextFont;
    textLabel.textColor = self.calendarManager.calendarAppearance.dayTextColor;
    
    lunarTextLabel.font = self.calendarManager.calendarAppearance.lunarDayTextFont;
    lunarTextLabel.textColor = self.calendarManager.calendarAppearance.lunarDayTextColor;
    
    
    
//    backgroundView.backgroundColor = self.calendarManager.calendarAppearance.dayBackgroundColor;
//    backgroundView.layer.borderWidth = self.calendarManager.calendarAppearance.dayBorderWidth;
//    backgroundView.layer.borderColor = self.calendarManager.calendarAppearance.dayBorderColor.CGColor;
    
    [self configureConstraintsForSubviews];
    [self setSelected:isSelected animated:NO];
}












@end
