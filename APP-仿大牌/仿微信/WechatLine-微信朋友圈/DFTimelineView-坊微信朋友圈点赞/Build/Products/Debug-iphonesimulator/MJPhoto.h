//
//  MJPhoto.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <YLGIFImage/YLImageView.h>
#import <YLGIFImage/YLGIFImage.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MJPhoto : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image; // 完整的图片

@property (nonatomic, strong) UIImageView *srcImageView; // 来源view
@property (nonatomic, strong, readonly) UIImage *placeholder;
@property (nonatomic, strong, readonly) UIImage *capture;

// 是否已经保存到相册
@property (nonatomic, assign) BOOL save;
@property (nonatomic, assign) int index; // 索引

@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com