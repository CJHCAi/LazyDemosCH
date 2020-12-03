//
//  CFCalendarView.m
//  CFCalendar
//
//  Created by MountainCao on 2017/8/22.
//  Copyright © 2017年 深圳中业兴融互联网金融服务有限公司. All rights reserved.
//

#import "CFCalendarView.h"
#import "CFCalendarCell.h"
#import "CFMonthEntity.h"
#import "CFDayEntity.h"

@interface CFCalendarView ()

@property (nonatomic, strong) NSMutableArray   *dayArray;

@end

@implementation CFCalendarView

+(instancetype)initWithFrame:(CGRect)frame year:(NSInteger)year month:(NSInteger)month superView:(UIView *)superView selectedDateBlock:(SelectedDateBlock)selectedBlock {
    
    return [[self alloc]initWithFrame:frame year:year month:month superView:superView selectedDateBlock:selectedBlock];
}

-(instancetype)initWithFrame:(CGRect)frame year:(NSInteger)year month:(NSInteger)month superView:(UIView *)superView selectedDateBlock:(SelectedDateBlock)selectedBlock  {
    self = [super initWithFrame:frame];
    if (self) {
        self.dayArray = [NSMutableArray array];
        
        CFMonthEntity *monthEntity = [[CFMonthEntity alloc]init];
        monthEntity.year = year;
        monthEntity.month = month;
        
        for (int i=0; i<monthEntity.daysSum; i++) {
            CFDayEntity *dayEntity = [[CFDayEntity alloc]init];
            dayEntity.year = year;
            dayEntity.month = month;
            dayEntity.day = i+1;
            dayEntity.currentMonthDay = YES;
            [self.dayArray addObject:dayEntity];
        }
        
        CFDayEntity *firstDayEntity = self.dayArray.firstObject;
        for (int i=0; i<firstDayEntity.week; i++) {
            CFDayEntity *dayEntity = [[CFDayEntity alloc]init];
            dayEntity.currentMonthDay = NO;
            [self.dayArray insertObject:dayEntity atIndex:0];
        }
        
        for (int i=0; i<42-self.dayArray.count; i++) {
            CFDayEntity *dayEntity = [[CFDayEntity alloc]init];
            dayEntity.currentMonthDay = NO;
            [self.dayArray addObject:dayEntity];
        }
        
        //至此数组里一定有42个对象，下面布局就容易了
        //42个cell,6行7列
        CGFloat cellWidth = self.bounds.size.width/7;
        CGFloat cellHeight = self.bounds.size.height/6;
        
        for (int i=0; i<self.dayArray.count; i++) {
            
            CFCalendarCell *cell = [[CFCalendarCell alloc]init];
            cell.frame = CGRectMake(i%7*cellWidth, i/7*cellHeight, cellWidth, cellHeight);
            [self addSubview:cell];
            
            CFDayEntity *dayEntity = self.dayArray[i];
            
            if (dayEntity.currentMonthDay) {
                cell.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)dayEntity.day];
                cell.dayLabel.hidden = NO;
            } else {
                cell.dayLabel.hidden = YES;
            }
            if (dayEntity.currentDay) {
                cell.dotView.hidden = NO;
            }
            cell.selectCellBlock = ^{
                if (selectedBlock) {
                    selectedBlock(dayEntity.year, dayEntity.month, dayEntity.day);
                }
            };
        }
        [superView addSubview:self];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"===dealloc===");
}

@end
