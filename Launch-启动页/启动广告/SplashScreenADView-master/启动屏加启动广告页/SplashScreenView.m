//
//  SplashScreenView.m
//  启动屏加启动广告页
//
//  Created by WOSHIPM on 16/8/9.
//  Copyright © 2016年 WOSHIPM. All rights reserved.
//

#import "SplashScreenView.h"

@interface  SplashScreenView()

@property (nonatomic, strong) UIImageView *adImageView;

@property (nonatomic, strong) UIButton *countButton;

@property (nonatomic, strong) NSTimer *countTimer;

@property (nonatomic, assign) NSInteger count;
@end
 

@implementation SplashScreenView

- (NSTimer *)countTimer
{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 1.广告图片
        _adImageView = [[UIImageView alloc] initWithFrame:frame];
        _adImageView.userInteractionEnabled = YES;
        _adImageView.contentMode = UIViewContentModeScaleAspectFill;
        _adImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAdVC)];
        [_adImageView addGestureRecognizer:tap];
        
        // 2.跳过按钮
        _countButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _countButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 84, 30, 60, 30);
        [_countButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        _countButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countButton.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countButton.layer.cornerRadius = 4;
        
        [self addSubview:_adImageView];
        [self addSubview:_countButton];
      
    }
    return self;
}
-(void)setImgFilePath:(NSString *)imgFilePath{
    _imgFilePath = imgFilePath;
     _adImageView.image = [UIImage imageWithContentsOfFile:_imgFilePath];
}
-(void)setImgDeadline:(NSString *)imgDeadline{
    _imgDeadline = imgDeadline;
}

- (void)pushToAdVC{
    //点击广告图时，广告图消失，同时像首页发送通知，并把广告页对应的地址传给首页
    [self dismiss];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tapAction" object:_imgLinkUrl userInfo:nil];
}

- (void)countDown
{
    _count --;
    [_countButton setTitle:[NSString stringWithFormat:@"跳过%ld",(long)_count] forState:UIControlStateNormal];
    if (_count == 0) {
        
        [self dismiss];
    }
}

- (void)showSplashScreenWithTime:(NSInteger)ADShowTime
{
    _ADShowTime = ADShowTime;
    [_countButton setTitle:[NSString stringWithFormat:@"跳过%ld",ADShowTime] forState:UIControlStateNormal];
//
 
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"MM/dd/yyyy HH:mm";
    
   
    //获取当前系统的时间，并用相应的格式转换
    [dataFormatter stringFromDate:[NSDate date]];
    NSString *currentDayStr = [dataFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dataFormatter dateFromString:currentDayStr];
    
    //广告截止的时间，也用相同的格式去转换
    NSString * timeStampString = self.imgDeadline;
    
    //时间戳的日期格式转换方法
//    NSTimeInterval _interval=[timeStampString doubleValue] / 1000.0;
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
//    NSString *deadlineStr = [dataFormatter stringFromDate:date];
//    NSDate *dateA = [dataFormatter dateFromString:deadlineStr];
//     NSDate *deadlineDate = [dataFormatter dateFromString:_imgDeadline];
    
    
    NSDate *deadlineDate = [dataFormatter dateFromString:_imgDeadline];
    NSLog(@"当前日期：%@ 存下的截止日期：%@", currentDayStr, timeStampString);
    NSComparisonResult result;
    result = [deadlineDate compare:currentDate];
    /**
     *  将存下来的日期和当前日期相比，如果当前日期小于存下来的时间，则可以显示广告页，反之则不显示
     */
    if (result == NSOrderedAscending) {
        
        [self dismiss];
 
    }else{
 
        [self startTimer];
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        
        window.hidden = NO;
        
        [window addSubview:self];
    }

}

// 定时器倒计时
- (void)startTimer
{
    _count = _ADShowTime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}



// 移除广告页面
- (void)dismiss
{
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}


@end
