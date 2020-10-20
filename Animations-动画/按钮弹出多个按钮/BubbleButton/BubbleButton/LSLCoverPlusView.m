//
//  LSLCoverPlusView.m
//  BubbleButton
//
//  Created by lisonglin on 15/05/2017.
//  Copyright © 2017 lisonglin. All rights reserved.
//

#import "LSLCoverPlusView.h"
#import "UIColor+LSLColor.h"

static CGFloat const kDefaultAnimationDuration = 0.2f;
static CGFloat const kDefaultOriginBtnWidth = 40.0;
static CGFloat const kDefaultOriginBtnHeight = kDefaultOriginBtnWidth;



static CGFloat const kDefaultBtnSpacing = 20;   //按钮之间的间距
static CGFloat const kDefaultBtnWidth = 30;     //宽
static CGFloat const kDefaultBtnHeight = 30;    //高

static CGFloat const kDefaultTagWidth = 60.f;
static CGFloat const kDefaultTagHeight = 20.f;

@interface LSLCoverPlusView ()

@property(nonatomic, weak) UIButton * floatingBtn;

@property(nonatomic, strong) UIView * bgView;

@property(nonatomic, strong) UIButton * cameraBtn;  //相机

@property(nonatomic, strong) UIButton * albumBtn;   //相册

@property(nonatomic, strong) UILabel * cameraTag;

@property(nonatomic, strong) UILabel * albumTag;

@property(nonatomic, assign,getter=isShow) BOOL show;


@end

@implementation LSLCoverPlusView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.show = NO;
        
        //iniitialize
        [self addCustomViews];
        
    }
    return self;
}

