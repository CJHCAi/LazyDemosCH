//
//  LXSEQView.h
//  LXSEQViewDemo
//
//  Created by 李新星 on 15/12/16.
//  Copyright © 2015年 xx-li. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! 显示音乐播放的动画 */
@interface LXSEQView : UIControl

/*! 开始动画 */
- (void)startAnimation;

/*! 结束动画 */
- (void) stopAnimation;

/*! 柱子的宽度 */
@property (assign, nonatomic) CGFloat pillarWidth;

/*! 柱子的颜色 */
@property (strong, nonatomic) UIColor * pillarColor;

@end
