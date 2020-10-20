//
//  ZWMLuckView.m
//  ZWMLuckViewDemo
//
//  Created by 伟明 on 2017/12/15.
//  Copyright © 2017年 com.zwm. All rights reserved.
//

#import "ZWMLuckView.h"

static int const BtnSpace = 50;
static int const RowAndColumNumber = 3;
static NSString * const ZWMAnimationKey = @"ZWMShowAnimation";

@interface ZWMLuckView()
{
    NSInteger  _rateTotal;
    NSTimer    *_startTimer;
    CGFloat    _intervalTime;
    NSInteger  _stopRunCount;
    NSInteger  _currentRunCount;
}
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *btnMutableArray;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *runBtn;
@end

@implementation ZWMLuckView
#pragma mark --- 懒加载
- (NSMutableArray *)btnMutableArray
{
    if (_btnMutableArray == nil) {
        _btnMutableArray = [NSMutableArray arrayWithCapacity:9];
    }
    return _btnMutableArray;
}
#pragma mark --- Set方法
- (void)setRateArray:(NSArray *)rateArray
{
    _rateArray = rateArray;
    for (NSNumber * rate in rateArray) {
        _rateTotal += [rate integerValue];
    }
}
#pragma mark --- 初始化
- (__kindof ZWMLuckView *)initWithFrame:(CGRect)frame imagesArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        _imagesArray = array;
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    CGFloat btnWidth = (viewWidth-(RowAndColumNumber-1)*BtnSpace)/RowAndColumNumber;
    CGFloat btnHeight = (viewHeight-(RowAndColumNumber-1)*BtnSpace)/RowAndColumNumber;
    // 初始化九宫格
    for (int i = 0; i < _imagesArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i%RowAndColumNumber)*btnWidth + BtnSpace,(i/RowAndColumNumber)*btnHeight+BtnSpace, btnWidth, btnHeight);
        btn.backgroundColor = [UIColor clearColor];
        btn.tag=i;
        [self addSubview:btn];
        if (i==4) {
            [btn setTitle:@"抽奖" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor yellowColor]];
            btn.layer.cornerRadius = btnWidth/2.0;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            self.startBtn = btn;
            continue;
        }
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(8,8, btnWidth - 16, btnHeight - 16)];
        imageV.image = [UIImage imageNamed:[_imagesArray objectAtIndex:i>4?i-1:i]];
        [btn addSubview:imageV];
        [self.btnMutableArray addObject:btn];
    }
    // 交换按钮位置
    [self exchangeFrameWithBtn:self.btnMutableArray[3] otherBtn:self.btnMutableArray[4]];
    [self exchangeFrameWithBtn:self.btnMutableArray[4] otherBtn:self.btnMutableArray[7]];
    [self exchangeFrameWithBtn:self.btnMutableArray[5] otherBtn:self.btnMutableArray[6]];
}
- (void)exchangeFrameWithBtn:(UIButton *)firstBtn otherBtn:(UIButton *)secondBtn {
    CGRect frame = firstBtn.frame;
    firstBtn.frame = secondBtn.frame;
    secondBtn.frame = frame;
}
#pragma mark --- 抽奖按钮
- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 4) {
        _stopRunCount = 0;
        _currentRunCount = 0;
        NSInteger tempRateTotal = _rateTotal>0?_rateTotal:100;
        NSInteger temp = arc4random()%tempRateTotal + 1;//随机数
        NSInteger max = 0;
        NSInteger min = 0;
        for (int i = 0; i < self.rateArray.count ; i++) {
            NSInteger rateIndex= [self.rateArray[i] integerValue];
            if (i == 0) {
                min = 0;
            }else{
                min = min + [self.rateArray[i-1] integerValue];
            }
            max = max + rateIndex;
            if (min < temp && temp <= max) {
                _stopRunCount = i+1;
                break;
            }
        }
        _intervalTime = 0.1;
        _stopRunCount = _stopRunCount+7+8*self.circleCount;
        [self.startBtn setEnabled:NO];
        _startTimer = [NSTimer scheduledTimerWithTimeInterval:_intervalTime target:self selector:@selector(start:) userInfo:nil repeats:YES];
    }
}
- (void)start:(NSTimer *)timer {
    [self.runBtn.layer removeAnimationForKey:ZWMAnimationKey];
    if (self.runBtn) {
        self.runBtn.backgroundColor = [UIColor clearColor];
    }
    UIButton *oldBtn = [self.btnMutableArray objectAtIndex:_currentRunCount % self.btnMutableArray.count];
    oldBtn.backgroundColor = [UIColor orangeColor];
    self.runBtn = oldBtn;
    _currentRunCount++;
    // 停止循环
    if (_currentRunCount > _stopRunCount) {
        [timer invalidate];
        [self.startBtn setEnabled:YES];
        [self setStopBtnAnimation:self.runBtn];
        [self stopWithCount:_currentRunCount%self.btnMutableArray.count];
        return;
    }
    // 一直循环
    if (_currentRunCount > _stopRunCount - 5) {
        _intervalTime += 0.1;
        [timer invalidate];
        _startTimer = [NSTimer scheduledTimerWithTimeInterval:_intervalTime target:self selector:@selector(start:) userInfo:nil repeats:YES];
    }
}

- (void)setStopBtnAnimation:(UIButton *)button{
    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    showViewAnn.fromValue = [UIColor orangeColor];
    showViewAnn.toValue = [UIColor yellowColor];
    showViewAnn.duration = 0.1;
    showViewAnn.autoreverses=YES;
    showViewAnn.removedOnCompletion = NO;
    showViewAnn.fillMode = kCAFillModeForwards;
    showViewAnn.repeatCount=MAXFLOAT;
    CFTimeInterval time = [self.runBtn.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    showViewAnn.beginTime = 0.5+time; // 延迟0.5秒执行动画
    [self.runBtn.layer addAnimation:showViewAnn forKey:ZWMAnimationKey];
}
- (void)stopWithCount:(NSInteger)count {
    if (count == 0) {
        count = self.rateArray.count;
    }
    if ([self.deleagte respondsToSelector:@selector(luckViewDidStopWithIndex:)]) {
        [self.deleagte luckViewDidStopWithIndex:count];
    }
}
- (void)dealloc
{
    [_startTimer invalidate];
}
@end
