//
//  SpeedFreezesOperatingView.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/19.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "SpeedFreezesOperatingView.h"
#import "UIView+ExtendTouchArea.h"

const CGFloat speedSliderWidth = 17.f;
const CGFloat speedSliderHeight = 17.f;
const CGFloat speedSliderBottomSpace = 14.f;
const CGFloat speedSliderLigatureHeight = 1.f;

@interface SpeedFreezesOperatingView () <SAVideoRangeSliderDelegate>
@property (strong, nonatomic) NSURL *videoUrl;

@property (strong, nonatomic) SAVideoRangeSlider *saVideoRangeSlider;
@property (strong, nonatomic) UIImageView *ligatureImageView;
@property (strong, nonatomic) CAShapeLayer *ligatureMaskLayer;

@property (strong, nonatomic) UIImageView *leftSpeedSlider;
@property (strong, nonatomic) UIImageView *rightSpeedSlider;

@property (assign, nonatomic) CGFloat leftPositionCoordinates;//leftSpeedSliderCenterCoordinates
@property (assign, nonatomic) CGFloat rightPositionCoordinates;//rightSpeedSliderCenterCoordinates

@property (assign, nonatomic) BOOL isSpeedSliderActive;
@end

@implementation SpeedFreezesOperatingView

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl {
    self = [super initWithFrame:frame];
    if (self) {
        _videoUrl = videoUrl;
        _editingType = EditingTypeSpeed;
        [self configureView];
        [self extendTouchArea];
    }
    return self;
}

- (void)layoutSubviews {
    //更新配置水滴的位置
    self.leftSpeedSlider.center = CGPointMake(_leftPositionCoordinates, speedSliderHeight/2);
    self.rightSpeedSlider.center = CGPointMake(_rightPositionCoordinates, speedSliderHeight/2);
    //连线
    CGFloat disSpeedSlider = CGRectGetMinX(_rightSpeedSlider.frame) - CGRectGetMaxX(_leftSpeedSlider.frame);
    
    [self.ligatureMaskLayer setPath:[UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMaxX(_leftSpeedSlider.frame), 0, disSpeedSlider, speedSliderLigatureHeight)].CGPath];
}

- (void)configureView {
    CGFloat sliderWidth = self.bounds.size.width;
    CGFloat sliderHeight = self.bounds.size.height - speedSliderHeight - speedSliderBottomSpace;
    self.saVideoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(0, speedSliderHeight + speedSliderBottomSpace, sliderWidth, sliderHeight) videoUrl:_videoUrl];
    [_saVideoRangeSlider setPopoverBubbleSize:0 height:0];
    [_saVideoRangeSlider changeMainColor:SPEED_FREEZING_COLOR_WHITE];
    
//    _saVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.992 green: 0.902 blue: 0.004 alpha: 1];
//    _saVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.992 green: 0.902 blue: 0.004 alpha: 1];
    _saVideoRangeSlider.delegate = self;
    [self addSubview:_saVideoRangeSlider];
    
    //speedSlider
    [self configureSpeedSlider];
}

- (void)configureSpeedSlider {
    //左游标
    self.leftSpeedSlider = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, speedSliderWidth, speedSliderHeight)];
    [_leftSpeedSlider setImage:[UIImage imageNamed:@"vernier_yellow"]];
    [_leftSpeedSlider setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
    [_leftSpeedSlider addGestureRecognizer:leftPan];
    [self addSubview:_leftSpeedSlider];
    
    //右游标
    self.rightSpeedSlider = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, speedSliderWidth, speedSliderHeight)];
    [_rightSpeedSlider setImage:[UIImage imageNamed:@"vernier_yellow"]];
    [_rightSpeedSlider setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
    [_rightSpeedSlider addGestureRecognizer:rightPan];
    [self addSubview:_rightSpeedSlider];
    
    //连线
    self.ligatureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _leftSpeedSlider.center.y, self.bounds.size.width, speedSliderLigatureHeight)];
    [_ligatureImageView setImage:[UIImage imageNamed:@"vernier_ligature"]];
//    [_ligatureImageView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_ligatureImageView];
    
    //mask
    self.ligatureMaskLayer = [[CAShapeLayer alloc] init];
    _ligatureImageView.layer.mask = self.ligatureMaskLayer;
    
    self.isSpeedSliderActive = YES;
    [self configureSpeedSliderInitialStatus];
}

