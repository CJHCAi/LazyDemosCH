//
//  XFZ_TimeView.m
//  StarAlarm
//
//  Created by 谢丰泽 on 16/3/31.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "XFZ_TimeView.h"
#import "TEATimeRange.h"
#import "TEAClockChart.h"

@interface XFZ_TimeView () {
    CAShapeLayer *arcLayer;
    BOOL _isIntroduceVC;
    NSInteger numberOfHeight;
    BOOL _isIos5;
    BOOL _isAnimation;
    BOOL _isPressButton;
}

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *weerLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) TEAClockChart *time;
@property (nonatomic, strong) CABasicAnimation *bas;
@property (nonatomic, strong) NSString *seconds;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger secondBiao;
@property (nonatomic, strong) UIBezierPath *path;



@end

@implementation XFZ_TimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self creatView];
        [self creatTime];
        [self intiUIOfView];
      
        
    }
    return self;
}

- (void)creatTime {
    NSTimer *time = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
}

//
- (void)creatView{
    
    self.time = [[TEAClockChart alloc] init];
    self.time.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);

    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor whiteColor];
    self.label.frame = CGRectMake(self.bounds.size.width * 0.2, self.bounds.size.height * 0.3, 100, 35);
    
    self.weerLabel = [[UILabel alloc] init];
    self.weerLabel.textColor = [UIColor whiteColor];
    self.weerLabel.frame = CGRectMake(self.bounds.size.width * 0.45, self.bounds.size.height * 0.3, 100, 35);

    self.secondLabel = [[UILabel alloc] init];
    self.secondLabel.textColor = [UIColor whiteColor];
    self.secondLabel.frame = CGRectMake(self.bounds.size.width * 0.11, self.bounds.size.height * 0.4, self.bounds.size.width * 0.8, 65);

    
    self.label.font = [UIFont fontWithName:@"AmericanTypewriter" size:25];
    self.weerLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:28];
    self.secondLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:48];
    

    UIView *vieww = [[UIView alloc] init];
    vieww.frame = CGRectMake(self.bounds.size.width * 0.13, self.bounds.size.height * 0.6, self.bounds.size.width * 0.74, 2);
    vieww.backgroundColor = [UIColor whiteColor];
    [self addSubview:vieww];
    
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width * 0.3, self.bounds.size.height * 0.7, 60, 30)];
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.font = [UIFont systemFontOfSize:23];
    [self addSubview:self.cityLabel];
    
    self.wenduLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width * 0.55, self.bounds.size.height *0.7, 60, 30)];
    self.wenduLabel.textColor = [UIColor whiteColor];
    self.wenduLabel.font = [UIFont systemFontOfSize:23];
    [self addSubview:self.wenduLabel];
   
   
    
    [self addSubview:self.time];
    [self addSubview:self.secondLabel];
    [self addSubview:self.weerLabel];
    [self addSubview:self.label];
    [self timerAction];
    
}

-(void) setWeatherModel:(YXWWeatherModel *)weatherModel {
    _weatherModel = weatherModel;
    self.cityLabel.text = weatherModel.city;
    NSString *str = [weatherModel.wendu stringByAppendingString:@"℃"];
    self.wenduLabel.text = str;
    
}

- (void) timerAction {

    
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五", @"星期六", nil];
    NSDate *date = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [cal components:unitFlags fromDate:date];
    

    NSInteger month = comps.month;
    NSInteger day = comps.day;
    NSInteger week = comps.weekday;
    NSInteger minute = comps.minute;
    NSInteger hour = comps.hour;
    self.secondBiao = comps.second;
    
    
    NSString *monthDay = [NSString stringWithFormat:@"%ld / %ld",(long)month,(long)day];
    self.label.text = monthDay;
    
    //  星期几

    NSString *string=[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week-1]];

    self.weerLabel.text = string;
    
    //时间second
    _seconds = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minute,(long)self.secondBiao];

    
    _bas.byValue  = [NSNumber numberWithFloat:1 - (self.secondBiao / 60.0)];
    self.secondLabel.text = _seconds;
    
    //添加表盘方法
    self.time.data = @[[TEATimeRange timeRangeWithStart:[NSData data] end:[NSDate dateWithTimeIntervalSinceNow:3600]]
                       ];
    
    


}
-(void)intiUIOfView
{
    UIBezierPath *path=[UIBezierPath bezierPath];

    [path addArcWithCenter:self.time.center radius:self.time.bounds.size.width / 2 - 20 startAngle:-M_PI / 2 endAngle:M_PI * 1.5 clockwise:1];
    
    arcLayer=[CAShapeLayer layer];
    arcLayer.path = path.CGPath;//46,169,230
    arcLayer.fillColor = [UIColor colorWithRed:46.0/255.0 green:169.0/255.0 blue:230.0/255.0 alpha:0].CGColor;
    arcLayer.strokeColor = [UIColor colorWithWhite:1 alpha:0.7].CGColor;
    arcLayer.lineWidth = 3;
    arcLayer.frame = self.bounds;
    
    [self.layer addSublayer:arcLayer];
    [self drawLineAnimation:arcLayer];
    

}
-(void)drawLineAnimation:(CALayer*)layer
{

    
    self.bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    _bas.duration = (60 - self.secondBiao);
    _bas.delegate = self;
    _bas.byValue  = [NSNumber numberWithFloat:1 - (self.secondBiao / 60.0)];
    
    _bas.fillMode = kCAFillModeForwards;
    _bas.removedOnCompletion = NO;
    _bas.toValue=[NSNumber numberWithFloat:1.0f];
    _bas.autoreverses = NO;
    _bas.repeatCount = 1;
    [layer addAnimation:_bas forKey:@"key"];
    
    [_bas isRemovedOnCompletion];

    
}




- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{

    [arcLayer removeFromSuperlayer];
    [_bas isRemovedOnCompletion];
    [self intiUIOfView];
     
}



@end
