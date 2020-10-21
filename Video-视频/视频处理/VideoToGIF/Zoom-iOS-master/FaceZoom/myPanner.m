//
//  myPanner.m
//  FaceZoom
//
//  Created by Ben Taylor on 5/18/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myPanner.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation myPanner

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    // touchPoint is defined as: @property (assign,nonatomic) CGPoint touchPoint;
    
    self->originPosition = [touch locationInView:nil];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:nil];
    
    // customize the pan distance threshold
    
    CGFloat dx = fabs(p.x-self->originPosition.x);
    CGFloat dy = fabs(p.y-self->originPosition.y);
    
    if ( dx > 2 || dy > 2)  {
        if (self.state == UIGestureRecognizerStatePossible) {
            [self setState:UIGestureRecognizerStateBegan];
        }
        else {
            [self setState:UIGestureRecognizerStateChanged];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (self.state == UIGestureRecognizerStateChanged) {
        [self setState:UIGestureRecognizerStateEnded];
    }
    else {
        [self setState:UIGestureRecognizerStateCancelled];
    }
}

- (void) reset
{
}

// this returns the original touch point

- (CGPoint) touchPointInView:(UIView *)view
{
    CGPoint p = [view convertPoint:self->originPosition fromView:nil];
    
    return p;
}

- (void) incrementOrigin:(CGPoint *)incrementPoint;
{
    self->originPosition.x = incrementPoint->x+self->originPosition.x;
    self->originPosition.y = incrementPoint->y+self->originPosition.y;
}


@end