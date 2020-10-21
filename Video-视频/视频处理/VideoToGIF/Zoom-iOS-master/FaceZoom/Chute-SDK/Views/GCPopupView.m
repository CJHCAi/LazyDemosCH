//
//  GCPopupView2.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 4/8/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCPopupView.h"
#import "KXDataEncoder.h"
#import <QuartzCore/QuartzCore.h>

static float const kScaleFactor = 0.85;//0.91;
static float const kSpacingSize = 15.0;

static int const kBorderWidth = 2;
static int const kCornerRadius = 8;
static float const kShadowOpacity = 0.75;
static int const kShadowRadius = 16;

static float const kShowAnimationDuration = 0.25;
static float const kBounceAnimationDuration = 0.075;
static float const kHideAnimationDuration = 0.2;

static CGPoint startPoint;
static CGPoint endPoint;

@interface GCPopupView () {
    UIView *_parentView;
    CGAffineTransform rotationTransform;
        
}

@end

@implementation GCPopupView

- (id)initWithFrame:(CGRect)frame inParentView:(UIView *)parentView
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _parentView = parentView;
        
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[self closeImage] forState:UIControlStateNormal];
        [closeButton setFrame:[self contentViewFrame]];
        [closeButton addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
        
        contentView = [[UIView alloc] initWithFrame:[self contentViewFrame]];
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.autoresizesSubviews = YES;
        
        contentView.layer.cornerRadius = kCornerRadius;
        contentView.layer.borderWidth = kBorderWidth;
        contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        contentView.clipsToBounds = YES;
        
        [self setShadow];
        [self  registerForNotifications];
        
        [self addSubview:contentView];
        [self addSubview:closeButton];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
        
	if (_parentView) {
		self.frame = _parentView.bounds;
	}
	CGRect bounds = self.bounds;
    
    [self setFrame:[GCPopupView popupFrameForView:_parentView withStartPoint:CGPointZero]];
    [closeButton setFrame:[self closeButtonFrame]];
    [contentView setFrame:[self contentViewFrame]];
    
    [self setShadow];
}

- (CGRect)closeButtonFrame {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return CGRectMake(0.0, kSpacingSize, kSpacingSize * 2, kSpacingSize * 2);
    }
    return CGRectMake(0.0, 0.0, kSpacingSize * 2, kSpacingSize * 2);
}

- (CGRect)contentViewFrame {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return CGRectMake(0.0, kSpacingSize, self.bounds.size.width, self.bounds.size.height - kSpacingSize * 2);
    }
    return CGRectMake(kSpacingSize, kSpacingSize, self.bounds.size.width - kSpacingSize * 2.0, self.bounds.size.height - kSpacingSize * 2.0);
}

+ (CGRect)popupFrameForView:(UIView *)_view withStartPoint:(CGPoint)_startPoint {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return  CGRectMake(0.0, 0.0, _view.bounds.size.width, _view.bounds.size.height);
    }
    
    startPoint = _startPoint;
    endPoint = _view.layer.position;
    
    float factorWidth = kScaleFactor * _view.bounds.size.width;
    float factorHeight = kScaleFactor * _view.bounds.size.height;
    float factorX = (_view.bounds.size.width - factorWidth) / 2.0;
    float factorY = (_view.bounds.size.height - factorHeight) / 2.0;
    
    return CGRectMake(factorX, factorY, factorWidth, factorHeight);
    
}

+ (void)show
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [self showInView:window fromStartPoint:window.layer.position];
}

+ (void)showInView:(UIView *)view {
    [self showInView:view fromStartPoint:view.layer.position];
}

+ (void)showInView:(UIView *)_view fromStartPoint:(CGPoint)_startPoint {
    
    CGRect popupFrame = [self popupFrameForView:_view withStartPoint:_startPoint];
    
    GCPopupView *popup = [[self alloc] initWithFrame:popupFrame inParentView:_view];
    
    [_view addSubview:popup];
    
    [popup showPopupWithCompletition:^{
        
    }];
    
}

#pragma mark - Util Method

