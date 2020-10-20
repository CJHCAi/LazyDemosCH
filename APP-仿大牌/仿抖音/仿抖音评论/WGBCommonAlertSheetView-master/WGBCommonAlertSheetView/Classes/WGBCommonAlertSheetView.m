//
//  WGBCommonAlertSheetView.m
//
//  Created by mac on 2019/9/2.
//  Copyright © 2019 CoderWGB. All rights reserved.
//

#import "WGBCommonAlertSheetView.h"

#ifndef KWIDTH
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#endif

#ifndef KHIGHT
#define KHIGHT  [UIScreen mainScreen].bounds.size.height
#endif

@interface WGBCommonAlertSheetView()<UIGestureRecognizerDelegate>

//容器视图
@property (nonatomic,strong) UIView *containerView;

@property (nonatomic, strong) UITapGestureRecognizer    *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer    *panGesture;

@property (nonatomic, weak) UIScrollView                *scrollView;
@property (nonatomic, assign) BOOL                      isDragScrollView;
@property (nonatomic, assign) CGFloat                   lastTransitionY;

@end


@implementation WGBCommonAlertSheetView

- (instancetype)initWithFrame:(CGRect)frame containerView:(UIView *)containerView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.containerView = containerView;
        
        CGRect contentFrame =  containerView.frame;
        contentFrame.origin.y = frame.size.height;
        self.containerView.frame = contentFrame;
        [self addSubview: self.containerView];
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
        self.containerView.alpha = 0.01;
        self.touchDismiss = YES;
        self.isNeedBlur = NO;
        self.bounce = YES;
        
    }
    return self;
}

- (void)setMaskAlpha:(CGFloat)maskAlpha{
    _maskAlpha = maskAlpha;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:maskAlpha];
}

- (void)setTouchDismiss:(BOOL)touchDismiss{
    _touchDismiss = touchDismiss;
}

- (void)setIsNeedBlur:(BOOL)isNeedBlur{
    _isNeedBlur = isNeedBlur;
    
}

- (void)setBounce:(BOOL)bounce{
    _bounce = bounce;
    if (bounce) {
        // 添加手势
        [self addGestureRecognizer:self.tapGesture];
        [self addGestureRecognizer:self.panGesture];
    }
}

- (void)setBlurStyle:(WGBCommonAlertSheetViewBlurEffectStyle)blurStyle{
    _blurStyle = blurStyle;
    if (self.isNeedBlur) {
        UIBlurEffectStyle style = (blurStyle == WGBCommonAlertSheetViewBlurEffectStyleDark)? UIBlurEffectStyleDark : UIBlurEffectStyleLight;
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:style];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        [self insertSubview: effectView atIndex:0];
        effectView.frame = self.bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.01];
    }
}

///MARK:- show & dismiss
- (void)show{
    [self showAlertWithSuperView:nil];
}

- (void)showAlertWithSuperView:(UIView * _Nullable)superView {
    if (!superView) {
        superView = [UIApplication sharedApplication].keyWindow;
    }
    
    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[WGBCommonAlertSheetView class]]) {
            ///FIXME:- 2019/11/22 16:06 防止点击过快(光速QA/单身30年的手速)同一个弹窗重复弹出的现象
            return;
        }
    }

    [superView addSubview: self];
    [self moveToSuperviewAction];
}

- (void)moveToSuperviewAction{
    CGRect rect = self.containerView.frame;
    CGFloat containerHeight = rect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.alpha = 1.0;
        self.containerView.frame = CGRectMake(0, KHIGHT - containerHeight , KWIDTH, containerHeight);
    } completion:^(BOOL finished) {
        !self.showCompletionBlock? : self.showCompletionBlock();
    }];
}

- (void)dismiss{
    CGRect rect = self.containerView.frame;
    CGFloat containerHeight = rect.size.height;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.01];
    [UIView animateWithDuration:0.25 animations:^{
        self.containerView.frame = CGRectMake(0, KHIGHT, KWIDTH, containerHeight);
    } completion:^(BOOL finished) {
        self.containerView.alpha = 0.01;
        [self removeFromSuperview];
        !self.dismissCompletionBlock? : self.dismissCompletionBlock();
    }];
}


// touchDismiss = YES 点击容器以外的视图区域将dismiss
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect bounds = self.containerView.bounds;
    CGRect rect = [self.containerView convertRect:bounds toView:self];
    if (!CGRectContainsPoint(rect,point) && self.touchDismiss) {
        [self dismiss];
    }
}

///MARK: - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.panGesture) {
        UIView *touchView = touch.view;
        while (touchView != nil) {
            if ([touchView isKindOfClass:[UIScrollView class]]) { 
                self.scrollView = (UIScrollView *)touchView;
                self.isDragScrollView = YES;
                break;
            }else if (touchView == self.containerView) {
                self.isDragScrollView = NO;
                break;
            }
            touchView = (UIView *)[touchView nextResponder];
        }
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.tapGesture) {
        CGPoint point = [gestureRecognizer locationInView:self.containerView];
        if ([self.containerView.layer containsPoint:point] && gestureRecognizer.view == self) {
            return NO;
        }
    }else if (gestureRecognizer == self.panGesture) {
        return YES;
    }
    return YES;
}

// 是否与其他手势共存
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.panGesture) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
                // 防止 iOS 9 系统中，手势冲突
                UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
                if (scrollView.contentOffset.y > 0) {
                    return NO;
                }
                
                return YES;
            }
        }
    }
    return NO;
}

///MARK: - HandleGesture
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.containerView];
    if (![self.containerView.layer containsPoint:point] && tapGesture.view == self && self.touchDismiss) {
        [self dismiss];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self.containerView];
    if (self.isDragScrollView) {
        // 当UIScrollView在最顶部时，处理视图的滑动
        if (self.scrollView.contentOffset.y <= 0) {
            if (translation.y > 0) { // 向下拖拽
                self.scrollView.contentOffset = CGPointZero;
                self.scrollView.panGestureRecognizer.enabled = NO;
                self.isDragScrollView = NO;
                
                CGRect contentFrame = self.containerView.frame;
                contentFrame.origin.y += translation.y;
                self.containerView.frame = contentFrame;
            }
        }
    }else {
        CGFloat contentM = (self.frame.size.height - self.containerView.frame.size.height);
        
        if (translation.y > 0) { // 向下拖拽
            CGRect contentFrame = self.containerView.frame;
            contentFrame.origin.y += translation.y;
            self.containerView.frame = contentFrame;
        }else if (translation.y < 0 && self.containerView.frame.origin.y > contentM) { // 向上拖拽
            CGRect contentFrame = self.containerView.frame;
            contentFrame.origin.y = MAX((self.containerView.frame.origin.y + translation.y), contentM);
            self.containerView.frame = contentFrame;
        }
    }
    
    [panGesture setTranslation:CGPointZero inView:self.containerView];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [panGesture velocityInView:self.containerView];
        
        self.scrollView.panGestureRecognizer.enabled = YES;
        
        // 结束时的速度>0 滑动距离> 5 且UIScrollView滑动到最顶部
        if (velocity.y > 0 && self.lastTransitionY > 5 && !self.isDragScrollView) {
            [self dismiss];
        }else {
            [self moveToSuperviewAction];
        }
    }
    
    self.lastTransitionY = translation.y;
}

///MARK:- Lazy load
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        _tapGesture.delegate = self;
    }
    return _tapGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _panGesture.delegate = self;
    }
    return _panGesture;
}

@end
