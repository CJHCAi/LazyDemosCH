//
//  ScImageSlider.m
//  ScImageSlider
//
//  Created by SunChao on 15/7/16.
//  Copyright (c) 2015年 SunChao. All rights reserved.
//

#import "ScImageSlider.h"
#define BOUND(VALUE, UPPER, LOWER)	MIN(MAX(VALUE, LOWER), UPPER)

@implementation ScImageSlider
{
    UIImageView *_knobView;
    float _knobWidth;
    float _useableTrackLength;
    CGPoint _previousTouchPoint;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _maximumValue = 10.0;
        _minimumValue = 0.0;
       // _knobValue = 0.0;
        [self createTheknob];
        [self setKnodFrames];
    }
    return self;
}
#pragma mark   --------PublicMethod
-(void)createTheImageWall{
    for (int i=0; i<10; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*(self.frame.size.width/10), 5, self.frame.size.width/10, self.frame.size.height-10)];
        UIImage *image = self.imageArray[i];
        [imageView setImage:image];
        [self addSubview:imageView];
        [self sendSubviewToBack:imageView];
    }
}
-(void)updateTheKnobImage:(UIImage*)image{
    [_knobView setImage:image];
}
-(void)moveKnobWithSelectedValue:(float)value{
    [self setKnobValue:value];
    [self setKnodFrames];
}
#pragma mark  --------PrivateMethod
-(void)createTheknob{
    if (_knobView == nil) {
        _knobView = [[UIImageView alloc]init];
        _knobView.layer.borderColor = [UIColor colorWithRed:247.f/255.f green:209.f/255.f blue:36.f/255.f alpha:1.f].CGColor;
        _knobView.layer.borderWidth = 1.0;
        _knobView.backgroundColor = [UIColor clearColor];
        [self addSubview:_knobView];
        [self bringSubviewToFront:_knobView];
    }
}

- (void) setKnodFrames
{
    _knobWidth = self.bounds.size.height;
    _useableTrackLength = self.bounds.size.width - _knobWidth;
    
    float knobCentre = [self positionForValue:self.knobValue];
    _knobView.frame = CGRectMake(knobCentre - _knobWidth / 2, 0, _knobWidth, _knobWidth);
}

- (float) positionForValue:(float)value
{
    return _useableTrackLength * (value - _minimumValue) /
    (_maximumValue - _minimumValue) + (_knobWidth / 2);
}
#pragma mark -----------TouchHandle
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    _previousTouchPoint = [touch locationInView:self];
    
    return YES;
}
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    
    // 1. determine by how much the user has dragged
    float delta = touchPoint.x - _previousTouchPoint.x;
    float valueDelta = (_maximumValue - _minimumValue) * delta / _useableTrackLength;
    
    _previousTouchPoint = touchPoint;
    
    _knobValue  += valueDelta;
    _knobValue  = BOUND(_knobValue, _maximumValue, _minimumValue);
    [CATransaction begin];
    [CATransaction setDisableActions:YES] ;
    
    [self setKnodFrames];
    
    [CATransaction commit];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
}
@end
