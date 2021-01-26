//
//  YQCalendarView.h
//  calendarDemo
//
//  Created by problemchild on 16/8/22.
//  Copyright © 2016年 ProblenChild. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YQCalendarViewDelegate <NSObject>

-(void)YQCalendarViewTouchedOneDay:(NSString *)dateString;

@end

@interface YQCalendarView : UIView

{
    //选中的日期数组
    NSMutableArray *_selectedArray;
    //标题颜色
    UIColor *_titleColor;
    //标题字体
    UIFont  *_titleFont;
    //日期颜色
    UIColor *_dayColor;
    //日期字体
    UIFont  *_dayFont;
    //选中的背景色
    UIColor *_selectedBackColor;
    //选中状态的图标
    UIImage *_selectedIcon;
    //下一页的按钮图标
    UIImage *_nextBTNIcon;
    //前一页的按钮图标
    UIImage *_preBTNIcon;
}

-(NSMutableArray *)selectedArray;
-(void)setSelectedArray:(NSArray *)array;

-(UIColor *)titleColor;
-(void)setTitleColor:(UIColor *)color;

-(UIFont *)titleFont;
-(void)setTitleFont:(UIFont *)font;

-(UIColor *)dayColor;
-(void)setDayColor:(UIColor *)color;

-(UIFont *)dayFont;
-(void)setDayFont:(UIFont *)font;

-(UIColor *)selectedBackColor;
-(void)setSelectedBackColor:(UIColor *)color;

-(UIImage *)selectedIcon;
-(void)setSelectedIcon:(UIImage *)img;

-(UIImage *)nextBTNIcon;
-(void)setNextBTNIcon:(UIImage *)img;

-(UIImage *)preBTNIcon;
-(void)setPreBTNIcon:(UIImage *)img;


@property(nonatomic,weak) id <YQCalendarViewDelegate> delegate;

//把某一天变为选中状态
-(void)AddToChooseOneDay:(NSString *)dayStr;


@end
