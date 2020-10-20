//
//  ToViewTest.m
//  HighWay
//
//  Created by SunLi on 16/7/2.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "ToViewTest.h"

@interface ToViewTest()

@property(nonatomic, assign)BOOL isClicked;
@end

@implementation ToViewTest

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor colorWithRed:57.f/255 green:203.f/255 blue:126.f/255 alpha:1.0];
        CGFloat height = self.bounds.size.width;
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = height/2;
        self.layer.borderWidth= 0.5f;
        self.layer.borderColor=[[UIColor clearColor] CGColor];
        self.layer.masksToBounds = YES;//设为NO去试试
    }
    return self;
}

//重新绘制
- (void)resizeViewStyle{
    
}

- (void)layoutSubviews{
    
}

- (void)drawRect:(CGRect)rect
{
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_isRolling){  //滚动中
        //对齐方式行高等
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *dic = @{
                              NSFontAttributeName : [UIFont fontWithName:@"Arial" size:14.0f],
                              NSForegroundColorAttributeName:[UIColor whiteColor],
                              NSParagraphStyleAttributeName : paragraphStyle
                              };
        CGRect currRect = CGRectMake(0, height/2-18, width, height/2);
        [_currValue drawInRect:currRect withAttributes:dic];
        
        //指定直线样式
        CGContextSetLineCap(context, kCGLineCapRound);
        //直线宽度
        CGContextSetLineWidth(context,1.0);
        //设置颜色
        CGContextSetRGBStrokeColor(context,255.f/255, 255.f/255, 255.f/255, 1.0);
        //开始绘制
        CGContextBeginPath(context);
        
        //画笔移动到点
        CGContextMoveToPoint(context, 10, height/2);
        //下一点
        CGContextAddLineToPoint(context, width-10, height/2);
        //绘制完成
        CGContextStrokePath(context);
        
        CGRect totalRect = CGRectMake(0, height/2, width, height/2);
        [_totalValue drawInRect:totalRect withAttributes:dic];
    }else{
        //指定直线样式
        CGContextSetLineCap(context, kCGLineCapRound);
        //直线宽度
        CGContextSetLineWidth(context,1.0);
        //设置颜色
        CGContextSetRGBStrokeColor(context,255.f/255, 255.f/255, 255.f/255, 1.0);
        //开始绘制
        CGContextBeginPath(context);
        //画笔移动到点
        CGContextMoveToPoint(context, 12, height/5);
        //下一点
        CGContextAddLineToPoint(context, width-12, height/5);
        //绘制完成
        CGContextStrokePath(context);
        
        //开始绘制中线
        CGContextBeginPath(context);
        //画笔移动到点
        CGContextMoveToPoint(context, width/2, height/5+2);
        //下一点
        CGContextAddLineToPoint(context,width/2, height*4/5);
        //绘制完成
        CGContextStrokePath(context);
        
        //开始绘制左边线
        CGContextBeginPath(context);
        //画笔移动到点
        CGContextMoveToPoint(context, width/2, height/5+2);
        //下一点
        CGContextAddLineToPoint(context,width/2-10, height/5+15);
        //绘制完成
        CGContextStrokePath(context);
        
        //开始绘制右线
        CGContextBeginPath(context);
        //画笔移动到点
        CGContextMoveToPoint(context, width/2, height/5+2);
        //下一点
        CGContextAddLineToPoint(context,width/2+10, height/5+15);
        //绘制完成
        CGContextStrokePath(context);
    }
}

@end