- (void)setShadow {
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = kShadowOpacity;
    self.layer.shadowRadius = kShadowRadius;
    [self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
}

- (UIImage *)closeImage {
    NSString *strClose = @"iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAIGNIUk0AAG11AABzoAAA/N0AAINkAABw6AAA7GgAADA+AAAQkOTsmeoAAAKaSURBVHja7JvdkYIwEIC3BDogHZAS6EBLsAPp4Owk6QQ6wA60A0rIvSQzN56M7E82MIaZfThHI9/nQXY3AUII8M0BVUAVUAVUAf9elD8aADgBwA8AOAAYY8wx0t8uvucUPyN6aAswEWYGgECMOY5hjiSgj79mEI4xjr1bAbnAxUTkEtDEazcoh8PeJ3IIsADwKACf4hHPoYiAS0Hw17hoC7juCD7FVUvAsEP4FENuAZcdw3+8HLgC7AHgU1hpAQ32bt+2rRgQYazHuymSI8BjTsA5F5ZlCV3XseG7rgvLsgTnHPazXkpAj4VPB1dCgk8HQUIvIWCkwHMlvMITJYxcAT0HniphDZ4ooecIGLnwWAmf4AkSRqoAs+ULjDGbTniLhK3waSxjzFYJhiLgtvXfzFrLloCFt9aiM0SsAFQnhyMhM3zqLKEENJRpiyJBAT5FgxFwps7dWAlK8AEAeoyAGyd7w0hQgg8AcMMI8NwUVkqCEHwAAI8RMEkUMVwJgvABACZ1ARwJwvBoAbNkfY6VkAEeLeAu+eWYqU6iitzVJYCFzyhBXwAVPpOESXUa5MJnkODVEiEpeGEJN5VUGJvbS5XS0qlwowFvrRUppXMUQ+ipkFPVKUi4Z22ISJS0mSUM2VpibduKlbRYCYgFE0Ntik6STdEt6e1WCYim6LSLtjgmt/8kQbMtjsoK1xZGKIXNmgQk/FR8aYxT1b1KKLU0Rl4clShpk4SSi6MpMXpiTgCxaJFjrKf08vjXb5CoW2QOsknqorVNbjgafN0omXGr7LMg+LPkVtm/U6QvAO/3sFn6NWOcFMCnvW2X1xJBBi/5yMzAXGS5xzEO9cjM2n3iHLtMPv6a78LH95yLPjRVnxusAqqAKuBb4ncAsh90jpSnoDoAAAAASUVORK5CYII=";
    
    return [UIImage imageWithData:[KXDataEncoder dataWithBase64EncodedString:strClose]];
}

#pragma mark - Actions

- (void)closePopup {
    [self closePopupWithCompletition:nil];
}

- (void)showPopupWithCompletition:(void (^)(void))completition {
    
    [self setTransform:CGAffineTransformMakeScale(0.001, 0.001)];
    [self setAlpha:0.001];
    [self.layer setPosition:startPoint];
    
    [UIView animateWithDuration:kShowAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [[self layer] setPosition:endPoint];
        [self setAlpha:1.0];
        [self setTransform:CGAffineTransformIdentity];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kBounceAnimationDuration delay:0.0 options:(UIViewAnimationOptionAutoreverse|UIViewAnimationCurveEaseOut) animations:^{
            [self setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
        } completion:^(BOOL finished) {
            completition();
            [self setTransformForCurrentOrientation:YES];
        }];
    }];
}

- (void)closePopupWithCompletition:(void (^)(void))completition {
    
    [UIView animateWithDuration:kHideAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.layer setPosition:startPoint];
        [self setAlpha:0.001];
        [self setTransform:CGAffineTransformMakeScale(0.001, 0.001)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self unregisterFromNotifications];
        if (completition)
            completition();
    }];
}
#pragma mark - Notifications

- (void)registerForNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(deviceOrientationDidChange:)
			   name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterFromNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
	UIView *superview = self.superview;
	if (!superview) {
		return;
	} else if ([superview isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:YES];
	} else {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
	// Stay in sync with the superview
	if (self.superview) {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat radians = 0;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -(CGFloat)M_PI_2; }
		else { radians = (CGFloat)M_PI_2; }
		
        // Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);

	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = (CGFloat)M_PI; }
		else { radians = 0; }
	}
	rotationTransform = CGAffineTransformMakeRotation(radians);
    
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}

@end
