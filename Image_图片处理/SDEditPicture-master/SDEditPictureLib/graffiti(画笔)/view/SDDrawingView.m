//
//  SDDrawingView.m
//  NestHouse
//
//  Created by shansander on 2017/5/6.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import "SDDrawingView.h"
#import "SDDrawingContentData.h"

@interface SDDrawingView ()


@end

@implementation SDDrawingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.pointList = [[NSMutableArray alloc] init];
        self.current_size = 4;
        self.current_color = [UIColor redColor];
    }
    return self;
}

- (void)setCurrent_size:(CGFloat)current_size
{
    _current_size = current_size;
}
- (void)setCurrent_color:(UIColor *)current_color
{
    if (self.isEarse) {
        _current_color = [UIColor clearColor];
    }else{
        
        _current_color = current_color;
    }
}

- (void)setIsEarse:(BOOL)isEarse{
    _isEarse = isEarse;
    
    if (self.isEarse) {
        self.previous_drawColor = self.current_color;
    }else{
        
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.drawingPath = CGPathCreateMutable();
    
    
    CGPathMoveToPoint(self.drawingPath, NULL, point.x, point.y);
    
    [self addPoint:point];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGPathAddLineToPoint(self.drawingPath, NULL, point.x, point.y);
    
    [self addPoint:point];
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    SDDrawingContentData * drawContent = [[SDDrawingContentData alloc] init];
    drawContent.drawSize = self.current_size;
    drawContent.drawColor = self.current_color;
    drawContent.path = [UIBezierPath bezierPathWithCGPath:self.drawingPath];
    drawContent.blendModel = self.isEarse ? kCGBlendModeDestinationIn : kCGBlendModeNormal;
    [self.pointList addObject:drawContent];
    
    CGPathRelease(self.drawingPath);
    
    
}

- (void)clearDrawPath
{
    if (self.pointList.count > 0) {
        self.drawingPath = CGPathCreateMutable();
//        CGPathRelease(self.drawingPath);
        
        [self.pointList removeAllObjects];
        
        [self setNeedsDisplay];
    }
  
}

- (void)addPoint:(CGPoint )point
{

    [self setNeedsDisplay];
    
    self.canreset = true;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (SDDrawingContentData * draw in self.pointList) {
        CGContextAddPath(context, draw.path.CGPath);
        CGContextSetBlendMode(context, draw.blendModel);
        [draw.drawColor set];
        CGContextSetLineWidth(context, draw.drawSize);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    
    
    
    CGContextDrawPath(context, kCGPathStroke);

    NSLog(@"%ld",self.pointList.count);
    
    if (_isEarse) {
        CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    }else{
        CGContextSetBlendMode(context, kCGBlendModeNormal);
    }
    CGContextAddPath(context, self.drawingPath);
    
    [self.current_color set];
    CGContextSetLineWidth(context, self.current_size);
    CGContextDrawPath(context, kCGPathStroke);
    
}

@end
