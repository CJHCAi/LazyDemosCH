//
//  wheelView.m
//  转盘01
//
//  Created by WEIWEI on 15-12-10.
//  Copyright (c) 2015年 WEIWEI. All rights reserved.
//

#import "wheelView.h"
@interface wheelView()
@property(strong, nonatomic) UIView *monthView;
@property(strong, nonatomic) UIView *dayView;
@property(strong, nonatomic) UIView *weekView;
@property(strong, nonatomic) UIView *hourView;
@property(strong, nonatomic) UIView *minuseView;
@property(strong, nonatomic) UIView *secondView;

@property(strong, nonatomic) UILabel *monthLableD;
@property(strong, nonatomic) UILabel *dayLabelD;
@property(strong, nonatomic) UILabel *weekLabelD;
@property(strong, nonatomic) UILabel *hourLabelD;
@property(strong, nonatomic) UILabel *minuseLabelD;
@property(strong, nonatomic) UILabel *secondLabelD;

@property(nonatomic,assign)NSInteger monthD;
@property(nonatomic,assign)NSInteger dayD;
@property(nonatomic,assign)NSInteger weekD;
@property(nonatomic,assign)NSInteger hourD;
@property(nonatomic,assign)NSInteger minuseD;
@property(nonatomic,assign)NSInteger secondD;

@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation wheelView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

