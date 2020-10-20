//
//  SFTrainsitionAnimate.m
//  CameraDemo
//
//  Created by apple on 2017/6/28.
//  Copyright © 2017年 yangchao. All rights reserved.
//

#import "SFTrainsitionAnimate.h"

@implementation SFTrainsitionAnimate

- (instancetype)init{
    return [self initWithAnimateType:animate_push andDuration:1.5f];
}

- (instancetype)initWithAnimateType:(Animate_Type)type andDuration:(CGFloat)dura{
    if (self = [super init]) {
        _type = type;
        _duration = dura;
    }
    return self;
}

- (CGFloat)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return _duration;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    if (self.type == animate_push) {
        [self pushAnimateWithanimateTransition:transitionContext];
    }else{
        [self popAnimateWithanimateTransition:transitionContext];
    }
}

- (void)pushAnimateWithanimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //起始位置
    CGRect originFrame = [fromVC.sf_targetView convertRect:fromVC.sf_targetView.bounds toView:fromVC.view];
    //动画移动的视图镜像
    UIView *customView = [self customSnapshoFromView:fromVC.sf_targetView];
    customView.frame = originFrame;
//
//    UIImageView * imageView=fromVC.sf_targetImageView;
//    imageView.image=fromVC.sf_targetImageView.image;
//    imageView.frame=originFrame;
    
    //移动的目标位置
    CGRect finishFrame = [toVC.sf_targetView convertRect:toVC.sf_targetView.bounds toView:toVC.view];
    
    UIView *containView = [transitionContext containerView];
    
    //背景视图 灰色高度
    CGFloat height = CGRectGetMidY(finishFrame);
    toVC.sf_targetHeight = height;
    
//    //背景视图 灰色
//    UIView *backgray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
//    backgray.backgroundColor = [UIColor lightGrayColor];
//    //背景视图  白色
//    UIView *backwhite = [[UIView alloc] initWithFrame:CGRectMake(0, height, SCREENWIDTH, SCREENHEIGHT-height)];
//    backwhite.backgroundColor = [UIColor whiteColor];
    
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    [containView addSubview:toVC.view];
    //    [containView addSubview:backgray];
    //    [backgray addSubview:backwhite];
    [containView addSubview:customView];
//    [containView addSubview:imageView];
    
    
    [UIView animateWithDuration:1.0 animations:^{
        
        customView.frame = finishFrame;
        
    } completion:^(BOOL finished) {
        if (finished) {
        
            [customView removeFromSuperview];
            [transitionContext completeTransition:YES];
            
        }
    }];
}
- (void)popAnimateWithanimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //起始位置
    CGRect originFrame = [fromVC.sf_targetView convertRect:fromVC.sf_targetView.bounds toView:fromVC.view];
    
    //动画移动的视图镜像
    UIView *customView = [self customSnapshoFromView:fromVC.sf_targetView];
    customView.frame = originFrame;
    
    //移动的目标位置
    CGRect finishFrame = [toVC.sf_targetView convertRect:toVC.sf_targetView.bounds toView:toVC.view];
    
    UIView *containView = [transitionContext containerView];
    
    //背景视图 灰色
    UIView *backgray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backgray.backgroundColor = [UIColor lightGrayColor];
    //背景视图 白色
    UIView *backwhite = [[UIView alloc] initWithFrame:CGRectMake(0, fromVC.sf_targetHeight, SCREENWIDTH, SCREENHEIGHT-fromVC.sf_targetHeight)];
    backwhite.backgroundColor = [UIColor whiteColor];
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    [containView addSubview:toVC.view];
    [containView addSubview:fromVC.view];
    [containView addSubview:backgray];
    [backgray addSubview:backwhite];
    [containView addSubview:customView];
    
    [self addPathAnimateWithView:backgray fromPoint:customView.center];
    
    [UIView animateWithDuration:_duration/3 delay:_duration/3 options:UIViewAnimationOptionTransitionNone animations:^{
        customView.frame = finishFrame;
        customView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [fromVC.view removeFromSuperview];
            
            [UIView animateWithDuration:_duration/3 animations:^{
                backgray.alpha = 0.0;
                customView.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                if (finished) {
                    [backgray removeFromSuperview];
                    [customView removeFromSuperview];
                    [transitionContext completeTransition:YES];
                }
            }];
        }
    }];
}

//加入收合动画
- (void)addPathAnimateWithView:(UIView *)toView fromPoint:(CGPoint)point{
    //create path
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    //create path
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:0.1 startAngle:0 endAngle:2*M_PI clockwise:NO]];
    
    CGFloat radius = point.y > 0?SCREENHEIGHT*3/4: SCREENHEIGHT*3/4-point.y;
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [path2 appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:0 endAngle:2*M_PI clockwise:NO]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //shapeLayer.path = path.CGPath;
    toView.layer.mask = shapeLayer;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = _type == animate_push? (__bridge id)path.CGPath:(__bridge id)path2.CGPath;
    pathAnimation.toValue   = _type == animate_push? (__bridge id)path2.CGPath:(__bridge id)path.CGPath;
    pathAnimation.duration  = 9/3;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [shapeLayer addAnimation:pathAnimation forKey:@"pathAnimate"];
}

//产生targetView镜像
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}


@end
