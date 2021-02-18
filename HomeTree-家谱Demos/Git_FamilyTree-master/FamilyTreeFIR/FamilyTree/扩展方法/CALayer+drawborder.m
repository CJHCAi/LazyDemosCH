//
//  CALayer+drawborder.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/4.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CALayer+drawborder.h"

@implementation CALayer (drawborder)
//画底部实线(灰色)
+(void)drawBottomBorder:(UIView *)drawObject{
    CALayer *border = [CALayer layer];
    float height=drawObject.frame.size.height;
    float width=drawObject.frame.size.width;
    border.frame = CGRectMake(5.0f, height, width, 1.0f);
    border.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1].CGColor;
    [drawObject.layer addSublayer:border];
}

+(void)drawTopBorder:(UIView *)drawObject{
    CALayer *border = [CALayer layer];
    float width=drawObject.frame.size.width;
    border.frame = CGRectMake(0.0f, 1.0f, width, 1.0f);
    border.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1].CGColor;
    [drawObject.layer addSublayer:border];
}

+(void)drawLeftBorder:(UIView *)drawObject{
    CALayer *border = [CALayer layer];
    float height=drawObject.frame.size.height;
    border.frame = CGRectMake(1.0f, 0.0f, 1.0f, height);
    border.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1].CGColor;
    [drawObject.layer addSublayer:border];
}

+(void)drawRightBorder:(UIView *)drawObject{
    CALayer *borer = [CALayer layer];
    float height=drawObject.frame.size.height;
    float width=drawObject.frame.size.width-1.0f;
    borer.frame = CGRectMake(width, 0.0f, 1.0f, height);
    borer.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1].CGColor;
    [drawObject.layer addSublayer:borer];
}

+(void)drawBottomDashBorder:(UIView *)drawObject{
       

}

@end
