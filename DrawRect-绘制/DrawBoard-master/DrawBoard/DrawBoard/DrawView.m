//
//  DrawView.m
//  DrawBoard
//
//  Created by 弄潮者 on 15/8/7.
//  Copyright (c) 2015年 弄潮者. All rights reserved.
//

#import "DrawView.h"
#import "PathModal.h"

@implementation DrawView

/**
 *  画板实现的基本思路:1、当touchesBegan时，创建路径，并将该点作为路径的起始点；
                    2、当touchesMove时，不断在该路径上添加line，调用[self setNeedsDisplay]
                    3、当touchesEnd时，将path作为modal的一个成员变量保存在modal中，此次的modal放在PathModalArray中，释放路径
                    4、drawRect绘制路径时，不仅要画这次的路径，还要画之前的路径，就是遍历pathModalArray来调用
                    5、撤销动作undoAction，即移除pathModalArray中的最后一个object，并且调用[self setNeedsDisplay]
                    6、清屏动作clearAction，即移除pathModalArray中的所有object，并且调用[self setNeedsDisplay]
 */

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        pathModalArray = [NSMutableArray array];
        self.lineColor = [UIColor blackColor];
        self.lineWidth = 8.0;
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    for (PathModal *modal in pathModalArray) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [modal.color setStroke];
        CGContextSetLineWidth(context, modal.width);
        CGContextAddPath(context, modal.path);
        
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    if (path != nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextAddPath(context, path);
        
        [self.lineColor setStroke];
        CGContextSetLineWidth(context, self.lineWidth);
        
        CGContextDrawPath(context, kCGPathStroke);
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, p.x, p.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    //点加至线上
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    //移动->重新绘图
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    PathModal *modal = [[PathModal alloc] init];
    modal.color = self.lineColor;
    modal.width = self.lineWidth;
    modal.path = path;
    
    [pathModalArray addObject:modal];
    CGPathRelease(path);
    path = nil;
}

- (void)undoAction {
    [pathModalArray removeLastObject];
    [self setNeedsDisplay];
}

- (void)clearAction {
    [pathModalArray removeAllObjects];
    [self setNeedsDisplay];
}

@end
