//
//  UINavigationBar+H850.m
//  H850Samba
//
//  Created by zhengying on 3/24/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "UINavigationBar+SportFormu.h"

#define BG_IMG @"BG_IMG"
#define BG_TOP_BAR @"BG_IMG"


@implementation UINavigationBar (SportFormu)


- (void)customNavigationBar {
    UIImage* topBarImage = [UIImage imageNamed:BG_TOP_BAR];
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setBackgroundImage:[UIImage imageNamed:BG_IMG] forBarMetrics:UIBarMetricsDefault];
    } else {
        [self drawRect:self.bounds];
    }
    
    UIImageView *topBarImageView = [[UIImageView alloc]initWithImage:topBarImage];
    CGRect rect = topBarImageView.frame;
    topBarImageView.frame = CGRectMake(0, self.frame.size.height - rect.size.height, rect.size.width, rect.size.height);
    [self addSubview:topBarImageView];
    //[[UINavigationBar appearance] setShadowImage:[UIImage new]];
    //[self drawRoundCornerAndShadow];
}


- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:BG_IMG] drawInRect:rect];
}

- (void)drawRoundCornerAndShadow {
    CGRect bounds = self.bounds;
    bounds.size.height +=10;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [self.layer addSublayer:maskLayer];
    self.layer.mask = maskLayer;
    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

@end
