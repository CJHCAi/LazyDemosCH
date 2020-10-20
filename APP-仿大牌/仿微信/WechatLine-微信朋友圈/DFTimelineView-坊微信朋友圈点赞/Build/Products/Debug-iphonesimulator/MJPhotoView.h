//
//  MJZoomingScrollView.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJPhotoBrowser, MJPhoto, MJPhotoView;

@protocol MJPhotoViewDelegate <NSObject>
- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView;
- (void)photoViewSingleTap:(MJPhotoView *)photoView;
@end

@interface MJPhotoView : UIScrollView <UIScrollViewDelegate>
// 图片
@property (nonatomic, strong) MJPhoto *photo;
// 代理
@property (nonatomic, strong) id<MJPhotoViewDelegate> photoViewDelegate;

@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com