- (void)extendTouchArea {
    int extendMargin = -10;
    [_leftSpeedSlider setTouchExtendInset:UIEdgeInsetsMake(extendMargin, extendMargin, extendMargin, extendMargin)];
    [_rightSpeedSlider setTouchExtendInset:UIEdgeInsetsMake(extendMargin, extendMargin, extendMargin, extendMargin)];
}

- (void)configureSpeedSliderInitialStatus {
    //speedSlider初始状态
    self.leftPositionCoordinates = _saVideoRangeSlider.leftPositionCoordinates + _saVideoRangeSlider.thumbWidth;
    self.rightPositionCoordinates = _saVideoRangeSlider.rightPositionCoordinates - _saVideoRangeSlider.thumbWidth;
    [self setNeedsLayout];
}

- (BOOL)switchSpeedSlider {
    if (_isSpeedSliderActive) {
        //关闭
        _leftSpeedSlider.hidden = YES;
        _rightSpeedSlider.hidden = YES;
        [_ligatureImageView removeFromSuperview];
        
        self.isSpeedSliderActive = NO;
        [self rangeEditing];
    } else {
        //打开
        _leftSpeedSlider.hidden = NO;
        _rightSpeedSlider.hidden = NO;
        [self addSubview:_ligatureImageView];
        
        [self configureSpeedSliderInitialStatus];
        self.isSpeedSliderActive = YES;
    }
    return _isSpeedSliderActive;
}

- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self speedEditing];
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [gesture translationInView:self];
            if (_leftPositionCoordinates + translation.x >= _saVideoRangeSlider.leftPositionCoordinates + _saVideoRangeSlider.thumbWidth &&
                _leftPositionCoordinates + translation.x < _rightPositionCoordinates) {
                //在视频有效范围内
                self.leftPositionCoordinates += translation.x;
            }
            if (_leftPositionCoordinates < 0) {
                self.leftPositionCoordinates = 0;
            }
            [gesture setTranslation:CGPointZero inView:self];
            [self setNeedsLayout];
            [self speedSliderChangeNotification:SliderMotionLeft];
        }
            break;
        case UIGestureRecognizerStateEnded:
            [self speedSliderGestureStateEndedNotification];
            break;
        default:
            break;
    }
    
    
//    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
//        
//    } else if (gesture.state == UIGestureRecognizerStateEnded) {
//        
//    }
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self speedEditing];
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [gesture translationInView:self];
            if (_rightPositionCoordinates + translation.x <= _saVideoRangeSlider.rightPositionCoordinates - _saVideoRangeSlider.thumbWidth &&
                _rightPositionCoordinates + translation.x > _leftPositionCoordinates) {
                //在视频有效范围内
                self.rightPositionCoordinates += translation.x;
            }
            if (_rightPositionCoordinates > (self.bounds.size.width - _saVideoRangeSlider.thumbWidth)) {
                _rightPositionCoordinates = self.bounds.size.width - _saVideoRangeSlider.thumbWidth;
            }
            [gesture setTranslation:CGPointZero inView:self];
            [self setNeedsLayout];
            [self speedSliderChangeNotification:SliderMotionRight];
        }
            break;
        case UIGestureRecognizerStateEnded:
            [self speedSliderGestureStateEndedNotification];
            break;
        default:
            break;
    }
    
//    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
//        
//    } else if (gesture.state == UIGestureRecognizerStateEnded) {
//        
//    }
}

- (void)linkageSpeedSliderWithRangeSliderLeft:(CGFloat)leftPositionCoordinates right:(CGFloat)rightPositionCoordinates {
    
    BOOL linkaged = NO;
    //联动 speedSlider只改UI 不做实时范围改变通知 做手势结束范围改变通知
    if (leftPositionCoordinates + _saVideoRangeSlider.thumbWidth > _leftPositionCoordinates) {
        self.leftPositionCoordinates = leftPositionCoordinates + _saVideoRangeSlider.thumbWidth;
        linkaged = YES;
    }
    
    if (rightPositionCoordinates - _saVideoRangeSlider.thumbWidth < _rightPositionCoordinates) {
        self.rightPositionCoordinates = rightPositionCoordinates - _saVideoRangeSlider.thumbWidth;
        linkaged = YES;
    }
    
    //speedSlider左右交叉，关闭这个功能
    if (_leftPositionCoordinates >= _rightPositionCoordinates) {
        [self switchSpeedSlider];
    }
    
    [self setNeedsLayout];
    if (linkaged) {
        [self speedSliderGestureStateEndedNotification];
    }
}

