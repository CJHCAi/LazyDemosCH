//
//  YQCalendarEachDay.h
//  calendarDemo
//
//  Created by problemchild on 16/8/23.
//  Copyright © 2016年 ProblenChild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQCalendarEachDay : UIView

{
    //选中的图标
    UIImage *_selectedIMG;
    //选中的背景色
    UIColor *_selectedBackColor;
    //下方日期的颜色
    UIColor *_dayColor;
    //日期信息String
    NSString *_dateString;
}

-(UIImage *)selectedIMG;
-(void)setSelectedIMG:(UIImage *)img;

-(UIColor *)selectedBackColor;
-(void)setSelectedBackColor:(UIColor *)color;

-(UIColor *)dayColor;
-(void)setDayColor:(UIColor *)color;

-(NSString *)dateString;
-(void)setDateString:(NSString *)dateString;

/**
 *  设置是否被选中
 *
 *  @param selected 是/否
 */
-(void)setTheSelectedMode:(BOOL)selected;

/**
 *  设置号码
 *
 *  @param day 天数
 */
-(void)setTheDay:(int)day;



@end