-(void)initUI{
    CGFloat cx=self.frame.size.width/2;
    CGFloat cy=self.frame.size.height/2;
    CGFloat fw=[self sizeWithText:@"十" font:[UIFont systemFontOfSize:8] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    CGFloat marge=1;
    NSArray* monthArray=[NSArray arrayWithObjects:@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月", nil];
    NSArray* dayArray=[NSArray arrayWithObjects:@"一号",@"二号",@"三号",@"四号",@"五号",@"六号",@"七号",@"八号",@"九号",@"十号",@"十一号",@"十二号",@"十三号",@"十四号",@"十五号",@"十六号",@"十七号",@"十八号",@"十九号",@"二十号",@"二十一号",@"二十二号",@"二十三号",@"二十四号",@"二十五号",@"二十六号",@"二十七号",@"二十八号",@"二十九号",@"三十号",@"三十一号", nil];
    NSArray* weekArray=[NSArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日",nil];
    NSArray* hourArray=[NSArray arrayWithObjects:@"一点",@"二点",@"三点",@"四点",@"五点",@"六点",@"七点",@"八点",@"九点",@"十点",@"十一点",@"十二点",@"十三点",@"十四点",@"十五点",@"十六点",@"十七点",@"十八点",@"十九点",@"二十点",@"二十一点",@"二十二点",@"二十三点",@"零点", nil];
    NSArray* minuseArray=[NSArray arrayWithObjects:@"一分",@"二分",@"三分",@"四分",@"五分",@"六分",@"七分",@"八分",@"九分",@"十分",@"十一分",@"十二分",@"十三分",@"十四分",@"十五分",@"十六分",@"十七分",@"十八分",@"十九分",@"二十分",@"二十一分",@"二十二分",@"二十三分",@"二十四分",@"二十五分",@"二十六分",@"二十七分",@"二十八分",@"二十九分",@"三十分",@"三十一分",@"三十二分",@"三十三分",@"三十四分",@"三十五分",@"三十六分",@"三十七分",@"三十八分",@"三十九分",@"四十分",@"四十一分",@"四十二分",@"四十三分",@"四十四分",@"四十五分",@"四十六分",@"四十七分",@"四十八分",@"四十九分",@"五十分",@"五十一分",@"五十二分",@"五十三分",@"五十四分",@"五十五分",@"五十六分",@"五十七分",@"五十八分",@"五十九分",@"零分", nil];
    NSArray* secondArray=[NSArray arrayWithObjects:@"一秒",@"二秒",@"三秒",@"四秒",@"五秒",@"六秒",@"七秒",@"八秒",@"九秒",@"十秒",@"十一秒",@"十二秒",@"十三秒",@"十四秒",@"十五秒",@"十六秒",@"十七秒",@"十八秒",@"十九秒",@"二十秒",@"二十一秒",@"二十二秒",@"二十三秒",@"二十四秒",@"二十五秒",@"二十六秒",@"二十七秒",@"二十八秒",@"二十九秒",@"三十秒",@"三十一秒",@"三十二秒",@"三十三秒",@"三十四秒",@"三十五秒",@"三十六秒",@"三十七秒",@"三十八秒",@"三十九秒",@"四十秒",@"四十一秒",@"四十二秒",@"四十三秒",@"四十四秒",@"四十五秒",@"四十六秒",@"四十七秒",@"四十八秒",@"四十九秒",@"五十秒",@"五十一秒",@"五十二秒",@"五十三秒",@"五十四秒",@"五十五秒",@"五十六秒",@"五十七秒",@"五十八秒",@"五十九秒",@"零秒", nil];
    CGFloat monthw=fw*3+marge+10;
    self.monthView=[[UIView alloc] initWithFrame:CGRectMake(cx-monthw, cy-monthw, 2*monthw, 2*monthw)];
    for(int i=0;i<monthArray.count;i++){
        UILabel *monthLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, monthw, 10)];
        monthLabel.tag=i+1;
        monthLabel.text=[monthArray objectAtIndex:i];
        monthLabel.textAlignment=NSTextAlignmentRight;
        monthLabel.font=[UIFont systemFontOfSize:8];
        monthLabel.layer.anchorPoint=CGPointMake(0, 0.5);
        monthLabel.layer.position=CGPointMake(self.monthView.frame.size.width*0.5, self.monthView.frame.size.height*0.5);
        CGFloat angle=30 * i / 180.0 * M_PI;
        monthLabel.transform=CGAffineTransformMakeRotation(angle);
        [self.monthView addSubview:monthLabel];
    }
    [self addSubview:self.monthView];
    
    CGFloat dayw=monthw+4*fw+marge;
    self.dayView=[[UIView alloc] initWithFrame:CGRectMake(cx-dayw, cy-dayw, 2*dayw, 2*dayw)];
    for(int i=0;i<dayArray.count;i++){
        UILabel *dayLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, dayw, 10)];
        dayLabel.tag=i+1;
        dayLabel.text=[dayArray objectAtIndex:i];
        dayLabel.textAlignment=NSTextAlignmentRight;
        dayLabel.font=[UIFont systemFontOfSize:8];
        dayLabel.layer.anchorPoint=CGPointMake(0, 0.5);
        dayLabel.layer.position=CGPointMake(self.dayView.frame.size.width*0.5, self.dayView.frame.size.height*0.5);
        CGFloat angle=360 * i * M_PI/ 180.0 /31;
        dayLabel.transform=CGAffineTransformMakeRotation(angle);
        [self.dayView addSubview:dayLabel];
    }
    [self addSubview:self.dayView];
    
    CGFloat weekw=monthw+4*fw+marge+2*fw+marge;
    self.weekView=[[UIView alloc] initWithFrame:CGRectMake(cx-weekw, cy-weekw, 2*weekw, 2*weekw)];
    for(int i=0;i<weekArray.count;i++){
        UILabel *weekLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, weekw, 10)];
        weekLabel.tag=i+1;
        weekLabel.text=[weekArray objectAtIndex:i];
        weekLabel.textAlignment=NSTextAlignmentRight;
        weekLabel.font=[UIFont systemFontOfSize:8];
        weekLabel.layer.anchorPoint=CGPointMake(0, 0.5);
        weekLabel.layer.position=CGPointMake(self.weekView.frame.size.width*0.5, self.weekView.frame.size.height*0.5);
        CGFloat angle=360 * i * M_PI / 180.0/7;
        weekLabel.transform=CGAffineTransformMakeRotation(angle);
        [self.weekView addSubview:weekLabel];
    }
    [self addSubview:self.weekView];
    
    CGFloat hourw=monthw+4*fw+marge+2*fw+marge+4*fw+marge;
    self.hourView=[[UIView alloc] initWithFrame:CGRectMake(cx-hourw, cy-hourw, 2*hourw, 2*hourw)];
    for(int i=0;i<hourArray.count;i++){
        UILabel *hourLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,hourw , 10)];
        hourLabel.tag=i+1;
        hourLabel.text=[hourArray objectAtIndex:i];
        hourLabel.textAlignment=NSTextAlignmentRight;
        hourLabel.font=[UIFont systemFontOfSize:8];
        hourLabel.layer.anchorPoint=CGPointMake(0, 0.5);
        hourLabel.layer.position=CGPointMake(self.hourView.frame.size.width*0.5, self.hourView.frame.size.height*0.5);
        CGFloat angle=15 * i / 180.0 * M_PI;
        hourLabel.transform=CGAffineTransformMakeRotation(angle);
        [self.hourView addSubview:hourLabel];
    }
    [self addSubview:self.hourView];
    
    CGFloat minusew=monthw+4*fw+marge+2*fw+marge+4*fw+marge+4*fw+marge;
    self.minuseView=[[UIView alloc] initWithFrame:CGRectMake(cx-minusew, cy-minusew, 2*minusew, 2*minusew)];
    for(int i=0;i<minuseArray.count;i++){
        UILabel *minuseLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,minusew , 10)];
        minuseLabel.tag=i+1;
        minuseLabel.text=[minuseArray objectAtIndex:i];
        minuseLabel.textAlignment=NSTextAlignmentRight;
        minuseLabel.font=[UIFont systemFontOfSize:8];
        minuseLabel.layer.anchorPoint=CGPointMake(0, 0.5);
        minuseLabel.layer.position=CGPointMake(self.minuseView.frame.size.width*0.5, self.minuseView.frame.size.height*0.5);
        CGFloat angle=6 * i / 180.0 * M_PI;
        minuseLabel.transform=CGAffineTransformMakeRotation(angle);
        [self.minuseView addSubview:minuseLabel];
    }
    [self addSubview:self.minuseView];
    
    CGFloat secondw=monthw+4*fw+marge+2*fw+marge+4*fw+marge+4*fw+marge+4*fw+marge;
    self.secondView=[[UIView alloc] initWithFrame:CGRectMake(cx-secondw, cy-secondw, 2*secondw, 2*secondw)];
    for(int i=0;i<secondArray.count;i++){
        UILabel *secondLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,secondw , 10)];
        secondLabel.tag=i+1;
        secondLabel.text=[secondArray objectAtIndex:i];
        secondLabel.textAlignment=NSTextAlignmentRight;
        secondLabel.font=[UIFont systemFontOfSize:8];
        secondLabel.layer.anchorPoint=CGPointMake(0, 0.5);
        secondLabel.layer.position=CGPointMake(self.secondView.frame.size.width*0.5, self.secondView.frame.size.height*0.5);
        CGFloat angle=6 * i / 180.0 * M_PI;
        secondLabel.transform=CGAffineTransformMakeRotation(angle);
        [self.secondView addSubview:secondLabel];
    }
    [self addSubview:self.secondView];
    [self initStatus];
    [self setupDate];
}

