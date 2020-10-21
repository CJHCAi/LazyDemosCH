//
//  UINavigationBar+transparency.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/23.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "UINavigationBar+transparency.h"

@implementation UINavigationBar (transparency)


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (UIView *view in self.subviews) {
            NSLog(@"viewName: %@", view);
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                NSLog(@"remove");
                [view removeFromSuperview];
            }
        }
    }
    return self;
}

@end
