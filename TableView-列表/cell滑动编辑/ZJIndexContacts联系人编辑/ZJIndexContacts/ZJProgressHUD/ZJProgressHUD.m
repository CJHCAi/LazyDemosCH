//
//  ZJProgressHUDView.m
//  ZJProgressHUD
//
//  Created by ZeroJ on 16/9/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJProgressHUD.h"
#import "ZJPrivateHUDProtocol.h"
#import "ZJTextOnlyHUDView.h"
#import "ZJImageOnlyHUDView.h"
#import "ZJTextAndImageHUDView.h"
#import "ZJProgressHUDView.h"

@interface ZJProgressHUD ()

@end

@implementation ZJProgressHUD (Public)

+ (void)showProgressWithStatus:(NSString *)status {
    ZJProgressHUD *hudView = [ZJProgressHUD sharedInstance];
    ZJProgressHUDView *progressView = [[ZJProgressHUDView alloc] init];
    [progressView setText:status];
    [hudView setHudView:progressView];
    [hudView showWithTime:0.0f];
    [progressView startAnimation];

}

+ (void)showProgress {
    [ZJProgressHUD showProgressWithStatus:nil];
}
+ (void)showStatus:(NSString *)status andAutoHideAfterTime:(CGFloat)showTime {
    
    ZJProgressHUD *hudView = [ZJProgressHUD sharedInstance];
    ZJTextOnlyHUDView *textView = [[ZJTextOnlyHUDView alloc] init];
    
    textView.text = status;
    [hudView setHudView:textView];
    [hudView showWithTime:showTime];
    
}

+ (void)showStatus:(NSString *)status {
    [ZJProgressHUD showStatus:status andAutoHideAfterTime:0.0f];
}


+ (void)showImage:(UIImage *)image withStatus:(NSString *)status andAutoHideAfterTime:(CGFloat)showTime {
    ZJProgressHUD *hudView = [ZJProgressHUD sharedInstance];
    ZJTextAndImageHUDView *textAndImageView = [[ZJTextAndImageHUDView alloc] init];
    [textAndImageView setText:status andImage:image];
    [hudView setHudView:textAndImageView];
    [hudView showWithTime:showTime];
}

+ (void)showSuccessWithStatus:(NSString *)status andAutoHideAfterTime:(CGFloat)showTime {
    UIImage *image = [UIImage imageNamed:@"success"];
    [ZJProgressHUD showImage:image withStatus:status andAutoHideAfterTime:showTime];
}

+ (void)showSuccessWithStatus:(NSString *)status {
    [ZJProgressHUD showSuccessWithStatus:status andAutoHideAfterTime:0.0f];
}


+ (void)showSuccessAndAutoHideAfterTime:(CGFloat)showTime {
    UIImage *image = [UIImage imageNamed:@"success"];
    [ZJProgressHUD showImage:image andAutoHideAfterTime:showTime];
}

+ (void)showSuccess {
    [ZJProgressHUD showSuccessAndAutoHideAfterTime:0.0f];
}

+ (void)showErrorWithStatus:(NSString *)status andAutoHideAfterTime:(CGFloat)showTime {
    UIImage *image = [UIImage imageNamed:@"error"];
    [ZJProgressHUD showImage:image withStatus:status andAutoHideAfterTime:showTime];
}

+ (void)showErrorWithStatus:(NSString *)status {
    [ZJProgressHUD showErrorWithStatus:status andAutoHideAfterTime:0.0f];
}

+ (void)showErrorAndAutoHideAfterTime:(CGFloat)showTime {
    UIImage *image = [UIImage imageNamed:@"error"];
    [ZJProgressHUD showImage:image andAutoHideAfterTime:showTime];
}

+ (void)showError {
    [ZJProgressHUD showErrorAndAutoHideAfterTime:0.0f];
}


+ (void)hideHUD {
    [[ZJProgressHUD sharedInstance] hide];
    
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    if (window) {
//        NSEnumerator *reveseSubviews = [window.subviews reverseObjectEnumerator];
//        
//        for (UIView *subview in reveseSubviews) {
//            if ([subview isKindOfClass:[ZJProgressHUD class]]) {
//                [subview removeFromSuperview];
//                break;
//            }
//        }
//    }
}

+ (void)hideAllHUDs {
    [[ZJProgressHUD sharedInstance] hideAllHUDs];
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    if (window) {
//        for (UIView *subview in window.subviews) {
//            if ([subview isKindOfClass:[ZJProgressHUD class]]) {
//                [subview removeFromSuperview];
//            }
//        }
//    }
}

+ (void)showCustomHUD:(UIView *)hudView andAutoHideAfterTime:(CGFloat)showTime {
    
    [[ZJProgressHUD sharedInstance] setHudView:hudView];
    [[ZJProgressHUD sharedInstance] showWithTime:showTime];
}

+ (void)showCustomHUD:(UIView *)hudView {
    [ZJProgressHUD showCustomHUD:hudView andAutoHideAfterTime:0.0f];
}

+ (void)showImage:(UIImage *)image andAutoHideAfterTime:(CGFloat)showTime {
    ZJProgressHUD *hudView = [ZJProgressHUD sharedInstance];
    ZJImageOnlyHUDView *imageView = [[ZJImageOnlyHUDView alloc] init];
    imageView.image = image;
    [hudView setHudView:imageView];
    [hudView showWithTime:showTime];
}



@end


@implementation ZJProgressHUD


+ (instancetype)sharedInstance {
    static ZJProgressHUD *hud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[ZJProgressHUD alloc] init];
    });
    
    return hud;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)showWithTime:(CGFloat)time {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    if (self.superview == nil) {
        [window addSubview:self];
    }
    if (time > 0) {
        __weak typeof(self) weakself = self;
        delay(time, ^{
            __strong typeof(weakself) strongSelf = weakself;
            if (strongSelf) {
                [strongSelf hide];
            }
//            [[ZJProgressHUD sharedInstance] hide];
        });
    }
}

- (void)hide {
    /// 首先移除先添加的
    UIView *firstHud = [self.subviews firstObject];
    if (firstHud) {
        [firstHud removeFromSuperview];
        if (self.subviews.count == 0) {
            [self removeFromSuperview];
        }
    }
    else {
        [self removeFromSuperview];
    }
}

- (void)hideAllHUDs {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.superview) {// superView == window
        self.frame = self.superview.bounds;
        for (UIView *subview in self.subviews) {
            if ([subview conformsToProtocol:@protocol(ZJPrivateHUDProtocol)]) {
                /// 居中显示
                subview.center = self.center;
            }
            else {
                /// 自定义的hudView
                CGRect frame = subview.frame;
                subview.frame = frame;

            }
        }
    }
}
/// 这里直接使用了GCD, 当然推荐使用NSTimer
static void delay(CGFloat time, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}


- (void)setHudView:(UIView *)hudView {
    [self addSubview:hudView];
}


@end

