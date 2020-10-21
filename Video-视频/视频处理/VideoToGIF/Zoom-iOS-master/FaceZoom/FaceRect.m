//
//  FaceRect.m
//  FaceView
//
//  Created by Bharath Kumar Devaraj on 7/31/13.
//  Copyright (c) 2013 Bharath Kumar Devaraj. All rights reserved.
//

#import "FaceRect.h"


#pragma mark ControlPointView implementation

@implementation ControlPointView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.color = [UIColor colorWithRed:16.0/255.0 green:173.0/255.0 blue:251.0/255.0 alpha:1];
        self.opaque = YES;
    }
    return self;
}

- (void)setColor:(UIColor *)_color {
    [_color getRed:&red green:&green blue:&blue alpha:&alpha];
    [self setNeedsDisplay];
}

- (UIColor*)color {
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    CGContextFillEllipseInRect(context, rect);
}

@end


@implementation FaceRect
//@synthesize myView;
//@synthesize myPoint;
static CGFloat const DEFAULT_CONTROL_POINT_SIZE = 8;

CGRect SquareCGRectAtCenter(CGFloat centerX, CGFloat centerY, CGFloat size) {
    CGFloat x = centerX - size / 2.0;
    CGFloat y = centerY - size / 2.0;
    return CGRectMake(x, y, size, size);
}

- (ControlPointView*)createControlPointAt:(CGRect)frame {
    ControlPointView* point = [[ControlPointView alloc] initWithFrame:frame];
    return point;
}


CGFloat kResizeThumbSize = 60.0f;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code    [UIImage imageNamed:@"my-asset-name.png"]

        self.layer.cornerRadius = 5;

        
        //self->myPoint = [self createControlPointAt:SquareCGRectAtCenter(0 , 0, DEFAULT_CONTROL_POINT_SIZE)];
        //[self addSubview:myPoint];
        
        myView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 14, 14)];
        myView.image = [UIImage imageNamed:@"resize"];
        [self addSubview:myView];
        self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.25];
        //self.layer.opacity = 0.1;
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    touchStart = [[touches anyObject] locationInView:self];
    isResizingLR = (self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize);
    
    NSLog(@"this x: %f, and this y: %f", touchStart.x, touchStart.y);
    
    
    isResizingUR = (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize);
    isResizingLL = (touchStart.x <kResizeThumbSize && self.bounds.size.height -touchStart.y <kResizeThumbSize);
    
   // isResizingUL = (touchStart.x <kResizeThumbSize && touchStart.y <kResizeThumbSize);
    isResizingUL = (fabs(touchStart.x) < 20 && fabs(touchStart.y) < 20);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGPoint previous = [[touches anyObject] previousLocationInView:self];
    
    CGFloat totalWidth = touchPoint.x - touchStart.x;
    CGFloat totalHeight = touchPoint.y - touchStart.y;
    
    CGFloat deltaWidth = touchPoint.x - previous.x;
    CGFloat deltaHeight = touchPoint.y - previous.y;
    
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (isResizingUL) {
    //if (CGRectContainsPoint(myView.frame, touchPoint)){
        if ( (width-deltaWidth - x -deltaWidth) > (height-deltaHeight - y - deltaHeight) ){
            self.frame = CGRectMake(x+deltaWidth, y+deltaWidth, width-deltaWidth, height-deltaWidth);
        } else if ( (width-deltaWidth - x -deltaWidth) < (height-deltaHeight - y - deltaHeight) ){
            self.frame = CGRectMake(x+deltaHeight, y+deltaHeight, width-deltaHeight, height-deltaHeight);
        } else {
            self.frame = CGRectMake(x+deltaWidth, y+deltaHeight, width-deltaWidth, height-deltaHeight);
        }
    }
    
    else {
        self.center = CGPointMake(self.center.x + touchPoint.x - touchStart.x, self.center.y + touchPoint.y - touchStart.y);
    }
    
}



@end
