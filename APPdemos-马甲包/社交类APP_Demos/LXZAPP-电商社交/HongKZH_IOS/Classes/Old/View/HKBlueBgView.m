//
//  HKBlueBgView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBlueBgView.h"

@implementation HKBlueBgView

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, 50)];
    [path addQuadCurveToPoint:CGPointMake(kScreenWidth, 50) controlPoint:CGPointMake(kScreenWidth/2, 90)];
    [path addLineToPoint:CGPointMake(kScreenWidth, 0)];
    [path closePath];
    [UICOLOR_HEX(0xd8e9ff) set];
    [path fill];
}


@end
