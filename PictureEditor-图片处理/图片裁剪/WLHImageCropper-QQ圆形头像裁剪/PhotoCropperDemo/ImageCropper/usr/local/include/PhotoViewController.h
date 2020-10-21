//
//  PhotoViewController.h
//  incup
//
//  Created by wanglh on 15/4/27.
//  Copyright (c) 2015年 Kule Yang. All rights reserved.
/**
 
 *******************************************************
 *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题
 * 您可以发邮件到183049213@qq.com
 * github下载地址 https://github.com/wangluhui/WLHImageCropper
 *
 *******************************************************
 
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PhotoMaskViewMode) {
    PhotoMaskViewModeCircle = 1, // default
    PhotoMaskViewModeSquare = 2 // square
};

@class PhotoViewController;
@protocol PhotoViewControllerDelegate <NSObject>

- (void)imageCropper:(PhotoViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(PhotoViewController *)cropperViewController;
@end

@interface PhotoViewController : UIViewController

@property (nonatomic,weak) id<PhotoViewControllerDelegate> delegate;
@property (nonatomic,strong) UIImage *oldImage;
@property (nonatomic,assign) PhotoMaskViewMode mode;       // 圆形 or 正方形
@property (nonatomic,assign) CGFloat cropWidth;            // 裁剪宽度
@property (nonatomic,assign) CGFloat cropHeight;           // 裁剪高度
@property (nonatomic,strong) UIColor *lineColor;           // 线条颜色
@property (nonatomic,assign) BOOL    isDark;               // 是否为虚线 default is NO
@property (nonatomic,copy)   NSString *cropTitle;          // 标题
@property (nonatomic,strong) UIColor  *btnBackgroundColor; // 确定按钮颜色
@property (nonatomic,copy)   NSString *backImage;          // 返回按钮图片
@end
