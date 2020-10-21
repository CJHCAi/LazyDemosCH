//
//  UIView+ViewDesc.m
//  AVPlayerViewControllerTest
//
//  Created by tanzhiwu on 2018/12/29.
//  Copyright © 2018 tanzhiwu. All rights reserved.
//

#import "UIView+ViewDesc.h"

@implementation UIView (ViewDesc)

- (UIView *)findViewByClassName:(NSString *)className
{
    UIView *view;
    if ([NSStringFromClass(self.class) isEqualToString:className]) {
        return self;
    } else {
        for (UIView *child in self.subviews) {
            view = [child findViewByClassName:className];
            if (view != nil) break;
        }
    }
    return view;
}

- (BOOL)isHairScreen
{
    if (__IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_11_0) {
        return false;
    }
    CGFloat iPhoneNotchDirectionSafeAreaInsets = 0;
    UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:{
            iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.top;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.left;
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.right;
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:{
            iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.bottom;
        }
            break;
        default:
            iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.top;
            break;
    }
    return iPhoneNotchDirectionSafeAreaInsets > 20;
}
@end
