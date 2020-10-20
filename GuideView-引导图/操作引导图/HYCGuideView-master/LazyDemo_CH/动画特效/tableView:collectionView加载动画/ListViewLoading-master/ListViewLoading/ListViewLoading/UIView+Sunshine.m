//
//  UIView+Sunshine.m
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/14.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+Sunshine.h"

@interface UIView ()
@property (nonatomic, strong)UIView *animationView;
@property (nonatomic, strong)CABasicAnimation *sunshineAnimation;
@property (nonatomic, strong)CAGradientLayer *sunshineLayer;
@property (nonatomic)BOOL animationing;

//@property (nonatomic)BOOL needsAnimation;
@end

@implementation UIView (Sunshine)

- (void)beginSunshineAnimation {
//    self.needsAnimation = YES;
    if (self.sunshineViews.count > 0 && self.animationing == NO) {
        self.animationing = YES;
        for (UIView *subview in self.sunshineViews) {
            if ([subview isKindOfClass:[UIView class]] && subview.animationView.superview == nil) {
                [subview addSubview:[self animationViewForView:subview]];
                [subview.sunshineLayer addAnimation:subview.sunshineAnimation forKey:@"translate-x"];
                [subview.animationView.layer addSublayer:subview.sunshineLayer];
            }
        }
    }
    if ([NSStringFromClass(self.class) hasPrefix:@"TableSectionFooterView"]) {
        
    }
}

- (void)endSunshineAnimation {
    if (self.animationing == YES) {
        for (UIView *subview in self.sunshineViews) {
            if ([subview isKindOfClass:[UIView class]]) {
                [subview.sunshineLayer removeAnimationForKey:@"translate-x"];
                [subview.sunshineLayer removeFromSuperlayer];
                [subview.animationView removeFromSuperview];
            }
        }
        self.animationing = NO;
    }
}

- (void)setAnimationView:(UIView *)animationView {
    objc_setAssociatedObject(self, @selector(animationView), animationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)animationView {
    return objc_getAssociatedObject(self, @selector(animationView));
//    if (!view) {
//        view = [[UIView alloc] init];
//        view.translatesAutoresizingMaskIntoConstraints = NO;
//        [view.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
//        [view.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
//        [view.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
//        [view.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
////        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
//        view.backgroundColor = [UIColor colorWithWhite:245/255.0 alpha:1];
//        [self setAnimationView:view];
//    }
//    return view;
    
}

- (void)setSunshineAnimation:(CABasicAnimation *)sunshineAnimation {
     objc_setAssociatedObject(self, @selector(sunshineAnimation), sunshineAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CABasicAnimation *)sunshineAnimation {
    CABasicAnimation *animation = objc_getAssociatedObject(self, @selector(sunshineAnimation));
    if(!animation) {
        animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
        animation.fromValue = @(-150);
        animation.toValue = @([UIScreen mainScreen].bounds.size.width);
        animation.duration = [UIScreen mainScreen].bounds.size.width*0.002;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = HUGE;
        [self setSunshineAnimation:animation];
    }
    return animation;
}

- (void)setSunshineLayer:(CAGradientLayer *)sunshineLayer {
    objc_setAssociatedObject(self, @selector(sunshineLayer), sunshineLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAGradientLayer *)sunshineLayer {
    CAGradientLayer *layer = objc_getAssociatedObject(self, @selector(sunshineLayer));
    if (!layer) {
        layer = [CAGradientLayer layer];
//        layer.
        layer.frame =CGRectMake(0, 0, 150, CGRectGetHeight(self.frame));
        //这里必须是CGColor不然没有颜色，且要在前面加入__bridge id进行类型转换
        layer.colors = [NSArray arrayWithObjects:(__bridge id)[UIColor colorWithWhite:245/255.0 alpha:1].CGColor,(__bridge id)[UIColor colorWithWhite:220/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithWhite:245/255.0 alpha:1].CGColor, nil];
        layer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.1], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.9], nil];
        layer.startPoint = CGPointMake(0.0, 0);
        layer.endPoint = CGPointMake(1.0, 0.1);
//        layer.transform = CATransform3DMakeRotation((M_PI * (30) / 180.0), CGRectGetWidth(layer.frame)/2, CGRectGetHeight(layer.frame)/2, 0);
        [self setSunshineLayer:layer];
    }
    return layer;
}

- (NSArray *)sunshineViews {
    return objc_getAssociatedObject(self, @selector(sunshineViews));
}

- (void)setSunshineViews:(NSArray *)sunshineViews {
    objc_setAssociatedObject(self, @selector(sunshineViews), sunshineViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)animationing {
    return [objc_getAssociatedObject(self, @selector(animationing)) boolValue];
}

- (void)setAnimationing:(BOOL)animationing {
    objc_setAssociatedObject(self, @selector(animationing), @(animationing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//- (BOOL)needsAnimation {
//    return [objc_getAssociatedObject(self, @selector(needsAnimation)) boolValue];
//}
//
//- (void)setNeedsAnimation:(BOOL)needsAnimation {
//    objc_setAssociatedObject(self, @selector(needsAnimation), @(needsAnimation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (UIView *)animationViewForView:(UIView *)superView {
    UIView *view = objc_getAssociatedObject(self, @selector(animationView));
    if (!view) {
        view = [[UIView alloc] init];
        view.clipsToBounds = YES;
        [superView addSubview:view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [view.topAnchor constraintEqualToAnchor:superView.topAnchor].active = YES;
        [view.leadingAnchor constraintEqualToAnchor:superView.leadingAnchor].active = YES;
        [view.widthAnchor constraintEqualToAnchor:superView.widthAnchor].active = YES;
        [view.heightAnchor constraintEqualToAnchor:superView.heightAnchor].active = YES;
        //        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        view.backgroundColor = [UIColor colorWithWhite:245/255.0 alpha:1];
        [superView setAnimationView:view];
    }
    return view;
}

- (void)layoutSubviews {
    if (self.animationView) {
        [self.animationView.superview bringSubviewToFront:self.animationView];
    }
}

@end
