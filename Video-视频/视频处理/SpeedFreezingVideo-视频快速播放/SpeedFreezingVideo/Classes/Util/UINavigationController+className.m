//
//  UINavigationController+className.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/19.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "UINavigationController+className.h"
#import <objc/runtime.h>

@implementation UINavigationController (className)


//+ (void)load {
//    [self swizzleMethod:@selector(pushViewController:animated:) anotherMethod:@selector(zy_pushViewController:animated:)];
//}

- (void)zy_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    NSLog(@"zy_push class:%@", [viewController class]);
    [self zy_pushViewController:viewController animated:animated];
}

+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oneMethod = class_getInstanceMethod(self, oneSel);
        Method anotherMethod = class_getInstanceMethod(self, anotherSel);
        
        method_exchangeImplementations(oneMethod, anotherMethod);
    });
}

@end
