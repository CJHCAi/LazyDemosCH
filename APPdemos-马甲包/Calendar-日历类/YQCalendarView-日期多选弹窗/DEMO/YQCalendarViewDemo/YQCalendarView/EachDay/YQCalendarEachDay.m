//
//  YQCalendarEachDay.m
//  calendarDemo
//
//  Created by problemchild on 16/8/23.
//  Copyright © 2016年 ProblenChild. All rights reserved.
//

#import "YQCalendarEachDay.h"

@interface YQCalendarEachDay ()
/**
 *  显示天数号码的Lable
 */
@property(nonatomic,strong)UILabel *lab;

/**
 *  被选中的图片
 */
@property(nonatomic,strong)UIImageView *selectedIMGV;


@end

@implementation YQCalendarEachDay


-(UIImage *)selectedIMG{
    return _selectedIMG?_selectedIMG:[UIImage imageNamed:@"icon_yiqiandao.png"];
}
-(void)setSelectedIMG:(UIImage *)img{
    _selectedIMG = img;
    self.selectedIMGV.image = img;
}

-(UIColor *)selectedBackColor{
    return _selectedBackColor?_selectedBackColor:[UIColor colorWithRed:0.863 green:0.867 blue:0.875 alpha:1.000];
}
-(void)setSelectedBackColor:(UIColor *)color{
    _selectedBackColor = color;
    if(self.selectedIMGV.hidden == NO){
        self.backgroundColor = color;
    }else{\
        self.backgroundColor = [UIColor clearColor];
    }
}

-(UIColor *)dayColor{
    return _dayColor?_dayColor:[UIColor blackColor];
}
-(void)setDayColor:(UIColor*)color{
    _dayColor  = color;
    self.lab.textColor = color;
}

-(NSString *)dateString{
    return _dateString?_dateString:@"尚未赋值";
}
-(void)setDateString:(NSString *)dateString{
    _dateString = dateString;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    [self setup];
    
    return self;
}

/**
 *  初始化
 */
-(void)setup{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.lab = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                        0,
                                                        self.frame.size.width,
                                                        self.frame.size.height/2)];
    
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.lab.numberOfLines = 0;
    self.lab.textColor = self.dayColor;
    [self addSubview:self.lab];
    
    self.selectedIMGV = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                     self.frame.size.height/2,
                                                                     self.frame.size.width,
                                                                     self.frame.size.height/2)];
    self.selectedIMGV.contentMode = UIViewContentModeScaleAspectFit;
    self.selectedIMGV.image = self.selectedIMG;
    self.selectedIMGV.hidden = YES;
    [self addSubview:self.selectedIMGV];
    
}


-(void)setTheSelectedMode:(BOOL)selected{
    if(selected){
        self.selectedIMGV.hidden = NO;
        self.backgroundColor = self.selectedBackColor;
    }else{
        self.selectedIMGV.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
    }
}

-(void)setTheDay:(int)day{
    self.lab.text = [NSString stringWithFormat:@"%d",day];
}


@end
