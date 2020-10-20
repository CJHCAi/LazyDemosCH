//
//  SMMenuButton.m
//  SMMenuButton
//
//  Created by 朱思明 on 14/1/5.
//  Copyright (c) 2015年 朱思明. All rights reserved.
//





#import "SMMenuButton.h"
// 自定动画组
@interface MyCABasicAnimation : CABasicAnimation

@property (nonatomic, assign) NSInteger tag;
@end

@implementation MyCABasicAnimation
@end


#define MySin(lenght,mpi) lenght * sin(mpi)
#define MyCos(lenght,mpi) lenght * cos(mpi)
@implementation SMMenuButton
/**
 *  自定义动画按钮
 *
 *  @param bgImageName          自身背景图片的名字
 *  @param imageName            自身标题图片的名字
 *  @param subButtonbgImageName 所有子视图背景图片的名字
 *  @param subButtonImageNames  所有子视图标题图片的名字（有几个图片就有几个按钮）
 *  @param frame                自身的大小
 *
 *  @return 自定义动画按钮对象
 */
- (id)initWithBackgroudImageName:(NSString *)bgImageName
                       imageName:(NSString *)imageName
     subButtonBackgroudImageName:(NSString *)subButtonbgImageName
             subButtonImageNames:(NSArray *)subButtonImageNames
                           Frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化属性
        self.subButton_size = CGSizeMake(44, 44);
        self.bgImageName = bgImageName;
        self.imageName = imageName;
        self.subButtonbgImageName = subButtonbgImageName;
        self.subButtonImageNames = subButtonImageNames;
        // 初始化按钮的长度
        self.lenght = 100;
        
        self.start_pi = M_PI_2;
        self.center_pi = M_PI_2;
        
        
        // 添加按钮的点击事件
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - 复写SET方法
- (void)setSubButton_size:(CGSize)subButton_size
{
    if (_subButton_size.width != subButton_size.width || _subButton_size.height != subButton_size.height ) {
        _subButton_size = subButton_size;
        
        // 修改说有按钮的大小
        for (UIButton *subButton in _subButtons) {
            subButton.frame = CGRectMake(subButton.frame.origin.x, subButton.frame.origin.y, _subButton_size.width, _subButton_size.height);
            subButton.center = self.center;
        }
    }
}

- (void)setBgImageName:(NSString *)bgImageName
{
    if (_bgImageName != bgImageName) {
        _bgImageName = bgImageName;
        
        // 设置到自身的背景视图上
        [self setBackgroundImage:[UIImage imageNamed:_bgImageName] forState:UIControlStateNormal];
        
    }
}

- (void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName) {
        _imageName = imageName;
        
        // 设置自身的标题图片
        [self setImage:[UIImage imageNamed:_imageName] forState:UIControlStateNormal];
    }
}

- (void)setSubButtonImageNames:(NSArray *)subButtonImageNames
{
    if (_subButtonImageNames != subButtonImageNames) {
        _subButtonImageNames = subButtonImageNames;
        
        
        // 创建子试图按钮
        NSMutableArray *subButtons = [NSMutableArray array];
        for (int i = 0; i < _subButtonImageNames.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            // 设置按钮位置
            button.frame = CGRectMake(0, 0 , self.subButton_size.width, self.subButton_size.height);
            button.center = self.center;
            
            // 设置按钮的图片
            [button setBackgroundImage:[UIImage imageNamed:_subButtonbgImageName] forState:UIControlStateNormal];
            UIImage *image = [UIImage imageNamed:_subButtonImageNames[i]];
            [button setImage:image forState:UIControlStateNormal];
            
            // 设置按钮的tag
            button.tag = i;
            [button addTarget:self action:@selector(subButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            // 添加到数组中
            [subButtons addObject:button];
        }
        
        // 保存到属性的数组中
        self.subButtons = subButtons;
    }
}

#pragma mark - subButtonAction:
- (void)subButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(menuButton:clickedMenuButtonAtIndex:)]) {
        [self.delegate menuButton:self clickedMenuButtonAtIndex:button.tag];
    }
}

#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)button
{
    if (!self.isOpen) {
        // 调用协议方法
        if ([_delegate respondsToSelector:@selector(menuButtonWillOpen:)]) {
            [_delegate menuButtonWillOpen:self];
        }
        // 当前状态为打开状态
        _isOpen = YES;
        
        // 自身标题视图旋转
        [self setImageViewRotationformValue:@(0) toValue:@(-M_PI_4)];
        
        // 现实子视图
        [self showSubButton];
    } else {
        // 调用协议方法
        if ([_delegate respondsToSelector:@selector(menuButtonWillClose:)]) {
            [_delegate menuButtonWillClose:self];
        }
        // 当前状态为打开状态
        _isOpen = NO;
        
        // 自身标题视图旋转
        [self setImageViewRotationformValue:@(-M_PI_4) toValue:@(0)];
        
        // 隐藏子视图
        [self hiddenSubButton];
    }
    
}

