//
//  UIView+ExtendTouchArea.m
//  Sport
//
//  Created by lzy on 16/8/6.
//  Copyright © 2016年 haodong . All rights reserved.
//

#import "UIView+ExtendTouchArea.h"
#import "objc/runtime.h"

@implementation UIView (ExtendTouchArea)
+ (void)load {
    [self swizzleMethod:@selector(pointInside:withEvent:) anotherMethod:@selector(zyPointInside:withEvent:)];
}

+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

- (BOOL)zyPointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.touchExtendInset, UIEdgeInsetsZero) || self.hidden ||
        ([self isKindOfClass:UIControl.class] && !((UIControl *)self).enabled)) {
        return [self zyPointInside:point withEvent:event];
    }
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.touchExtendInset);
    hitFrame.size.width = MAX(hitFrame.size.width, 0);
    hitFrame.size.height = MAX(hitFrame.size.height, 0);
    return CGRectContainsPoint(hitFrame, point);
}

- (void)setTouchExtendInset:(UIEdgeInsets)touchExtendInset {
    objc_setAssociatedObject(self, @selector(touchExtendInset), [NSValue valueWithUIEdgeInsets:touchExtendInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)touchExtendInset {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

@end
