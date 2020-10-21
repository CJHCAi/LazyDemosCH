//
//  WZToast.m


#import "WZToast.h"

@implementation WZToast

+ (void)toastWithContent:(NSString *)content {
    [WZToast toastWithContent:content position:WZToastPositionTypeMiddle];
}

+ (void)toastWithContent:(NSString *)content duration:(NSTimeInterval)duration {
    [WZToast toastWithContent:content position:WZToastPositionTypeMiddle duration:duration];
}

+ (void)toastWithContent:(NSString *)content position:(WZToastPositionType)position {
    [WZToast toastWithContent:content position:position duration:1.5];
}

+ (void)toastWithContent:(NSString *)content
                        position:(WZToastPositionType)position
                        duration:(NSTimeInterval)duration {
    [WZToast toastWithContent:content position:position duration:duration customOriginY:false customOriginYMake:0 customOrigin:false customOriginMake:CGPointZero];
}

+ (void)toastWithContent:(NSString *)content
                        position:(WZToastPositionType)position
                        customOriginY:(CGFloat)customOriginY {
    [WZToast toastWithContent:content position:position duration:1.5 customOriginY:true customOriginYMake:customOriginY customOrigin:false customOriginMake:CGPointZero];
}

+ (void)toastWithContent:(NSString *)content
                        position:(WZToastPositionType)position
                   customOrigin:(CGPoint)customOrigin {
    [WZToast toastWithContent:content position:position duration:1.5 customOriginY:false customOriginYMake:0 customOrigin:true customOriginMake:customOrigin];
}

+ (void)toastWithContent:(NSString *)content
                        position:(WZToastPositionType)position
                        duration:(NSTimeInterval)duration
                   customOriginY:(BOOL)customOriginY
                   customOriginYMake:(CGFloat)customOriginYMake
                    customOrigin:(BOOL)customOrigin
                    customOriginMake:(CGPoint)customOriginMake
                            {
    WZToast *toastView = [[WZToast alloc] init];
    toastView.alpha = 0.0;
    toastView.layer.cornerRadius = 10.0;
    toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
   
    //structure layout
    if ([content isKindOfClass:[NSString class]] && ![content isEqualToString:@""]) {
     
        UILabel *toastLabel = [[UILabel alloc] init];
        toastLabel.textColor = [UIColor whiteColor];
        toastLabel.backgroundColor = [UIColor clearColor];
        toastLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        toastLabel.text = content;
        toastLabel.textAlignment = NSTextAlignmentCenter;
        toastLabel.numberOfLines = 0;
        UIWindow *forefrontWindow = [WZToast getFrontWindow];
        [toastView addSubview:toastLabel];
        [forefrontWindow addSubview:toastView];
        
        
        //structure detail
        CGFloat labelLRSpacingSum = 30;
        CGFloat labelTBSpacingSum = 30;
        CGFloat labelH = [toastLabel sizeThatFits:CGSizeZero].height + 30;
        CGFloat labelW = [toastLabel sizeThatFits:CGSizeZero].width;
        CGFloat boundingSpacing = 40.0;
        
        CGFloat toastRestrictW = [UIScreen mainScreen].bounds.size.width - boundingSpacing * 2.0;
        
        if (labelW > toastRestrictW) {
            CGFloat calculatelabelW = toastRestrictW - labelLRSpacingSum;
            labelH = [toastLabel sizeThatFits:CGSizeMake(calculatelabelW - labelLRSpacingSum, 0)].height
            + labelTBSpacingSum
            - 4.0;
            labelW = [toastLabel sizeThatFits:CGSizeMake(calculatelabelW - labelLRSpacingSum, 0)].width;
        }
        toastLabel.frame = CGRectMake(labelLRSpacingSum / 2.0
                                      , 0.0
                                      , labelW
                                      , labelH);
        CGFloat toastW = labelW + labelLRSpacingSum;
        CGFloat toastH = labelH;
        CGFloat toastX = ([UIScreen mainScreen].bounds.size.width - toastW) / 2.0;
        CGFloat toastY = ([UIScreen mainScreen].bounds.size.height - toastH) / 2.0;
        
        //Y坐标的计算
        switch (position) {
                break;
            case WZToastPositionTypeTop:
            {
                toastY = 100.0;
            }
                break;
                
            case WZToastPositionTypeBottom:
            {
                toastY = [UIScreen mainScreen].bounds.size.height - toastH - 100.0;
            }
                break;
            default/*WZToastPositionTypeMiddle*/:
                break;
        }
        
        
        if (customOriginY) {
            toastY = customOriginYMake;
        }
        
        if (customOrigin) {
            toastX = customOriginMake.x;
            toastY = customOriginMake.y;
        }
        
        // style normal middle
        toastView.frame = CGRectMake(toastX
                                     ,toastY
                                     , toastW
                                     , toastH);
        
        //part of effect
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            toastView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.8 delay:0.5 + 0.25 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                toastView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [toastView removeFromSuperview];
            }];
        }];
    }
}

+ (UIWindow *)getFrontWindow {
    UIWindow *frontWindow = nil;
    NSEnumerator *frontToBackWindows = [[UIApplication sharedApplication].windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL isWindowOnMainScreen = (window.screen == [UIScreen mainScreen]);       //当前屏幕
        BOOL isWindowVisible = (!window.hidden && window.alpha > 0.001);            //透明度
        BOOL isWindowNormalLevel = (window.windowLevel == UIWindowLevelNormal);     //
        if (isWindowOnMainScreen && isWindowVisible && isWindowNormalLevel) {
            frontWindow = window;
        }
    }
    
    if (!frontWindow) {
        frontWindow = [UIApplication sharedApplication].windows.lastObject;
    }
    
    return frontWindow;
}

@end
