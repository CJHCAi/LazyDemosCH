//
//  SNHThumbView.m
//  SNHThumbView
//
//  Created by 黄淑妮 on 2017/6/15.
//  Copyright © 2017年 Mirco. All rights reserved.
//

#import "SNHThumbView.h"

@interface SNHThumbView()

@property (nonatomic) BOOL isRight;
@property (strong, nonatomic) UIImage *thumbImage;

@end

@implementation SNHThumbView

- (instancetype)initWithFrame:(CGRect)frame
{
    NSAssert(NO, nil);
    @throw nil;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [super initWithCoder:aDecoder];
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color right:(BOOL)flag
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = color;
        _isRight = flag;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame thumbImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.thumbImage = image;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    CGRect relativeFrame = self.bounds;
//    UIEdgeInsets hitTestEdgeInsets = UIEdgeInsetsMake(0, -30, 0, -30);
//    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets);
//    return CGRectContainsPoint(hitFrame, point);
//}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    if (self.thumbImage) {
        [self.thumbImage drawInRect:rect];
    } else {
        //// Frames
        CGRect bubbleFrame = self.bounds;
        
        //// Rounded Rectangle Drawing
        CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(bubbleFrame), CGRectGetMinY(bubbleFrame), CGRectGetWidth(bubbleFrame), CGRectGetHeight(bubbleFrame));
        UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: CGSizeMake(3, 3)];
        if (self.isRight) {
            roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: CGSizeMake(3, 3)];
        }
        [roundedRectanglePath closePath];
        [self.color setFill];
        [roundedRectanglePath fill];
        
        
        CGRect decoratingRect = CGRectMake(CGRectGetMinX(bubbleFrame)+CGRectGetWidth(bubbleFrame)/2.5, CGRectGetMinY(bubbleFrame)+CGRectGetHeight(bubbleFrame)/4, 1.5, CGRectGetHeight(bubbleFrame)/2);
        UIBezierPath *decoratingPath = [UIBezierPath bezierPathWithRoundedRect:decoratingRect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii: CGSizeMake(1, 1)];
        [decoratingPath closePath];
        [[UIColor colorWithWhite:1 alpha:0.5] setFill];
        [decoratingPath fill];

    }
}


@end
