//
//  UIView+CCPView.m
//  CCPCalendar
//
//  Created by Ceair on 17/5/26.
//  Copyright © 2017年 ccp. All rights reserved.
//

#import "UIView+CCPView.h"

@implementation UIView (CCPView)

//得到父视图高度
- (CGFloat)getSupH {
    NSMutableArray *svHs = [NSMutableArray array];
    for (UIView *sv in self.subviews) {
        [svHs addObject:@(CGRectGetMaxY(sv.frame))];
    }
    CGFloat max = [[svHs valueForKeyPath:@"@max.doubleValue"] floatValue];
    return max;
}

/*
 * alert 弹出动画
 */
- (void)show {
    self.hidden = NO;
    self.alpha = 1.0;
    CAKeyframeAnimation *popAni = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAni.duration = .35;
    popAni.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAni.keyTimes = @[@0,@1];
    popAni.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAni forKey:@"pop"];
}

@end
