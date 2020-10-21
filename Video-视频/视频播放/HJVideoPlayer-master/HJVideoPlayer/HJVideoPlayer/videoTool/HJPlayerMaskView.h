//
//  HJPlayerMaskView.h
//  HJVideoPlayer
//
//  Created by 黄静静 on 2017/7/19.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJMaskView.h"

@interface HJPlayerMaskView : HJMaskView

- (void)setTotaltTime:(Float64)time;
- (void)setCurrentTime:(Float64)time;
- (void)loadProgress:(CGFloat)progress;
@end
