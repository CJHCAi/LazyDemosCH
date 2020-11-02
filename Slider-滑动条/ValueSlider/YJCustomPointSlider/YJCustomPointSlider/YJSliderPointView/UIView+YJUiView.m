//
//  UIView+YJUiView.m
//  YJTabBarController
//
//  Created by 于英杰 on 2019/5/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "UIView+YJUiView.h"

@implementation UIView (YJUiView)
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x{
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
- (CGFloat)left
{
    return self.frame.origin.x;
}
- (CGFloat)top
{
    return self.frame.origin.y;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY
{
    return self.center.y;
}
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
- (CGFloat)width
{
    return self.frame.size.width;
}
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

-(CGFloat)boundsWidth{
    return self.bounds.size.width;
}

-(void)setBoundsWidth:(CGFloat)boundsWidth{
    CGRect bounds = self.bounds;
    bounds.size.width = boundsWidth;
    self.bounds = bounds;
}

-(CGFloat)boundsHeight{
    return self.bounds.size.height;
}

-(void)setBoundsHeight:(CGFloat)boundsHeight{
    CGRect bounds = self.bounds;
    bounds.size.height = boundsHeight;
    self.bounds = bounds;
}

- (void)setMaxX:(CGFloat)maxX{
    CGRect frame = self.frame;
    frame.origin.x = maxX - frame.size.width;
    self.frame = frame;
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY{
    CGRect frame = self.frame;
    frame.origin.y = maxY - frame.size.height;
    self.frame = frame;
}

- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

/**
 *  获取当前navigationController
 */
- (UINavigationController *)getNavigationController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
            
        }
        next = next.nextResponder;
    } while (next);
    return nil;
    
}

- (UITabBarController *)geTtabBarController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
}

- (UIViewController *)getCurrentVC{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    if ([keyWindow.rootViewController isKindOfClass:UINavigationController.class] || [keyWindow.rootViewController isKindOfClass:UITabBarController.class]) {
        return getVisibleVCWithRootVC(keyWindow.rootViewController);
    }else{
        UIViewController *VC = keyWindow.rootViewController;
        if (VC.presentedViewController) {
            if ([VC.presentedViewController isKindOfClass:UINavigationController.class]||
                [VC.presentedViewController isKindOfClass:UITabBarController.class]) {
                return getVisibleVCWithRootVC(VC.presentedViewController);
            }else{
                return VC.presentedViewController;
            }
        }
        else{
            return VC;
        }
    }
}


/**
 * 私有方法
 * rootVC必须是UINavigationController 或 UITabBarController 及其子类
 */
UIViewController * getVisibleVCWithRootVC(UIViewController *RootVC) {
    
    if ([RootVC isKindOfClass:UINavigationController.class]) {
        UINavigationController *nav = (UINavigationController *)RootVC;
        // 如果有modal view controller并且弹起的是导航控制器，返回其topViewController
        if ([nav.visibleViewController isKindOfClass:UINavigationController.class]) {
            UINavigationController *presentdNav = (UINavigationController *)nav.visibleViewController;
            return presentdNav.visibleViewController;
        }
        else if ([nav.visibleViewController isKindOfClass:UITabBarController.class]){
            return getVisibleVCWithRootVC(nav.visibleViewController);
        }
        // Return modal view controller if it exists. Otherwise the top view controller.
        else{
            return nav.visibleViewController;
        }
    }
    else if([RootVC isKindOfClass:UITabBarController.class]){
        UITabBarController *tabVC = (UITabBarController *)RootVC;
        UINavigationController *nav = (UINavigationController *)tabVC.selectedViewController;
        return getVisibleVCWithRootVC(nav);

    }else{
        return RootVC;
    }
}


@end


