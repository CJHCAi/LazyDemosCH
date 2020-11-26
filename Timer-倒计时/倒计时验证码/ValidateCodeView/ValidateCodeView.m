//
//  ValidateCodeView.m
//  ValidateCodeView
//
//  Created by zhuming on 16/3/11.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "ValidateCodeView.h"

#define orImage1  [UIImage imageNamed:@"icon_yzmsj"]     // 可点击的图片
#define orImage2  [UIImage imageNamed:@"icon_program_bg-shenhe"]  // 不可点击的图片

// 图片拉伸
#define IMAGE1   [orImage1 stretchableImageWithLeftCapWidth:orImage1.size.width/2 topCapHeight:orImage1.size.height/2]
#define IMAGE2   [orImage2 stretchableImageWithLeftCapWidth:orImage2.size.width/2 topCapHeight:orImage2.size.height/2]

@interface ValidateCodeView ()
/**
 *  倒计时 定时器
 */
@property (nonatomic,strong)NSTimer *timer;
/**
 *  颜色图片
 */
@property (nonatomic,strong)UIImageView *imageView;
/**
 *  倒计时显示label
 */
@property (nonatomic,strong)UILabel *timeLabel;

/**
 *  倒计时长度
 */
@property (nonatomic,assign)NSInteger timeCount;
/**
 *  备份 倒计时长度 
 */
@property (nonatomic,assign)NSInteger timeCount2;

@end


@implementation ValidateCodeView
/**
 *  初始化视图
 *
 *  @param frame      frame
 *  @param timerCount 倒计时长度
 *
 *  @return 视图
 */
- (instancetype)initWithFrame:(CGRect)frame timerCount:(NSInteger)timerCount{
    self = [super initWithFrame:frame];
    if (self) {
        self.timeCount = timerCount;
        self.timeCount2 = timerCount;
        [self initView:frame];
    }
    return self;
}

/**
 *  初始化视图
 */
- (void)initView:(CGRect)frame{
    self.frame = frame;
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = frame;
    [self addSubview:self.imageView];

    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.frame = frame;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.timeLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getValidateCode)];
    [self.timeLabel addGestureRecognizer:tap];
}
/**
 *  获取 验证码
 */
- (void)getValidateCode{
    [self start];
}

/**
 *  开始倒计时
 */
- (void)start{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    if ([_delegate respondsToSelector:@selector(startTimeCount)]) {
        [_delegate startTimeCount];
    }
}

/**
 *  倒计时60s
 *
 *  @param timers
 */
-(void)timerFireMethod:(NSTimer*)timers {
    self.timeCount -- ;
    [self canGetYzm:NO];
    self.timeLabel.text = [NSString stringWithFormat:@"重新获取(%0.0ld)",(long)self.timeCount];
    if (self.timeCount == 0) {
        [self reset];
    }
}
/**
 *  获取验证码按钮是否可以点击
 *
 *  @param isCan YES: 可以点击   NO:不可以点击
 */
- (void)canGetYzm:(BOOL)isCan{
    if (isCan) {
        // 按钮可以点击
        self.imageView.image = IMAGE1;
        self.imageView.userInteractionEnabled = YES;
        self.timeLabel.userInteractionEnabled = YES;
        self.timeLabel.text = @"获取验证码";
    }
    else{
        // 按钮不可以点击
        self.imageView.image = IMAGE2;
        self.imageView.userInteractionEnabled = NO;
        self.timeLabel.userInteractionEnabled = NO;
    }
}
/**
 *  还原验证控件
 */
-(void)reset{
    [self canGetYzm:NO];
    self.timeCount = self.timeCount2;
    self.timeLabel.text = @"获取验证码";
    [self.timer invalidate];
    self.timer = nil;
    
    if ([_delegate respondsToSelector:@selector(endTimeCount)]) {
        [_delegate endTimeCount];
    }
}

@end
