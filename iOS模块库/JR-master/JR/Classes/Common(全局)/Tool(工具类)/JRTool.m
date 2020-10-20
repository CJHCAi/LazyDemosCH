//
//  JRTool.m
//  JR
//
//  Created by Zj on 17/8/20.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "JRTool.h"

@implementation JRTool

+ (void)shadow:(CALayer *)layer{
    layer.shadowColor = JRHexColor(0x73e0da).CGColor;
    layer.shadowOpacity = 0.1;
    layer.shadowOffset = CGSizeMake(0, 3);
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
}

@end