-(void)initStatus{
    self.dataArray=[self getDate];
//    self.dataArray=[NSArray arrayWithObjects:@(4),@(28),@(3),@(24),@(59),@(55),@(28), nil];
    self.monthD=[[self.dataArray objectAtIndex:0] intValue];
    self.dayD=[[self.dataArray objectAtIndex:1] intValue];
    self.weekD=[[self.dataArray objectAtIndex:2] intValue]-1;
    self.hourD=[[self.dataArray objectAtIndex:3] intValue];
    self.minuseD=[[self.dataArray objectAtIndex:4] intValue];
    self.secondD=[[self.dataArray objectAtIndex:5] intValue];
    self.monthLableD=[self.monthView viewWithTag:self.monthD];
    self.dayLabelD=[self.dayView viewWithTag:self.dayD];
    self.weekLabelD=[self.weekView viewWithTag:self.weekD];
    self.hourLabelD=[self.hourView viewWithTag:self.hourD];
    self.minuseLabelD=[self.minuseView viewWithTag:self.minuseD];
    self.secondLabelD=[self.secondView viewWithTag:self.secondD];
    self.monthLableD.textColor=[UIColor whiteColor];
    self.dayLabelD.textColor=[UIColor whiteColor];
    self.weekLabelD.textColor=[UIColor whiteColor];
    self.hourLabelD.textColor=[UIColor whiteColor];
    self.minuseLabelD.textColor=[UIColor whiteColor];
    self.secondLabelD.textColor=[UIColor whiteColor];
    [UIView animateWithDuration:0.3f animations:^{
        CGFloat angle=30 * (self.monthD-1) / 180.0 * M_PI;
        self.monthView.transform=CGAffineTransformRotate(self.monthView.transform,-angle);
    }];
    [UIView animateWithDuration:0.3f animations:^{
        CGFloat angle=360 * (self.dayD-1) * M_PI/ 180.0 /31;
        self.dayView.transform=CGAffineTransformRotate(self.dayView.transform,-angle);
    }];
    [UIView animateWithDuration:0.3f animations:^{
        CGFloat angle=360 * (self.weekD-1) * M_PI/ 180.0 /7;
        self.weekView.transform=CGAffineTransformRotate(self.weekView.transform,-angle);
    }];
    [UIView animateWithDuration:0.3f animations:^{
        CGFloat angle=360 * (self.hourD-1) * M_PI/ 180.0 /24;
        self.hourView.transform=CGAffineTransformRotate(self.hourView.transform,-angle);
    }];
    [UIView animateWithDuration:0.3f animations:^{
        CGFloat angle=360 * (self.minuseD-1) * M_PI/ 180.0 /60;
        self.minuseView.transform=CGAffineTransformRotate(self.minuseView.transform,-angle);
    }];
    [UIView animateWithDuration:0.3f animations:^{
        CGFloat angle=360 * (self.secondD-1) * M_PI/ 180.0 /60;
        self.secondView.transform=CGAffineTransformRotate(self.secondView.transform,-angle);
    }];
}


