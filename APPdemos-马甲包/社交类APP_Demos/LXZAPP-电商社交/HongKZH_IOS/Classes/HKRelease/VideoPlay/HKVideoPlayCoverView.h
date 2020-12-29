//
//  HKVideoPlayCoverView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKVideoPlayCoverView;

@protocol HKVideoPlayCoverViewDelegate <NSObject>


/**
 暂停和播放

 @param view cover视图
 @param button 播放按钮
 */
-(void) HKVideoPlayCoverView:(HKVideoPlayCoverView *)view playButtonClick:(UIButton *)button;


/**
 封面button点击

 @param view cover视图
 @param button 封面button
 */
- (void) HKVideoPlayCoverView:(HKVideoPlayCoverView *)view coverImageViewClick:(UIButton *)button;


/**
 点击了标签按钮

 @param view cover视图
 @param button sender
 */
- (void) HKVideoPlayCoverView:(HKVideoPlayCoverView *)view tagButtonClick:(UIButton *)button;

/*
 * 功能 ： 移动距离
 参数 ： dragProgressSliderValue slide滑动长度
 event 手势事件，点击-移动-离开
 */
- (void)HKVideoPlayCoverView:(HKVideoPlayCoverView *)view dragProgressSliderValue:(float)value event:(UIControlEvents)event;

/**
 点击完成按钮

 @param view cover视图
 @param button 完成按钮
 */
- (void) HKVideoPlayCoverView:(HKVideoPlayCoverView *)view finishButtonClick:(UIButton *)button;
@end

@interface HKVideoPlayCoverView : UIView

@property (nonatomic, weak) id<HKVideoPlayCoverViewDelegate> delegate;

@property (nonatomic, assign) CGFloat progress;

- (void)updateProgressWithCurrentTime:(float)currentTime durationTime:(float)durationTime;

- (void)setCoverImage:(UIImage *)image;

@end