- (void)addCustomViews
{
    //bgView
    _bgView = [[UIView alloc] initWithFrame:self.bounds];
    _bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    _bgView.hidden = YES;
    _bgView.alpha = 0.0;
    [self addSubview:_bgView];
    
    //originBtn
    UIButton * floatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingBtn = floatingBtn;
    floatingBtn.frame = CGRectMake(self.bounds.size.width / 2 + 40, self.bounds.size.height - 150, kDefaultOriginBtnWidth, kDefaultOriginBtnHeight);
    floatingBtn.backgroundColor = [UIColor redColor];
    [self addSubview:floatingBtn];
    [self bringSubviewToFront:floatingBtn];
    [floatingBtn addTarget:self action:@selector(floatingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    floatingBtn.layer.cornerRadius = kDefaultOriginBtnWidth / 2;
    [floatingBtn setTitle:@"L" forState:UIControlStateNormal];
    
    
    //相机按钮
    CGRect cameraFrame = CGRectMake(self.bounds.size.width / 2 + 40 + (kDefaultOriginBtnWidth - kDefaultBtnWidth) / 2, self.bounds.size.height - 150 - kDefaultBtnSpacing - kDefaultBtnHeight, kDefaultBtnWidth, kDefaultBtnHeight);
    
    self.cameraBtn = [self buttonWithFrame:cameraFrame normalImg:nil selectImg:nil backGroudColor:@"#F3C130" tag:20];
    [self addSubview:self.cameraBtn];
    self.cameraBtn.hidden = YES;

    //相册按钮
    CGRect albumFrame = CGRectMake(self.bounds.size.width / 2 + 40 + (kDefaultOriginBtnWidth - kDefaultBtnWidth) / 2, CGRectGetMinY(self.cameraBtn.frame) - kDefaultBtnSpacing - kDefaultBtnHeight, kDefaultBtnWidth, kDefaultBtnHeight);
    self.albumBtn = [self buttonWithFrame:albumFrame normalImg:@"album" selectImg:nil backGroudColor:@"#3cba54" tag:21];
    [self addSubview:self.albumBtn];
    self.albumBtn.hidden = YES;

    
    //相机tag
    CGRect cameraTagFrame = CGRectMake(self.bounds.size.width / 2 + 40 - kDefaultTagWidth, CGRectGetMinY(self.cameraBtn.frame) + (self.cameraBtn.frame.size.height - kDefaultTagHeight) / 2, kDefaultTagWidth, kDefaultTagHeight);
    self.cameraTag = [self labelWithFrame:cameraTagFrame font:12.0 textColor:[UIColor colorWithLSLString:@"#959595"] text:@"拍摄照片"];
    [self addSubview:self.cameraTag];
    self.cameraTag.hidden = YES;
    //相册tag
    
    CGRect albumTagFrame = CGRectMake(self.bounds.size.width / 2 + 40 - 60, CGRectGetMinY(self.albumBtn.frame) + (self.albumBtn.frame.size.height - kDefaultTagHeight) / 2, 60, 20);
    self.albumTag = [self labelWithFrame:albumTagFrame font:12.0 textColor:[UIColor colorWithLSLString:@"#959595"] text:@"选择图片"];
    [self addSubview:self.albumTag];
    self.albumTag.hidden = YES;
}



- (void)floatingBtnClick
{
    self.show = !self.show;
    
    if (self.show) {//no
        
        self.cameraBtn.hidden = NO;
        self.cameraTag.hidden = NO;
        self.albumBtn.hidden = NO;
        self.albumTag.hidden = NO;
        self.bgView.hidden = NO;
        
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            self.floatingBtn.transform = CGAffineTransformMakeRotation(-M_PI_4 * 3);
                        
        }completion:^(BOOL finished) {

        }];
        
        CABasicAnimation * animation = [self opacityAnimationWithFromValue:0.0 toValue:1.0];
        
        [self.bgView.layer addAnimation:animation forKey:@"myShow"];

        //按钮动画
        CABasicAnimation *scaleAnimation = [self scaleAnimationFromValue:0.1 toValue:1.0];
        [self.cameraBtn.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
        [self.albumBtn.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
        
        [self.cameraBtn.layer addAnimation:animation forKey:@"myShow"];
        [self.albumBtn.layer addAnimation:animation forKey:@"myShow"];

        //label动画
        CASpringAnimation * spring = [self springAnimationFromValue:self.cameraTag.layer.position.x - kDefaultTagWidth toValue:self.cameraTag.layer.position.x];
        [self.cameraTag.layer addAnimation:spring forKey:spring.keyPath];
        [self.albumTag.layer addAnimation:spring forKey:spring.keyPath];
        
        [self.cameraTag.layer addAnimation:animation forKey:@"myShow"];
        [self.albumTag.layer addAnimation:animation forKey:@"myShow"];
        
    }else {
        
        [self dismissView];
        
    }
}

#pragma mark -- 消失动画
- (void)dismissView
{
    CABasicAnimation * animation = [self opacityAnimationWithFromValue:1.0 toValue:0.0];
    
    [self.bgView.layer addAnimation:animation forKey:@"myShow"];
    
    CABasicAnimation *scaleAnimation = [self scaleAnimationFromValue:1.0 toValue:0.0];
    
    [self.cameraBtn.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
    [self.albumBtn.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
    
    [self.cameraBtn.layer addAnimation:animation forKey:@"myShow"];
    [self.albumBtn.layer addAnimation:animation forKey:@"myShow"];
    [self.cameraTag.layer addAnimation:animation forKey:@"myShow"];
    [self.albumTag.layer addAnimation:animation forKey:@"myShow"];
    
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        
        self.floatingBtn.transform = CGAffineTransformMakeRotation(0);
        
        
    }completion:^(BOOL finished) {
        
        self.bgView.hidden = YES;
        
        self.cameraBtn.hidden = YES;
        self.cameraTag.hidden = YES;
        self.albumBtn.hidden = YES;
        self.albumTag.hidden = YES;
    }];
}




#pragma mark -- 创建一个button
- (UIButton *)buttonWithFrame:(CGRect)frame normalImg:(NSString *)norImgStr selectImg:(NSString *)selImgStr  backGroudColor:(NSString *)backColorStr tag:(NSInteger)index;
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setImage:[UIImage imageNamed:norImgStr] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImgStr] forState:UIControlStateSelected];
    btn.layer.cornerRadius = frame.size.width / 2;
    btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    btn.backgroundColor = [UIColor colorWithLSLString:backColorStr];
    
    [btn addTarget:self action:@selector(coverPlusViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index;
    
    return btn;
}

#pragma mark -- 创建一个label
- (UILabel *)labelWithFrame:(CGRect)frame font:(CGFloat)fontSize textColor:(UIColor *)color text:(NSString *)text
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor =  color;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

#pragma mark -- 点击按钮消失的动画
- (void)disapearAnimation
{
    CABasicAnimation *scaleAnimation = [self scaleAnimationFromValue:1.0 toValue:0.1];
    [self.cameraBtn.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
    [self.albumBtn.layer addAnimation:scaleAnimation forKey:@"scale-layer"];

}


#pragma mark -- 透明度动画
- (CABasicAnimation *)opacityAnimationWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:fromValue];
    showViewAnn.toValue = [NSNumber numberWithFloat:toValue];
    showViewAnn.duration = kDefaultAnimationDuration;
    showViewAnn.fillMode = kCAFillModeForwards;
    showViewAnn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    showViewAnn.removedOnCompletion = NO;
    
    return showViewAnn;
}

#pragma mark -- 缩放动画
- (CABasicAnimation *)scaleAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    scaleAnimation.toValue = [NSNumber numberWithFloat:toValue];
    scaleAnimation.duration = kDefaultAnimationDuration;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.autoreverses = NO;
    
    return scaleAnimation;
}


#pragma mark -- 弹簧动画
- (CASpringAnimation *)springAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    CASpringAnimation * spring = [CASpringAnimation animationWithKeyPath:@"position.x"];
    spring.damping = 10;
    spring.stiffness = 100;
    spring.mass = 0.5;
    spring.initialVelocity = 0;
    spring.fromValue = [NSNumber numberWithFloat:self.cameraTag.layer.position.x + 60];
    spring.toValue = [NSNumber numberWithFloat:self.cameraTag.layer.position.x];
    spring.duration = spring.settlingDuration;
    return spring;
}


- (void)coverPlusViewBtnClick:(UIButton *)sender
{
    [self dismissView];
    
    self.show = NO;
    
    if ([self.delegate respondsToSelector:@selector(coverPlusView:didClickAtIndex:)]) {
        [self.delegate coverPlusView:self didClickAtIndex:sender.tag];
    }
}

@end
