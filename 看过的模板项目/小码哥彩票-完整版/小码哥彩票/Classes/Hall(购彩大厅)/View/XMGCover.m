//
//  XMGCover.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/28.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGCover.h"

#import "XMGActiveMenu.h"


@implementation XMGCover

+ (void)show
{
    
    // 创建蒙版对象
    XMGCover *cover = [[XMGCover alloc] initWithFrame:XMGScreenBounds];
    
    cover.backgroundColor = [UIColor blackColor];
    
    cover.alpha = 0.6;
    
    
    // 把蒙版对象添加主窗口
    [XMGKeyWindow addSubview:cover];
}

+ (void)hide
{
    for (UIView *childView in XMGKeyWindow.subviews) {
        if ([childView isKindOfClass:self]) {
            [childView removeFromSuperview];
        }
    }
}

@end
