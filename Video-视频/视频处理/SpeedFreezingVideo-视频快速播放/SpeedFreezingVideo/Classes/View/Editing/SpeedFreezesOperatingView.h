//
//  SpeedFreezesOperatingView.h
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/19.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CMTime.h>
#import "SAVideoRangeSlider.h"
#import "UIColor+hexColor.h"

#define SPEED_FREEZING_COLOR_YELLOW [UIColor hexColor:@"fff100"]
#define SPEED_FREEZING_COLOR_WHITE [UIColor whiteColor]

@protocol SpeedFreezesOperatingViewDelegate <NSObject>
- (void)operatingViewRangeDidChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition sliderMotion:(SliderMotion)motion;
- (void)operatingViewRangeDidGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;

- (void)operatingViewSpeedDidChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition sliderMotion:(SliderMotion)motion;
- (void)operatingViewSpeedDidGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;

- (void)operatingViewSpeedBeginEditing;
- (void)operatingViewRangeBeginEditing;
@end

typedef enum {
    EditingTypeSpeed,
    EditingTypeRange
} EditingType;

@interface SpeedFreezesOperatingView : UIView
@property (weak ,nonatomic) id<SpeedFreezesOperatingViewDelegate> delegate;
@property (assign, nonatomic) EditingType editingType;
- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl;
- (BOOL)switchSpeedSlider;
- (CMTime)speedOperateVideoBeginTime;
- (CMTime)speedOperateVideoEndTime;
- (void)speedEditing;
- (void)rangeEditing;

@end
