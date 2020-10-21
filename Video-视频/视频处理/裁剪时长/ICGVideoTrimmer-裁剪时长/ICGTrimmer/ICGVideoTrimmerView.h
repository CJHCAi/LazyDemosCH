//
//  ICGVideoTrimmerView.h
//  ICGVideoTrimmer
//
//  Created by Huong Do on 1/18/15.
//  Copyright (c) 2015 ichigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ICGVideoTrimmerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface ICGVideoTrimmerView : UIView

@property (strong, nonatomic, nullable) AVAsset *asset;
@property (strong, nonatomic) UIColor *themeColor;
@property (assign, nonatomic) CGFloat maxLength;
@property (assign, nonatomic) CGFloat minLength;
@property (assign, nonatomic) BOOL showsRulerView;
@property (assign, nonatomic) UIColor *trackerColor;
@property (strong, nonatomic, nullable) UIImage *leftThumbImage;
@property (strong, nonatomic, nullable) UIImage *rightThumbImage;
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic) CGFloat thumbWidth;

@property (weak, nonatomic, nullable) id<ICGVideoTrimmerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithAsset:(AVAsset *)asset;
- (instancetype)initWithFrame:(CGRect)frame asset:(AVAsset *)asset NS_DESIGNATED_INITIALIZER;
- (void)resetSubviews;
- (void)seekToTime:(CGFloat)startTime;
- (void)hideTracker:(BOOL)flag;

@end

NS_ASSUME_NONNULL_END

@protocol ICGVideoTrimmerDelegate <NSObject>

- (void)trimmerView:(nonnull ICGVideoTrimmerView *)trimmerView didChangeLeftPosition:(CGFloat)startTime rightPosition:(CGFloat)endTime;

@end


