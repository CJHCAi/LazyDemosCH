//
//  MJPhotoLoadingView.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMinProgress 0.0001

@class MJPhotoBrowser;
@class MJPhoto;

@interface MJPhotoLoadingView : UIView
@property (nonatomic) float progress;

- (void)showLoading;
- (void)showFailure;
@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com