//
//  DrawView.m
//  drawBoard
//
//  Created by hyrMac on 15/8/7.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "DrawView.h"
#import "PathModal.h"

@implementation DrawView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _pathModalArray = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        
        self.color = [UIColor blackColor];
        self.width = 5.0;
        
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    for (PathModal *modal in _pathModalArray) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [modal.color setStroke];
        CGContextSetLineWidth(context, modal.width);
        
        CGContextAddPath(context, modal.path);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    if (_path != nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [self.color setStroke];
        CGContextSetLineWidth(context, self.width);
        
        CGContextAddPath(context, _path);
        CGContextDrawPath(context, kCGPathStroke);
    }
   
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _path = CGPathCreateMutable();
    
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    CGPathMoveToPoint(_path, NULL, p.x, p.y);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    CGPathAddLineToPoint(_path, NULL, p.x, p.y);
    
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    PathModal *modal = [[PathModal alloc] init];
    modal.color = self.color;
    modal.width = self.width;
    modal.path = _path;
    [_pathModalArray addObject:modal];
    
    CGPathRelease(_path);
    _path = nil;
    
}


- (void)backAction {
    [_pathModalArray removeLastObject];
    [self setNeedsDisplay];
}

- (void)clearAction {
    [_pathModalArray removeAllObjects];
    [self setNeedsDisplay];
}




@end
