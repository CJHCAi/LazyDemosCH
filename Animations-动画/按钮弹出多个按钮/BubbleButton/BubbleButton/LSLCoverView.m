//
//  LSLCoverView.m
//  BubbleButton
//
//  Created by lisonglin on 15/05/2017.
//  Copyright © 2017 lisonglin. All rights reserved.
//

#import "LSLCoverView.h"
#import "UIColor+LSLColor.h"

static CGFloat const kDefaultBtnSpacing = 20;   //按钮之间的间距
static CGFloat const kDefaultBtnWidth = 30;     //宽
static CGFloat const kDefaultBtnHeight = 30;    //高

static CGFloat const kDefaultAnimationDuration = 0.2f;
static CGFloat const kDefaultOriginBtnWidth = 40.0;
static CGFloat const kDefaultTagWidth = 60.f;
static CGFloat const kDefaultTagHeight = 20.f;



@interface LSLCoverView ()

@property(nonatomic, strong) UIButton * cameraBtn;  //相机

@property(nonatomic, strong) UIButton * albumBtn;   //相册

@property(nonatomic, strong) UILabel * cameraTag;

@property(nonatomic, strong) UILabel * albumTag;

@end


@implementation LSLCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        
        self.userInteractionEnabled = YES;
        //添加子控件
        [self addCustomViews];
    }
    return self;
}


- (void)addCustomViews
{
    //相机
    CGRect cameraFrame = CGRectMake(self.bounds.size.width / 2 + 40 + (kDefaultOriginBtnWidth - kDefaultBtnWidth) / 2, self.bounds.size.height - 150 - kDefaultBtnSpacing - kDefaultBtnHeight, kDefaultBtnWidth, kDefaultBtnHeight);

    self.cameraBtn = [self buttonWithFrame:cameraFrame normalImg:nil selectImg:nil backGroudColor:@"#F3C130"];
    [self addSubview:self.cameraBtn];
    self.cameraBtn.alpha = 0.0;

    self.cameraBtn.tag = 19;
    [self.cameraBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        self.cameraBtn.alpha = 1.0;
    }];

    //相册
    CGRect albumFrame = CGRectMake(self.bounds.size.width / 2 + 40 + (kDefaultOriginBtnWidth - kDefaultBtnWidth) / 2, CGRectGetMinY(self.cameraBtn.frame) - kDefaultBtnSpacing - kDefaultBtnHeight, kDefaultBtnWidth, kDefaultBtnHeight);
    self.albumBtn = [self buttonWithFrame:albumFrame normalImg:@"album" selectImg:nil backGroudColor:@"#3cba54"];
    [self addSubview:self.albumBtn];

    self.albumBtn.alpha = 0.0;
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        self.albumBtn.alpha = 1.0;
    }];
    
    self.cameraBtn.tag = 20;
    [self.cameraBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //两个tag标签
    //相机Tag
    CGRect cameraTagFrame = CGRectMake(self.bounds.size.width / 2 + 40 - kDefaultTagWidth, CGRectGetMinY(self.cameraBtn.frame) + (self.cameraBtn.frame.size.height - kDefaultTagHeight) / 2, kDefaultTagWidth, kDefaultTagHeight);
    self.cameraTag = [self labelWithFrame:cameraTagFrame font:12.0 textColor:[UIColor colorWithLSLString:@"#959595"] text:@"拍摄照片"];
    [self addSubview:self.cameraTag];

    //相册Tag
    CGRect albumTagFrame = CGRectMake(self.bounds.size.width / 2 + 40 - 60, CGRectGetMinY(self.albumBtn.frame) + (self.albumBtn.frame.size.height - kDefaultTagHeight) / 2, 60, 20);
    self.albumTag = [self labelWithFrame:albumTagFrame font:12.0 textColor:[UIColor colorWithLSLString:@"#959595"] text:@"选择图片"];
    [self addSubview:self.albumTag];
}


#pragma mark -- 创建一个button
- (UIButton *)buttonWithFrame:(CGRect)frame normalImg:(NSString *)norImgStr selectImg:(NSString *)selImgStr backGroudColor:(NSString *)backColorStr
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setImage:[UIImage imageNamed:norImgStr] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selImgStr] forState:UIControlStateSelected];
    btn.layer.cornerRadius = frame.size.width / 2;
    btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    btn.backgroundColor = [UIColor colorWithLSLString:backColorStr];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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



- (void)setShow:(BOOL)show
{
    _show = show;
    if (self.isShow) {//如果显示 放大动画
        //按钮动画
        CABasicAnimation *scaleAnimation = [self scaleAnimationFromValue:0.1 toValue:1.0];
        [self.cameraBtn.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
        [self.albumBtn.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
        
        //label动画
        CASpringAnimation * spring = [self springAnimationFromValue:self.cameraTag.layer.position.x - kDefaultTagWidth toValue:self.cameraTag.layer.position.x];
        [self.cameraTag.layer addAnimation:spring forKey:spring.keyPath];
        [self.albumTag.layer addAnimation:spring forKey:spring.keyPath];
        
        CABasicAnimation * animation = [self opacityAnimationWithFromValue:0.0 toValue:1.0];
        
        [self.layer addAnimation:animation forKey:@"myShow"];
        
    }else {//不显示 缩小动画

        [self disapearAnimation];
    }
    
}

#pragma mark -- 点击按钮消失的动画
- (void)disapearAnimation
{
    CABasicAnimation *scaleAnimation = [self scaleAnimationFromValue:1.0 toValue:0.1];
    [self.cameraBtn.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
    [self.albumBtn.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
    
    CABasicAnimation * animation = [self opacityAnimationWithFromValue:1.0 toValue:0.0];
    
    [self.layer addAnimation:animation forKey:@"myShow"];
}


#pragma mark -- 缩放动画
- (CABasicAnimation *)scaleAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    scaleAnimation.toValue = [NSNumber numberWithFloat:toValue];
    scaleAnimation.duration = kDefaultAnimationDuration;
    scaleAnimation.repeatCount = 1;
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

#pragma mark -- 按钮代理

- (void)btnClick:(UIButton *)sender
{
    [self disapearAnimation];
    
    self.show = NO;
    
    if ([self.delegate respondsToSelector:@selector(coverView:didClickBtnAtIndex: dismiss:)]) {
        [self.delegate coverView:self didClickBtnAtIndex:sender.tag dismiss:self.show];
    }
}



@end