- (void)speedSliderChangeNotification:(SliderMotion)motion {
    if ([_delegate respondsToSelector:@selector(operatingViewSpeedDidChangeLeftPosition:rightPosition:sliderMotion:)]) {
        [_delegate operatingViewSpeedDidChangeLeftPosition:[self speedLeftPositionToVideoPosition] rightPosition:[self speedRightPositionToVideoPosition] sliderMotion:motion];
    }
}

- (void)speedSliderGestureStateEndedNotification {
    if ([_delegate respondsToSelector:@selector(operatingViewSpeedDidGestureStateEndedLeftPosition:rightPosition:)]) {
        [_delegate operatingViewSpeedDidGestureStateEndedLeftPosition:[self speedLeftPositionToVideoPosition] rightPosition:[self speedRightPositionToVideoPosition]];
    }
}

- (CGFloat)speedSliderEffectiveWidth {
    return self.bounds.size.width - 2*_saVideoRangeSlider.thumbWidth;
}

- (Float64)speedLeftPositionToVideoPosition {
    return [_saVideoRangeSlider videoDurationSeconds] * (_leftPositionCoordinates - _saVideoRangeSlider.thumbWidth)/ [self speedSliderEffectiveWidth];
}

- (Float64)speedRightPositionToVideoPosition {
    return [_saVideoRangeSlider videoDurationSeconds] * (_rightPositionCoordinates - _saVideoRangeSlider.thumbWidth) / [self speedSliderEffectiveWidth];
}

- (CMTime)speedOperateVideoBeginTime {
    return CMTimeMakeWithSeconds([self speedLeftPositionToVideoPosition], NSEC_PER_SEC);
}

- (CMTime)speedOperateVideoEndTime {
    return CMTimeMakeWithSeconds([self speedRightPositionToVideoPosition], NSEC_PER_SEC);
}

- (void)speedEditing {
    if (_editingType == EditingTypeSpeed) {
        return;
    }
    //若被关闭，先打开
    if (!_isSpeedSliderActive) {
        [self switchSpeedSlider];
    }
    //speed
    [_leftSpeedSlider setImage:[UIImage imageNamed:@"vernier_yellow"]];
    [_rightSpeedSlider setImage:[UIImage imageNamed:@"vernier_yellow"]];
    _ligatureImageView.hidden = NO;
    //range
    [_saVideoRangeSlider changeMainColor:SPEED_FREEZING_COLOR_WHITE];
    
    //delegate button
    if ([_delegate respondsToSelector:@selector(operatingViewSpeedBeginEditing)]) {
        [_delegate operatingViewSpeedBeginEditing];
    }
    //EditingType
    self.editingType = EditingTypeSpeed;
    
}

- (void)rangeEditing {
    if (_editingType == EditingTypeRange) {
        return;
    }
    //speed
    [_leftSpeedSlider setImage:[UIImage imageNamed:@"vernier_white"]];
    [_rightSpeedSlider setImage:[UIImage imageNamed:@"vernier_white"]];
    _ligatureImageView.hidden = YES;
    //range
    [_saVideoRangeSlider changeMainColor:SPEED_FREEZING_COLOR_YELLOW];
    //delegate button
    if ([_delegate respondsToSelector:@selector(operatingViewRangeBeginEditing)]) {
        [_delegate operatingViewRangeBeginEditing];
    }
    //EditingType
    self.editingType = EditingTypeRange;
}

#pragma mark - delegate
- (void)videoRange:(SAVideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
    if ([_delegate respondsToSelector:@selector(operatingViewRangeDidGestureStateEndedLeftPosition:rightPosition:)]) {
        [_delegate operatingViewRangeDidGestureStateEndedLeftPosition:leftPosition rightPosition:rightPosition];
    }
}

- (void)videoRange:(SAVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition sliderMotion:(SliderMotion)motion {
    [self rangeEditing];
    if ([_delegate respondsToSelector:@selector(operatingViewRangeDidChangeLeftPosition:rightPosition:sliderMotion:)]) {
        [_delegate operatingViewRangeDidChangeLeftPosition:leftPosition rightPosition:rightPosition sliderMotion:motion];
    }
    //联动speedSlider
    if (_isSpeedSliderActive) {
       [self linkageSpeedSliderWithRangeSliderLeft:videoRange.leftPositionCoordinates right:videoRange.rightPositionCoordinates];
    }
}


@end
