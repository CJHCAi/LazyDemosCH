//
//  FollowerCell.m
//  StepUp
//
//  Created by syfll on 15/6/13.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "FollowerCell.h"

@implementation FollowerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //取消这行的选中效果
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGRect Rect = self.frame;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapRound);  //边缘样式
    CGContextSetLineWidth(ctx, 0.5); //线宽
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetRGBStrokeColor(ctx, 0/255.0 , 0/255.0 , 0/255.0 , 1);//颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(ctx , Rect.size.width/2, (self.frame.size.height / 10)*3 );//起点坐标
    CGContextAddLineToPoint(ctx, Rect.size.width/2, (self.frame.size.height / 10)*7);//终点坐标
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextStrokePath(ctx);
}

@end
