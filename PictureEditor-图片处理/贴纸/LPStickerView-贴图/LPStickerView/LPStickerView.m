//
//  LPStickerView.m
//  LPStickerView
//
//  Created by 罗平 on 2017/6/14.
//  Copyright © 2017年 罗平. All rights reserved.
//

#import "LPStickerView.h"

#import <math.h>

#define kButtonWH (20)

NSString * const LPStickerInfoCentreXName = @"LPStickerInfoCentreXName";
NSString * const LPStickerInfoCentreYName = @"LPStickerInfoCentreYName";
NSString * const LPStickerInfoScaleName   = @"LPStickerInfoScaleName";
NSString * const LPStickerInfoAngleName   = @"LPStickerInfoAngleName";

@interface LPStickerView () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIPanGestureRecognizer *singlePanGuesture;
@property (nonatomic, weak) UIPinchGestureRecognizer *pinchGestureRecognizer;

@property (nonatomic, weak) UIImageView *deleteImageView;
@property (nonatomic, weak) UIImageView *transformImageView;

@property (nonatomic, assign) CGPoint transformPrePoint;
@property (nonatomic, assign) CGFloat defaultAngle;
@property (nonatomic, assign) CGPoint startTouchPoint;

@property (nonatomic, assign) CGFloat originWidth;

@property (nonatomic, assign) CGFloat maxScaleWidth;
@property (nonatomic, assign) CGFloat minScaleWidth;
@property (nonatomic, assign) CGFloat maxScaleHeight;
@property (nonatomic, assign) CGFloat minScaleHeight;

@end

@implementation LPStickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self base_setUpInit];
    }
    return self;
}

- (void)base_setUpInit {
    
    _lp_isTransfromResponse = YES;
    self.lp_maxScaleRadio = 3;
    self.lp_minScaleRadio = 0.5;
    self.lp_borderColor = [UIColor redColor];
    self.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizerToView:self];
    
    UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
    _lp_contentView = contentView;
    contentView.backgroundColor = [UIColor  clearColor];
    [self addSubview:contentView];
    self.lp_contentView.layer.borderColor = self.lp_borderColor.CGColor;
    self.lp_contentView.layer.borderWidth = 1;
    
    UIImageView *deleteImageView = [[UIImageView alloc] init];
    deleteImageView.userInteractionEnabled = YES;
    deleteImageView.contentMode = UIViewContentModeScaleAspectFit;
    _deleteImageView = deleteImageView;
    [self addSubview:deleteImageView];
    deleteImageView.image = [UIImage imageNamed:@""];
    [deleteImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteClick)]];
    
    UIImageView *transformImageView = [[UIImageView alloc] init];
    transformImageView.contentMode = UIViewContentModeScaleAspectFit;
    transformImageView.userInteractionEnabled = YES;
    _transformImageView = transformImageView;
    [self addSubview:transformImageView];
    transformImageView.image = [UIImage imageNamed:@""];
    UIPanGestureRecognizer *singlePanGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(transformPanGes:)];
    _singlePanGuesture = singlePanGuesture;
    [transformImageView addGestureRecognizer:singlePanGuesture];
    
    self.lp_isTransfromResponse = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lp_contentView.frame = self.bounds;
    self.deleteImageView.frame = CGRectMake(-kButtonWH * 0.5, -kButtonWH * 0.5, kButtonWH, kButtonWH);
    self.transformImageView.frame = CGRectMake(self.bounds.size.width - kButtonWH * 0.5, self.bounds.size.height - kButtonWH * 0.5, kButtonWH, kButtonWH);
}

