//
//  HJMaskView.h
//  HJVideoPlayer
//
//  Created by 黄静静 on 2017/7/24.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol HJMaskViewDelegate <NSObject>
@optional
- (void)pauseVideo;
- (void)replayVideo;
- (void)seekToTime:(float)time withBlock:(void (^)(BOOL finished))completionHandler;
- (void)isFullScreen:(BOOL)isFullScreen;
- (void)closeVideo;
@end

@interface HJMaskView : UIView
@property (nonatomic) BOOL isForcePause; // 暂停
@property (nonatomic, weak) id<HJMaskViewDelegate>delegate;

+ (NSString *)convertVideoDuration:(Float64)duration;

@end
