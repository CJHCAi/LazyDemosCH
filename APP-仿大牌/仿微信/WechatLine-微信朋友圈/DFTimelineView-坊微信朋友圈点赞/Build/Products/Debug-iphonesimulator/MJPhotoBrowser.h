//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import "MJPhoto.h"

@protocol MJPhotoBrowserDelegate;

@interface MJPhotoBrowser : NSObject <UIScrollViewDelegate>
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
// 保存按钮
@property (nonatomic, assign) NSUInteger showSaveBtn;

// 显示
- (void)show;

@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com