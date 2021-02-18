//
//  CustomPikcerDateView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/17.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CustomPikcerDateView.h"

@interface CustomPikcerDateView()<UIPickerViewDataSource,UIPickerViewDelegate>
/** 年月日时选择器*/
@property (nonatomic, strong) UIPickerView *pickerView;
/** 开始年份*/
@property (nonatomic, assign) NSInteger startYear;
/** 年范围*/
@property (nonatomic, assign) NSInteger yearRange;
/** 日期范围*/
@property (nonatomic, assign) NSInteger dayRange;
/** 选定的年*/
@property (nonatomic, assign) NSInteger selectedYear;
/** 选定的月*/
@property (nonatomic, assign) NSInteger selectedMonth;
/** 选定的日*/
@property (nonatomic, assign) NSInteger selectedDay;
/** 选定的时*/
@property (nonatomic, assign) NSInteger selectedHour;


@end

@implementation CustomPikcerDateView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pickerView  = [[UIPickerView alloc]initWithFrame:self.bounds];
        self.pickerView.dataSource=self;
        self.pickerView.delegate=self;
        [self addSubview:self.pickerView];
        
        
//        NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDateComponents *comps = [[NSDateComponents alloc] init];
//        NSInteger unitFlags =  NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
//        comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
//        NSInteger year=[comps year];


        
        
        self.startYear=1900;
        self.yearRange=200;
        self.dayRange=[self isAllDay:self.startYear andMonth:1];

    }
    return self;
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            return self.yearRange;
        }
            break;
        case 1:
        {
            return 12;
        }
            break;
        case 2:
        {
            return self.dayRange;
        }
            break;
        case 3:
        {
            return 24;
        }
            break;
        default:
            break;
    }
    return 0;

}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]init];
    label.font=[UIFont systemFontOfSize:15.0];
    label.tag=component*900+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
            label.frame=CGRectMake(5, 0,Screen_width/4.0, 30);
            label.text=[NSString stringWithFormat:@"%ld",(long)(self.startYear + row)];
        }
            break;
        case 1:
        {
            label.frame=CGRectMake(Screen_width/4.0, 0, Screen_width/4, 30);
            label.text=[NSString stringWithFormat:@"%ld",(long)row+1];
        }
            break;
        case 2:
        {
            label.frame=CGRectMake(Screen_width/2, 0, Screen_width/4, 30);
            label.text=[NSString stringWithFormat:@"%ld",(long)row+1];
        }
            break;
        case 3:
        {
            label.frame = CGRectMake(Screen_width/4*3, 0, Screen_width/4-10, 30);
            label.text=[NSString stringWithFormat:@"%ld",(long)row];
        }
            break;
        default:
            break;
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            self.selectedYear=self.startYear + row;
            self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
            [self.pickerView reloadComponent:2];
        }
            break;
        case 1:
        {
            self.selectedMonth=row+1;
            self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
            [self.pickerView reloadComponent:2];
        }
            break;
        case 2:
        {
            self.selectedDay=row+1;
        }
            break;
        case 3:
        {
            self.selectedHour=row;
        }
            break;
            
        default:
            break;
    }
    
//    [self.delegate getCustomPickerDateViewYear:self.selectedYear andMonth:self.selectedMonth andDay:self.selectedDay andHour:self.selectedHour];
    
    [self.delegate getCustomPickerDateViewYear:self.startYear +[pickerView selectedRowInComponent:0] andMonth:[pickerView selectedRowInComponent:1]+1 andDay:[pickerView selectedRowInComponent:2]+1 andHour:[pickerView selectedRowInComponent:3]];
}



-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}



@end
