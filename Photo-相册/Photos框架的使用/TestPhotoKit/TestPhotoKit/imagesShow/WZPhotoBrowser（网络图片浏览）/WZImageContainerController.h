//
//  WZImageContainerController.h
//  WZPhotoPicker
//
//  Created by admin on 17/5/24.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZImageScrollView.h"
#import "WZRoundRenderLayer.h"

@interface WZRemoteImgaeProgressView : UIView

@property (nonatomic, strong) WZRoundRenderLayer *downloadProgressLayer;//layer进度条

/**
 *  自定义进度条
 *
 *  @return 自定义进度条
 */
+ (instancetype)customProgress;

/**
 *  进度比例
 *
 *  @param rate 0 <= rate <= 1
 */
- (void)setProgressRate:(float)rate;

@end

@class WZImageContainerController;
@protocol WZProtocolImageContainer <NSObject>

@end

/**
 *  图片容器控制器
 */
@interface WZImageContainerController : UIViewController

@property (nonatomic, weak) UIViewController <WZProtocolImageScrollView>*mainVC;//手势代理对象
@property (nonatomic, weak) id<WZProtocolImageContainer> delegate;//
@property (nonatomic, assign) NSInteger index;//当前图片角标

//进度显示(for remote)
@property (nonatomic, strong) WZRemoteImgaeProgressView *progress;

/**
 *  匹配图片接口
 *
 *  @param image 需要匹配的图片
 */
- (void)matchingPicture:(UIImage *)image;

/**
 *  匹配经过缩放的图片接口
 *
 *  @param gesture 缩放手势
 */
- (void)focusingWithGesture:(UIGestureRecognizer *)gesture;
@end