// 隐藏子视图
- (void)hiddenSubButton
{
    for (UIButton *subButton in self.subButtons) {
        // 1.旋转动画
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        basic.duration = .08f;
        basic.toValue = @(2*M_PI);
        // 重复次数
        basic.repeatCount = HUGE_VALF;
        [subButton.layer addAnimation:basic forKey:@"basic"];
        
        // 2.回到自身的下面
        [UIView animateWithDuration:.3 animations:^{
            // 设置延迟
            [UIView setAnimationDelay:.01];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            subButton.center = self.center;
        } completion:^(BOOL finished) {
            [subButton removeFromSuperview];
        }];
    }

}

// 现实子视图
- (void)showSubButton
{
    // 1.添加所有的按钮
    for (UIButton *subButton in self.subButtons) {
        // 添加到父视图上
        [self.superview insertSubview:subButton belowSubview:self];
        
        // 添加动画
        [self addAnimationWithSubButton:subButton];
    }
    
}

- (void)addAnimationWithSubButton:(UIButton *)button
{
    // 1.旋转动画
    MyCABasicAnimation *basic = [MyCABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basic.tag = button.tag;
    basic.duration = .08f;
    basic.toValue = @(2*M_PI);
    // 重复次数
    basic.repeatCount = HUGE_VALF;
    
    // 2.走动动画
    CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation"];
    
    // 计算当前的角度
    double m_pi = _center_pi * (((_subButtons.count - 1) - button.tag)
                            / (double)(self.subButtons.count - 1)) - _start_pi;
    // 走动的点
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(MyCos((_lenght + 5), m_pi),-MySin((_lenght + 5), m_pi))];
    NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(MyCos((_lenght - 3), m_pi),-MySin((_lenght - 3), m_pi))];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(MyCos(_lenght, m_pi),-MySin(_lenght, m_pi))];
    
    keyframe.duration = .35;
    keyframe.values = @[value1,value2,value3,value4];
    keyframe.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 动画结束停止
    keyframe.removedOnCompletion = NO;
    keyframe.fillMode = kCAFillModeForwards;
    
    // 3.创建动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    group.animations = @[basic,keyframe];
    // 设置延迟
    group.beginTime = CACurrentMediaTime() + .08 * ( button.tag );
    
    //设置组的动画时间
    group.duration = .4;
    group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    
    // 把动画组添加到按钮上
    [button.layer addAnimation:group forKey:[NSString stringWithFormat:@"%ld",button.tag]];
   
}

/**
 *  自身标题视图旋转
 *
 *  @param formValue 开始值
 *  @param toValue   结束值
 */
- (void)setImageViewRotationformValue:(NSNumber *)formValue
                              toValue:(NSNumber *)toValue

{
    // 1.自身动画
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basic.duration = .2f;
    basic.fromValue = formValue;
    basic.toValue = toValue;
    // 动画结束停止
    basic.removedOnCompletion = NO;
    basic.fillMode = kCAFillModeForwards;
    [self.imageView.layer addAnimation:basic forKey:@"mybasic"];
}

/*
 *  打开菜单按钮
 */
- (void)openMenuButton
{
    if (_isOpen == NO) {
        // 调用协议方法
        if ([_delegate respondsToSelector:@selector(menuButtonWillOpen:)]) {
            [_delegate menuButtonWillOpen:self];
        }
        // 当前状态为打开状态
        _isOpen = YES;
        
        // 自身标题视图旋转
        [self setImageViewRotationformValue:@(0) toValue:@(-M_PI_4)];
        
        // 现实子视图
        [self showSubButton];
    }
}

/*
 *  关闭菜单按钮
 */
- (void)closeMenuButton
{
    if (_isOpen == YES) {
        // 调用协议方法
        if ([_delegate respondsToSelector:@selector(menuButtonWillClose:)]) {
            [_delegate menuButtonWillClose:self];
        }
        // 当前状态为打开状态
        _isOpen = NO;
        
        // 自身标题视图旋转
        [self setImageViewRotationformValue:@(-M_PI_4) toValue:@(0)];
        
        // 隐藏子视图
        [self hiddenSubButton];
    }
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.isOpen) {
        // 改变按钮的frame
        if ([anim isMemberOfClass:[CAAnimationGroup class]]) {
            // 转换
            CAAnimationGroup *group = (CAAnimationGroup *)anim;
            MyCABasicAnimation *animation = group.animations[0];
            if ([animation isMemberOfClass:[MyCABasicAnimation class]]) {
                NSLog(@"%ld",animation.tag);
                UIButton *button = [self.subButtons objectAtIndex:animation.tag];
                // 计算当前的角度
                double m_pi = _center_pi * (((_subButtons.count - 1) - button.tag)
                                                       / (double)(self.subButtons.count - 1)) - _start_pi;

                
                button.center = CGPointMake(self.center.x + MyCos(_lenght, m_pi), self.center.y-MySin(_lenght, m_pi));
                
                [button.layer removeAllAnimations];
                NSLog(@"--------");
            }
            
        }
    
        
    }
}







@end
