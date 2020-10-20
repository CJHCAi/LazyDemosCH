//
//  ZWGraphicView.m
//  TestDemo
//
//  Created by xzw on 16/10/26.
//  Copyright © 2016年 xzw. All rights reserved.
//

#import "ZWGraphicView.h"

@implementation ZWGraphicView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _start = CGPointMake(0, 0);
        _move = CGPointMake(0, 0);
        _lineWidth = 2;
        _lineColor = [UIColor blackColor];
        _pathArray = [NSMutableArray array];
        _isDrawLine = NO;
        self.backgroundColor = [UIColor whiteColor];
    
    }
    
    return self;
}

//画图
-(void)drawRect:(CGRect)rect
{
    //获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画图
    [self drawPicture:context];
    
}

-(void)drawPicture:(CGContextRef)context
{
    
    if (_pathArray.count) {
        
        for (NSArray * attribute in _pathArray) {
            
            //将路径添加到上下文
            CGPathRef pathRef = (__bridge CGPathRef)attribute[0];
            CGContextAddPath(context, pathRef);
            
            //设置上下文属性
            [attribute[1] setStroke];//设置边框颜色
            CGContextSetLineWidth(context, [attribute[2] floatValue]);
            
            //绘制线条
            CGContextDrawPath(context, kCGPathStroke);
        }

    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    
    //创建路径
    _path = CGPathCreateMutable();
    
    NSArray * attributeArry = @[(__bridge id)(_path),_lineColor,[NSNumber numberWithFloat:_lineWidth]];
    [_pathArray addObject:attributeArry];//路径及属性数组
    
    _start = [touch locationInView:self];//起始点
    
    CGPathMoveToPoint(_path, NULL, _start.x, _start.y);//将画笔移动到某点
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPathRelease(_path);//释放路径
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _isDrawLine = YES;//确保画板不是空白
    UITouch* touch = [touches anyObject];
    _move = [touch locationInView:self];
    //将点添加到路径上
    CGPathAddLineToPoint(_path, NULL, _move.x, _move.y);
    
    [self setNeedsDisplay];//自动调用drawRect:(CGRect)rect
    
}


/**
 *  保存图像至相册
 */
-(void)savePhotoToAlbum
{
    if (_pathArray.count) {
        
        UIGraphicsBeginImageContext(self.frame.size);//创建一个基于位图的上下文，并设置当前上下文
        CGContextRef contex = UIGraphicsGetCurrentContext();//获取图形上下文
        UIRectClip(CGRectMake(0, 30, self.frame.size.width, self.frame.size.height-30));
        [self.layer renderInContext:contex];
        
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
        
    }
}

/**
 *  撤销上一次操作
 */
-(void)undoLastDraw
{
    [_pathArray removeLastObject];
    [self setNeedsDisplay];
}

/**
 *  清空画板
 */
-(void)clearDrawBoard
{
    _isDrawLine = NO;
    [_pathArray removeAllObjects];
    [self setNeedsDisplay];
}

-(UIImage *)getDrawingImg
{
    if (_isDrawLine) {
        
        if (_pathArray.count) {
            
            UIGraphicsBeginImageContext(self.frame.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            UIRectClip(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
            [self.layer renderInContext:context];
            
            UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
            return image;
            
        }
    }
    return nil;
}

@end
