//
//  UIViewController+SFTrainsitionExtension.m
//  SFTrainsitionDemo
//
//  Created by sfgod on 16/5/14.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import "UIViewController+SFTrainsitionExtension.h"
#import <objc/runtime.h>

@implementation UIViewController(SFTrainsitionExtension)

- (CGFloat)sf_targetHeight{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSf_targetHeight:(CGFloat)sf_targetHeight{
    objc_setAssociatedObject(self, @selector(sf_targetHeight), @(sf_targetHeight), OBJC_ASSOCIATION_RETAIN);
}

- (void)setSf_targetView:(UIView *)sf_targetView{
    objc_setAssociatedObject(self, @selector(sf_targetView), sf_targetView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)sf_targetView{
    return objc_getAssociatedObject(self, _cmd);
}

@end
