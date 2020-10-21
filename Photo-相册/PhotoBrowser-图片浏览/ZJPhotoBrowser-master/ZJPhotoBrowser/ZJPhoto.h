//
//  ZJPhoto.h
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/10.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZJPhoto : NSObject

@property (nonatomic, strong) NSURL *url; // 大图的URL
@property (nonatomic, strong) UIImageView *srcImageView; // 来源view
@property (nonatomic, assign) BOOL isTapImage; //是点击的图片, 需要放大动画

//图片放大缩小的比例
@property (nonatomic, assign) CGFloat maxZoomScale;
@property (nonatomic, assign) CGFloat minZoomScale;

@end
