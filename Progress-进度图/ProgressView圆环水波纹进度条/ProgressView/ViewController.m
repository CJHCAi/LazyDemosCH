//
//  ViewController.m
//  ProgressView
//
//  Created by zhao on 16/9/13.
//  Copyright © 2016年 zhaoName. All rights reserved.
//

#import "ViewController.h"
#import "CircleProgressView.h"
#import "WaveProgressView.h"
#import "LoadProgressView.h"
#import "ColorProgressView.h"
#import "HemicycleLoadProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) CircleProgressView *circleProgress;
@property (nonatomic, strong) CircleProgressView *anticlockwiseProgress;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) WaveProgressView *noWaveProgress;
@property (nonatomic, strong) WaveProgressView *waveProgress;

@property (nonatomic, strong) LoadProgressView *loadProgress;
@property (nonatomic, strong) HemicycleLoadProgressView *cycleLoadProgress;

@property (nonatomic, strong) ColorProgressView *colorProgress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.circleProgress];
    [self.view addSubview:self.anticlockwiseProgress];
    
    [self.view addSubview:self.noWaveProgress];
    [self.view addSubview:self.waveProgress];
    
    [self.view addSubview:self.loadProgress];
    [self.loadProgress addNotificationObserver];
    
    [self.view addSubview:self.colorProgress];
    [self createColorButton];
    
    [self.view addSubview:self.cycleLoadProgress];
    [self.cycleLoadProgress addNotificationObserver];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressTimer:) userInfo:nil repeats:YES];
}

- (void)progressTimer:(NSTimer *)timer
{
    self.circleProgress.percent += 0.05;
    self.circleProgress.centerLabel.text = [NSString stringWithFormat:@"%.02f%%", self.circleProgress.percent*100];
    
    self.anticlockwiseProgress.percent += 0.05;
    self.anticlockwiseProgress.centerLabel.text = @"跳过";
    
    self.noWaveProgress.percent += 0.05;
    self.noWaveProgress.centerLabel.text = [NSString stringWithFormat:@"%.02f%%", self.noWaveProgress.percent*100];
    
    self.waveProgress.percent += 0.05;
    self.waveProgress.centerLabel.text = [NSString stringWithFormat:@"%.02f%%", self.waveProgress.percent*100];
    
    if(self.waveProgress.percent > 1)
    {
        [self.timer invalidate];
    }
}

#pragma mark -- 颜色进度条

/**
 *  创建颜色按钮 这个控件最好不要放在ColorProgressView封装 设置btn的center在圆上btn会被切掉一半，不好控制frame
 */
- (void)createColorButton
{
    UIButton *colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    colorBtn.frame = CGRectMake(0, 0, 20, 20);
    colorBtn.center = CGPointMake(250, 323);
    colorBtn.layer.cornerRadius = CGRectGetWidth(colorBtn.frame)/2;
    colorBtn.backgroundColor = [self.colorProgress colorWithCirclePoint:CGPointMake(250-200, 323-320)];;
    [colorBtn addTarget:self action:@selector(touchColorBtn: event:) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:colorBtn];
}

- (void)touchColorBtn:(UIButton *)colorBtn event:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint btnPoint = [touch locationInView:self.view];
    //随着拖拽按钮改变按钮的位置
    colorBtn.center = [self.colorProgress getColorBtnCenterWithDragBtnPoint:btnPoint centerOfCircle:self.colorProgress.center];
    CGPoint center = colorBtn.center;
    //注意 你获取的是self.colorProgress上的颜色，所以你的坐标应该是self.colorProgress为父视图的坐标
    center.x -= CGRectGetMinX(self.colorProgress.frame);
    center.y -= CGRectGetMinY(self.colorProgress.frame);
    colorBtn.backgroundColor = [self.colorProgress colorWithCirclePoint:center];
}

#pragma mark -- getter

- (CircleProgressView *)circleProgress{
    if(!_circleProgress){
        _circleProgress = [[CircleProgressView alloc] initWithFrame:CGRectMake(50, 80, 80, 80)];
        _circleProgress.backgroundColor = [UIColor orangeColor];
    }
    return _circleProgress;
}

- (CircleProgressView *)anticlockwiseProgress
{
    if(!_anticlockwiseProgress)
    {
        _anticlockwiseProgress = [[CircleProgressView alloc] initWithFrame:CGRectMake(200, 80, 80, 80)];
        _anticlockwiseProgress.clockwise = YES;
        _anticlockwiseProgress.backgroundColor = [UIColor clearColor];
    }
    return _anticlockwiseProgress;
}

- (WaveProgressView *)noWaveProgress
{
    if(!_noWaveProgress)
    {
        _noWaveProgress  = [[WaveProgressView alloc] initWithFrame:CGRectMake(50, 200, 80, 80)];
        _noWaveProgress.isShowWave = NO;
    }
    return _noWaveProgress;
}

- (WaveProgressView *)waveProgress
{
    if(!_waveProgress)
    {
        _waveProgress = [[WaveProgressView alloc] initWithFrame:CGRectMake(200, 200, 80, 80)];
    }
    return _waveProgress;
}

- (LoadProgressView *)loadProgress
{
    if(!_loadProgress)
    {
        _loadProgress = [[LoadProgressView alloc] initWithFrame:CGRectMake(50, 320, 50, 50)];
        _loadProgress.progressColors = @[[UIColor redColor], [UIColor blueColor], [UIColor orangeColor], [UIColor greenColor]];
    }
    return _loadProgress;
}

- (HemicycleLoadProgressView *)cycleLoadProgress
{
    if(!_cycleLoadProgress)
    {
        _cycleLoadProgress = [[HemicycleLoadProgressView alloc] initWithFrame:CGRectMake(50, 400, 50, 50)];
    }
    return _cycleLoadProgress;
}

- (ColorProgressView *)colorProgress
{
    if(!_colorProgress)
    {
        _colorProgress = [[ColorProgressView alloc] initWithFrame:CGRectMake(200, 320, 100, 100)];
    }
    return _colorProgress;
}

@end
