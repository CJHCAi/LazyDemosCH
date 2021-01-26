//
//  LTSCircleView.h
//  LTSCalendar
//
//  Created by Jonathan Tribouharet
//

#import "LTSCircleView.h"

@implementation LTSCircleView

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor whiteColor];
    
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
    CGContextFillRect(ctx, rect);

    rect = CGRectInset(rect, .5, .5);
    
    CGContextSetStrokeColorWithColor(ctx, [self.color CGColor]);
    CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
    
    CGContextAddEllipseInRect(ctx, rect);
    CGContextFillEllipseInRect(ctx, rect);
    
    CGContextFillPath(ctx);
}

- (void)setColor:(UIColor *)color
{
    self->_color = color;
    
    [self setNeedsDisplay];
}

@end