-(void)setupDate{
    NSTimer *timer=[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(rollView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)rollView{
    [self p_second];
}
-(void)p_second{
    self.secondD++;
    if(self.secondD%61==0){
        self.secondD=1;
    }
    if(self.secondD%60==0){
        [self p_minuse];
    }
    self.secondLabelD.textColor=[UIColor blackColor];
    self.secondLabelD=[self.secondView viewWithTag:self.secondD];
    self.secondLabelD.textColor=[UIColor whiteColor];
    CGFloat angle=6 / 180.0 * M_PI;
    [UIView animateWithDuration:0.3f animations:^{
        self.secondView.transform=CGAffineTransformRotate(self.secondView.transform,-angle);
    }];
    
}
-(void)p_minuse{
    self.minuseD++;
    if(self.minuseD%61==0){
        self.minuseD=1;
    }
    if(self.minuseD%60==0){
         [self p_hour];
    }
    self.minuseLabelD.textColor=[UIColor blackColor];
    self.minuseLabelD=[self.minuseView viewWithTag:self.minuseD];
    self.minuseLabelD.textColor=[UIColor whiteColor];
    CGFloat angle=6 / 180.0 * M_PI;
    [UIView animateWithDuration:0.3f animations:^{
        self.minuseView.transform=CGAffineTransformRotate(self.minuseView.transform,-angle);
    }];
}
-(void)p_hour{
    self.hourD++;
    if(self.hourD%25==0){
        self.hourD=1;
    }
    if(self.hourD%24==0){
        [self p_week];
        [self p_day];
    }
    self.hourLabelD.textColor=[UIColor blackColor];
    self.hourLabelD=[self.hourView viewWithTag:self.hourD];
    self.hourLabelD.textColor=[UIColor whiteColor];
    CGFloat angle=15 / 180.0 * M_PI;
    [UIView animateWithDuration:0.3f animations:^{
        self.hourView.transform=CGAffineTransformRotate(self.hourView.transform,-angle);
    }];
}
-(void)p_week{
    self.weekD++;
    if(self.weekD%8==0){
        self.weekD=1;
    }
    self.weekLabelD.textColor=[UIColor blackColor];
    self.weekLabelD=[self.weekView viewWithTag:self.weekD];
    self.weekLabelD.textColor=[UIColor whiteColor];
    CGFloat angle=360 * M_PI / 180.0/7;
    [UIView animateWithDuration:0.3f animations:^{
        self.weekView.transform=CGAffineTransformRotate(self.weekView.transform,-angle);
    }];
}
-(void)p_day{
    int day=[[self.dataArray objectAtIndex:6] intValue];
    int count=1;
    self.dayD++;
    if(self.dayD%(day+1)==0){
        self.dayD=1;
        [self p_month];
        count=(31-day)+1;
    }
    self.dayLabelD.textColor=[UIColor blackColor];
    self.dayLabelD=[self.dayView viewWithTag:self.dayD];
    self.dayLabelD.textColor=[UIColor whiteColor];
    CGFloat angle2=360 * count * M_PI / 180.0/31;
    [UIView animateWithDuration:0.3f animations:^{
        self.dayView.transform=CGAffineTransformRotate(self.dayView.transform,-angle2);
    }];
}
-(void)p_month{
    self.monthD++;
    if(self.monthD%13==0){
        self.monthD=1;
    }
    self.monthLableD.textColor=[UIColor blackColor];
    self.monthLableD=[self.monthView viewWithTag:self.monthD];
    self.monthLableD.textColor=[UIColor whiteColor];
    CGFloat angle=30 / 180.0 * M_PI;
    [UIView animateWithDuration:0.3f animations:^{
        self.monthView.transform=CGAffineTransformRotate(self.monthView.transform,-angle);
    }];
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(NSArray *)getDate{
    
    //获取系统当前的时间
    NSDate  * senddate=[NSDate date];
    NSCalendar *cal=[NSCalendar  currentCalendar];
    NSUInteger unitFlags= NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday;
    NSDateComponents *conponent= [cal components:unitFlags fromDate:senddate];
    
    //获取年、月、日
    NSInteger year =  [conponent year];
    NSInteger month = [conponent month];
    NSInteger day   = [conponent day];
    
    //获取时、分、秒
    NSInteger hour  =  [conponent hour];
    NSInteger minute = [conponent minute];
    NSInteger second = [conponent second];
    
    //一年中的第几周
    NSInteger weekOfYear  =  [conponent weekOfYear];
    NSInteger weekOfMonth  =  [conponent weekOfMonth];
    NSInteger weekday  =  [conponent weekday];
    NSLog(@"%ld-%ld-%ld-%ld-%ld-%ld-%ld-%ld-%ld",year,month,day,hour,minute,second,weekOfYear,weekOfMonth,weekday);
    
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:senddate];
    NSUInteger numberOfDaysInMonth = range.length;
    
    return [NSArray arrayWithObjects:@(month),@(day),@(weekday),@(hour),@(minute),@(second),@(numberOfDaysInMonth), nil];
}
@end
