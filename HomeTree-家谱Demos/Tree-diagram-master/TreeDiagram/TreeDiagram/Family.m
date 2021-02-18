//
//  Family.m
//  hire
//
//  Created by William on 16/6/16.
//  Copyright © 2016年 William. All rights reserved.
//

#import "Family.h"
#import "FamilyModel.h"

@interface Family()

@property (nonatomic,strong) NSMutableArray *firstAry;

@end

@implementation Family



- (void)drawRect:(CGRect)rect {
    
    _firstAry = [NSMutableArray array];
    [[UIColor whiteColor] set];
    CGContextRef ref = UIGraphicsGetCurrentContext();
    //设置段落样式为居中;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    //绘画文字需要的一些属性
    NSDictionary *AttributeDic = @{
                                   NSFontAttributeName:[UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName:[UIColor whiteColor],
                                   NSParagraphStyleAttributeName:paragraph
                                   };
    for (int i = 0; i < _modelAry.count; i++)
    {
        FamilyModel *model = _modelAry[i];
        //设置四个属性,让xy随着宽高自适应,我们只需要对宽高进行赋值操作即可
        float width = 60;
        float height = 25;
        float x = 115+width*i;
        float y = 15;
        CGRect leftRect = CGRectMake(x+width*(i+1), y, width, height);
        //画一个矩形
        CGContextAddRect(ref, leftRect);
        //画一些文字在矩形中
        [model.name drawInRect:leftRect withAttributes:AttributeDic];
        if (i>0 && ((FamilyModel *)_modelAry[i-1]).sunModel == model.sunModel)
        {
            //画一条线连接两个矩形
            CGContextMoveToPoint(ref, x+width*i, y+height/2);
            CGContextAddLineToPoint(ref, x+width*(i+1), y+height/2);
            //画一条向下的直线
            CGContextMoveToPoint(ref, x+width * (i+0.5), y+height/2);
            CGContextAddLineToPoint(ref, x+width * (i+0.5), y+1.5*height);
            
            CGRect sunRect = CGRectMake(x+width*i, y+1.5*height, width, height);
            CGContextAddRect(ref, sunRect);
            [model.sunModel.name drawInRect:sunRect withAttributes:AttributeDic];
            model.sunModel.frame = sunRect;
            [_firstAry addObject:model.sunModel];
        }
    }
    
    [self drawLoop:ref AttributeDic:AttributeDic];
    
    CGContextStrokePath(ref);
}

//创建一个递归循环判断画图
- (void)drawLoop:(CGContextRef )ref AttributeDic:(NSDictionary *)AttributeDic
{
    NSArray *modelAry = [self drawPeople:ref AttributeDic:AttributeDic];
    _firstAry = [modelAry mutableCopy];
    if (_firstAry.count>0)
    {
        [self drawLoop:ref AttributeDic:AttributeDic];
    }
}


//和最上面的方法可以优化一下的
- (NSArray *)drawPeople:(CGContextRef )ref AttributeDic:(NSDictionary *)AttributeDic
{
    NSMutableArray *modelAry = [NSMutableArray array];
    for (int i = 0; i < _firstAry.count; i++)
    {
        FamilyModel *model = _firstAry[i];
        float width = model.frame.size.width;
        float height = model.frame.size.height;
        float x = model.frame.origin.x;
        float y = model.frame.origin.y;
        if (i>0 && ((FamilyModel *)_firstAry[i-1]).sunModel.name == model.sunModel.name)
        {
            FamilyModel *lastModel = _firstAry[i-1];
            //画一条线连接两个矩形
            CGContextMoveToPoint(ref, lastModel.frame.origin.x+width, y+height/2);
            CGContextAddLineToPoint(ref, x, y+height/2);
            //画一条向下的直线
            float lineX = (CGRectGetMaxX(lastModel.frame) +model.frame.origin.x)/2;
            CGContextMoveToPoint(ref, lineX, y+height/2);
            CGContextAddLineToPoint(ref, lineX, y+1.5*height);
            
            CGRect sunRect = CGRectMake(lineX - 0.5*width, y+1.5*height, width, height);
            CGContextAddRect(ref, sunRect);
            [model.sunModel.name drawInRect:sunRect withAttributes:AttributeDic];
            model.sunModel.frame = sunRect;
            [modelAry addObject:model.sunModel];
        }
    }
    return modelAry;
}

#pragma mark - 此方法绘制简单图形,如果没有CG基础建议打开注释先熟悉函数
/*
- (void)drawTwoPeople:(CGContextRef )ref
{
    for (int i = 0; i < 3; i++)
    {
        //设置四个属性,让xy随着宽高自适应,我们只需要对宽高进行赋值操作即可
        float width = 60;
        float height = 25;
        float x = 115+width*i;
        float y = 15+i*(height/2+25);
        CGRect leftRect = CGRectMake(x, y, width, height);
        CGRect rightRect = CGRectMake(x+width*2, y, width, height);
        //设置段落样式为居中;
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentCenter;
        //绘画文字需要的一些属性
        NSDictionary *AttributeDic = @{
                                       NSFontAttributeName:[UIFont systemFontOfSize:14],
                                       NSForegroundColorAttributeName:[UIColor whiteColor],
                                       NSParagraphStyleAttributeName:paragraph
                                       };
        //画一个矩形
        CGContextAddRect(ref, leftRect);
        //画一些文字在矩形中
        [@"man" drawInRect:leftRect withAttributes:AttributeDic];
        if (i != 2)
        {
            //画一个矩形
            CGContextAddRect(ref, rightRect);
            //画一些文字在矩形中
            [@"woman" drawInRect:rightRect withAttributes:AttributeDic];
            //画一条线连接两个矩形
            CGContextMoveToPoint(ref, x+width, y+height/2);
            CGContextAddLineToPoint(ref, x+width*2, y+height/2);
            //画一条向下的直线
            CGContextMoveToPoint(ref, x+width*1.5, y+height/2);
            CGContextAddLineToPoint(ref, x+width*1.5, y+height/2+height);
        }
        
    }
}
*/
@end