- (void)didMoveToWindow {
    self.originWidth = self.bounds.size.width;
    self.deleteImageView.image = self.lp_deleteImage;
    self.transformImageView.image = self.lp_transfromImage;
    self.defaultAngle = atan2(self.frame.origin.y + self.frame.size.height - self.center.y,
                              self.frame.origin.x + self.frame.size.width - self.center.x);
    self.maxScaleWidth = self.bounds.size.width * self.lp_maxScaleRadio;
    self.minScaleWidth = self.bounds.size.width * self.lp_minScaleRadio;
    self.maxScaleHeight = self.bounds.size.height * self.lp_maxScaleRadio;
    self.minScaleHeight = self.bounds.size.height * self.lp_minScaleRadio;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    self.lp_isTransfromResponse = NO;
    if ([self.transformImageView pointInside:[self.transformImageView convertPoint:point fromView:self.transformImageView.superview] withEvent:event]) {
        self.lp_isTransfromResponse = YES;
        return self.transformImageView;
    }
    if ([self.deleteImageView pointInside:[self.deleteImageView convertPoint:point fromView:self.deleteImageView.superview] withEvent:event]) {
        self.lp_isTransfromResponse = YES;
        return self.deleteImageView;
    }
    if ([self pointInside:point withEvent:event]) {
        self.lp_isTransfromResponse = YES;
        return self;
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - public method

#pragma mark - private method

- (void)setAnchorPoint:(CGPoint)anchorPoint withView:(UIView *)view {
    
    CGPoint oldOrigin = self.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = self.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (self.center.x - transition.x, self.center.y - transition.y);
}

- (CGFloat)calcutePointDistance:(CGPoint)aPoint toPoint:(CGPoint)bPoint {
    return sqrt((aPoint.x - bPoint.x) * (aPoint.x - bPoint.x) + (aPoint.y - bPoint.y) * (aPoint.y - bPoint.y));
}

// 添加所有的手势
- (void)addGestureRecognizerToView:(UIView *)view {
    
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    rotationGestureRecognizer.delegate = self;
    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    _pinchGestureRecognizer = pinchGestureRecognizer;
    pinchGestureRecognizer.delegate = self;
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    panGestureRecognizer.delegate = self;
    [view addGestureRecognizer:panGestureRecognizer];
}

- (void)dealStickerInfo {
    CGFloat centreX = self.center.x;
    CGFloat centreY = self.center.y;
    CGFloat scale = self.bounds.size.width / self.originWidth;
    CGFloat radius = atan2f(self.transform.b, self.transform.a);
    CGFloat angle = radius * (180 / M_PI);
    if (angle < 0) {
        angle = angle + 360;
    }
    NSDictionary *dict = @{
                           LPStickerInfoCentreXName : @(centreX),
                           LPStickerInfoCentreYName : @(centreY),
                           LPStickerInfoScaleName   : @(scale),
                           LPStickerInfoAngleName   : @(angle),
                           };
    if (self.stickerInfoChangeBlock) {
        self.stickerInfoChangeBlock(dict);
    }
}

#pragma mark - event

- (void)deleteClick {
    [self removeFromSuperview];
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

// 处理旋转手势
- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
    
    if (!self.lp_isTransfromResponse) return;
    if (self.singlePanGuesture.state != UIGestureRecognizerStatePossible) return;
    
    UIView *view = rotationGestureRecognizer.view;
    UIGestureRecognizerState guestState = rotationGestureRecognizer.state;
    
    if (guestState == UIGestureRecognizerStateBegan || guestState == UIGestureRecognizerStateChanged) {
        
        if (guestState == UIGestureRecognizerStateBegan) {
            CGPoint onoPoint = [rotationGestureRecognizer locationOfTouch:0 inView:view];
            CGPoint twoPoint = [rotationGestureRecognizer locationOfTouch:1 inView:view];
            
            CGPoint anchorPoint;
            anchorPoint.x = (onoPoint.x + twoPoint.x) / 2 / view.bounds.size.width;
            anchorPoint.y = (onoPoint.y + twoPoint.y) / 2 / view.bounds.size.height;
            [self setAnchorPoint:anchorPoint withView:self];
        }
        
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
        
    } else if (guestState == UIGestureRecognizerStateEnded) {
        
        if (self.pinchGestureRecognizer.state != UIGestureRecognizerStateEnded) {
            [self setAnchorPoint:CGPointMake(0.5, 0.5) withView:self];
        }
    }
    [self dealStickerInfo];
}

// 处理缩放手势
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    
    if (!self.lp_isTransfromResponse) return;
    if (self.singlePanGuesture.state != UIGestureRecognizerStatePossible) return;
    
    UIView *view = pinchGestureRecognizer.view;
    UIGestureRecognizerState guestState = pinchGestureRecognizer.state;
    
    if (guestState == UIGestureRecognizerStateBegan || guestState == UIGestureRecognizerStateChanged) {
        
        if (guestState == UIGestureRecognizerStateBegan) {
            CGPoint onoPoint = [pinchGestureRecognizer locationOfTouch:0 inView:view];
            CGPoint twoPoint = [pinchGestureRecognizer locationOfTouch:1 inView:view];
            
            CGPoint anchorPoint;
            anchorPoint.x = (onoPoint.x + twoPoint.x) / 2 / view.bounds.size.width;
            anchorPoint.y = (onoPoint.y + twoPoint.y) / 2 / view.bounds.size.height;
            [self setAnchorPoint:anchorPoint withView:self];
        }
        
        //设置缩放限制
        CGFloat finalWidth  = self.bounds.size.width * pinchGestureRecognizer.scale;
        CGFloat finalHeight = self.bounds.size.height * pinchGestureRecognizer.scale;
        
        if (finalWidth < self.minScaleWidth || finalHeight < self.minScaleHeight) {
            finalWidth = self.minScaleWidth;
            finalHeight = self.minScaleHeight;
        } else if (finalWidth > self.maxScaleWidth || finalHeight > self.maxScaleHeight) {
            finalWidth = self.maxScaleWidth;
            finalHeight = self.maxScaleHeight;
        }
        
        view.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, finalWidth, finalHeight);
        self.deleteImageView.frame = CGRectMake(-kButtonWH * 0.5, -kButtonWH * 0.5, kButtonWH, kButtonWH);
        self.transformImageView.frame = CGRectMake(self.bounds.size.width - kButtonWH * 0.5, self.bounds.size.height - kButtonWH * 0.5, kButtonWH, kButtonWH);
        
        pinchGestureRecognizer.scale = 1;
        
    } else if (guestState == UIGestureRecognizerStateEnded) {
        [self setAnchorPoint:CGPointMake(0.5, 0.5) withView:self];
    }
    [self dealStickerInfo];
}

