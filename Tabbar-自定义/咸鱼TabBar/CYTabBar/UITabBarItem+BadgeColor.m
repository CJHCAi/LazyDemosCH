//
//  UITabBarItem+BadgeColor.m
//  CYTabBarDemo
//
//  Created by 张 春雨 on 7/27/17.
//  Copyright © 2017 张春雨. All rights reserved.
//

#import "UITabBarItem+BadgeColor.h"

static const char itemBadgeColor_Key;

@implementation UITabBarItem (BadgeColor)
@dynamic badgeColor;


- (void)setBadgeColor:(UIColor *)badgeColor {
    [self willChangeValueForKey:@"badgeColor"];
    objc_setAssociatedObject(self, &itemBadgeColor_Key, badgeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"badgeColor"];
}

- (UIColor *)badgeColor {
    return objc_getAssociatedObject(self, &itemBadgeColor_Key);
}

@end
