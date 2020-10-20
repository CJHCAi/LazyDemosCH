//
//  APXSemiModelView.m
//  ZhongHeBao
//
//  Created by yangyang on 2016/12/23.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "APXSemiModelView.h"

@interface APXSemiModelView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIControl *closeControl;
@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation APXSemiModelView

- (instancetype)initWithContentView:(UIView *)contentView viewController:(UIViewController *)viewController
{
    if (self = [super init]) {
        
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView = contentView;
        self.contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.contentView.height);
        
        [self addSubview:self.maskView];
        [self addSubview:self.closeControl];
        [self addSubview:self.contentView];
        
        if (viewController) {
            self.viewController = viewController;
        }
    }
    return self;
}

- (UIView*)topView
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return  [window.subviews firstObject];
}

- (void)show
{
    self.viewController.navigationController.view.backgroundColor = [UIColor blackColor];
    
    [[self topView] addSubview:self];
    self.closeControl.userInteractionEnabled = NO;

    CALayer *viewLayer = self.viewController.view.layer;
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = -0.004;
    
    [UIView animateWithDuration:0.6f animations:^{
        self.maskView.alpha = 0.5;
        self.contentView.frame = CGRectMake(0,
                                            [[UIScreen mainScreen] bounds].size.height - self.contentView.bounds.size.height,
                                            self.contentView.frame.size.width,
                                            self.contentView.frame.size.height);
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        viewLayer.transform = CATransform3DRotate(transform3D, 4*M_PI/180.0, 1, 0, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            viewLayer.transform = CATransform3DMakeScale(0.9, 0.93, 1);
            self.closeControl.userInteractionEnabled = YES;
        }];
    }];
}

- (void)dismiss
{
    self.closeControl.userInteractionEnabled = NO;

    CALayer *viewLayer = self.viewController.view.layer;
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = -0.004;
    
    [UIView animateWithDuration:0.3f animations:^{
        viewLayer.transform = CATransform3DRotate(transform3D, 4*M_PI/180.0, 1, 0, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            viewLayer.transform = CATransform3DMakeScale(1, 1, 1);
        }];
    }];
    
    [UIView animateWithDuration:0.6f animations:^{
        self.maskView.alpha = 0;
        self.contentView.frame = CGRectMake(0,
                                            self.frame.size.height,
                                            self.contentView.frame.size.width,
                                            self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeAllSubviews];
        [self removeFromSuperview];
        self.viewController.navigationController.view.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)dismissSemiModelView
{
    [self dismiss];
}

#pragma mark - getters and setters

- (UIControl *)closeControl
{
    if (!_closeControl) {
        _closeControl = [[UIControl alloc] initWithFrame:self.bounds];
        _closeControl.userInteractionEnabled = NO;
        _closeControl.backgroundColor = [UIColor clearColor];
        [_closeControl addTarget:self action:@selector(dismissSemiModelView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeControl;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0;
    }
    return _maskView;
}

@end