// 处理拖拉手势
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    if (!self.lp_isTransfromResponse) return;
    if (self.singlePanGuesture.state != UIGestureRecognizerStatePossible) return;
    
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        CGPoint newCenter = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
        if ([self.superview pointInside:newCenter withEvent:nil]) {
            self.center = newCenter;
        }
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    [self dealStickerInfo];
}

//处理单指 手势
- (void)transformPanGes:(UIPanGestureRecognizer *)recognizer {
    
    if (!self.lp_isTransfromResponse) return;
    
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        
        self.transformPrePoint = [recognizer locationInView:self.superview];
        
    } else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        
        //位移
        CGPoint point = [recognizer locationInView:self.superview];
        
        CGFloat preDistance = [self calcutePointDistance:self.transformPrePoint toPoint:self.center];
        CGFloat nowDistance = [self calcutePointDistance:point toPoint:self.center];
        CGFloat changeScale = nowDistance / preDistance;
        
        CGFloat finalWidth  = self.bounds.size.width * changeScale ;
        CGFloat finalHeight = self.bounds.size.height * changeScale;
        
        //缩放比例控制
        if (finalWidth < self.minScaleWidth || finalHeight < self.minScaleHeight) {
            finalWidth = self.minScaleWidth;
            finalHeight = self.minScaleHeight;
        } else if (finalWidth > self.maxScaleWidth || finalHeight > self.maxScaleHeight) {
            finalWidth = self.maxScaleWidth;
            finalHeight = self.maxScaleHeight;
        }
        
        //设置frame
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, finalWidth, finalHeight);
        self.deleteImageView.frame = CGRectMake(-kButtonWH * 0.5, -kButtonWH * 0.5, kButtonWH, kButtonWH);
        self.transformImageView.frame = CGRectMake(self.bounds.size.width - kButtonWH * 0.5, self.bounds.size.height - kButtonWH * 0.5, kButtonWH, kButtonWH);
        
        //旋转
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x);
        
        float angleDiff = self.defaultAngle - ang;
        self.transform = CGAffineTransformMakeRotation(-angleDiff);
    }
    self.transformPrePoint = [recognizer locationInView:self.superview];
    [self dealStickerInfo];
}

#pragma mark - getter & setter

- (void)setLp_isTransfromResponse:(BOOL)lp_isTransfromResponse {
    if (lp_isTransfromResponse == _lp_isTransfromResponse) return;
    _lp_isTransfromResponse = lp_isTransfromResponse;
    
    if (lp_isTransfromResponse) {
        
        [self.superview bringSubviewToFront:self];
        
        self.lp_contentView.layer.borderWidth = 1;
        self.deleteImageView.hidden = NO;
        self.transformImageView.hidden = NO;
        
    } else {
        
        self.lp_contentView.layer.borderWidth = 0;
        self.deleteImageView.hidden = YES;
        self.transformImageView.hidden = YES;
    }
}

- (void)setLp_borderColor:(UIColor *)lp_borderColor {
    _lp_borderColor = lp_borderColor;
    
    self.lp_contentView.layer.borderColor = lp_borderColor.CGColor;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer != self.singlePanGuesture) {
        if (self.singlePanGuesture.state != UIGestureRecognizerStatePossible) return NO;
    }
    return self.lp_isTransfromResponse;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

