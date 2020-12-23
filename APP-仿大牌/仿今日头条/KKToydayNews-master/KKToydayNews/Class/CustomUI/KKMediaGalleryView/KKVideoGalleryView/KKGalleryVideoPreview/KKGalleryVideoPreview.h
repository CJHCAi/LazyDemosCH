//
//  KKGalleryVideoPreview.h
//  KKToydayNews
//
//  Created by finger on 2017/10/24.
//  Copyright © 2017年 finger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKDragableBaseView.h"
#import "KKVideoInfo.h"

@interface KKGalleryVideoPreview : KKDragableBaseView
- (instancetype)initWithVideoArray:(NSArray<KKVideoInfo *> *)videoArray selIndex:(NSInteger)selIndex albumId:(NSString *)albumId;
@property(nonatomic,assign)CGRect oriFrame;
@property(nonatomic,weak)UIView *oriView;
//自由拖拽图片结束时的相片隐藏动画
@property(nonatomic,copy)void(^hideVideoAnimate)(UIImage *image,CGRect fromFrame,CGRect toFrame);
//上下左右拖动视图时，回复相片在原视图中的透明度
@property(nonatomic,copy)void(^alphaViewIfNeed)(BOOL shouldAlphaView,NSInteger curtSelIndex);
//当左右滑动图片时，同时更新图片的原始frame，用于隐藏动画
@property(nonatomic,copy)void(^videoIndexChange)(NSInteger imageIndex,void(^updeteOriFrame)(CGRect oriFrame));
@property(nonatomic,copy)void(^selectVideo)(KKVideoInfo *photoItem);
@end
