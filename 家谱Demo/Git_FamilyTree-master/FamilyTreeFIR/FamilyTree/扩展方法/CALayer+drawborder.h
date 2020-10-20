//
//  CALayer+drawborder.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/4.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (drawborder)
+(void)drawBottomBorder:(UIView *)drawObject;
+(void)drawTopBorder:(UIView *)drawObject;
+(void)drawLeftBorder:(UIView *)drawObject;
+(void)drawRightBorder:(UIView *)drawObject;
+(void)drawBottomDashBorder:(UIView *)drawObject;
@end
