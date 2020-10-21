//
//  UIScrollView+XLZoomHeader.m
//  XLZoomHeaderDemo
//
//  Created by MengXianLiang on 2018/8/3.
//  Copyright © 2018年 mxl. All rights reserved.
//

#import "UIScrollView+XLZoomHeader.h"
#import "XLZoomHeader.h"
#import <objc/runtime.h>

static NSString *XLZoomHeaderKey = @"XLZoomHeaderKey";

@implementation UIScrollView (XLZoomHeader)

- (void)setXl_zoomHeader:(XLZoomHeader *)xl_zoomHeader {
    if (xl_zoomHeader != self.xl_zoomHeader) {
        [self.xl_zoomHeader removeFromSuperview];
        [self insertSubview:xl_zoomHeader atIndex:0];
        objc_setAssociatedObject(self, &XLZoomHeaderKey,
                                 xl_zoomHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (XLZoomHeader *)xl_zoomHeader {
    return objc_getAssociatedObject(self, &XLZoomHeaderKey);
}

@end
