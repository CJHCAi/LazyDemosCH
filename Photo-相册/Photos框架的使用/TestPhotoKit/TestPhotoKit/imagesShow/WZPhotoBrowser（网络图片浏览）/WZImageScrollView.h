//
//  WZImageScrollView.h
//  WZPhotoPicker
//
//  Created by admin on 17/5/22.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMediaFetcher.h"

@protocol WZProtocolImageScrollView <NSObject>

- (void)singleTap:(UIGestureRecognizer *)gesture;
- (void)doubleTap:(UIGestureRecognizer *)gesture;
- (void)longPress:(UIGestureRecognizer *)gesture;

@end

@interface WZImageScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id<WZProtocolImageScrollView> imageScrollDelegate;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

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
- (void)matchZoomWithGesture:(UIGestureRecognizer *)gesture;

@end
