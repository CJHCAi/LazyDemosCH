//
//  LQPlayerProgressLine.h
//  Progress
//
//  Created by 李强 on 17/2/28.
//  Copyright © 2017年 李强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    LQPlayerProgressLineTypeSmall,
    LQPlayerProgressLineTypeMiddle,
    LQPlayerProgressLineTypeBig,
}LQPlayerProgressLineType;

typedef void(^TapBlock)(UISlider *slider);
typedef void(^ValueChangeBlock)(UISlider *slider);

@interface LQPlayerProgressLine : UIView

/**
 进度值改变的block
 */
@property (nonatomic, copy) ValueChangeBlock valueChangeBlock;

/**
 点击事件block
 */
@property (nonatomic, copy) TapBlock tapBlock;

/**
 类型
 */
@property (nonatomic, assign) LQPlayerProgressLineType type;
/**
 播放进度
 */
@property (nonatomic, assign) CGFloat playProgress;

/**
 缓存进度
 */
@property (nonatomic, assign) CGFloat cacheProgress;

/**
 更新缓存进度值

 @param cacheProgress 缓存进度
 @param animated 是否开启动画
 */
- (void)setCacheProgress:(CGFloat)cacheProgress animated:(BOOL)animated;

/**
 轨道背景颜色(default lightGrayColor)
 */
@property (nonatomic, assign) CGFloat trackTintColor;

/**
 缓存进度的颜色 (default darkGrayColor)
 */
@property (nonatomic, assign) CGFloat cacheTintColor;

/**
 播放进度颜色 (default orangeColor)
 */
@property (nonatomic, assign) CGFloat playTintColor;

/**
 初始化进度条

 @param frame frame
 @return 进度条实例
 */
+ (instancetype)playerProgressLineWithFrame:(CGRect)frame;
@end
