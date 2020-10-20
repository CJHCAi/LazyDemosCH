//
//  CamerasManager.h
//  CameraDemo
//
//  Created by apple on 2017/4/11.
//  Copyright © 2017年 yangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CamerasManager : NSObject

@property(nonatomic,strong)GPUImageStillCamera * stillCamera;//美颜相机

@property(nonatomic,strong)GPUImageView * gpuImageView;

@property(nonatomic,assign)CGFloat getfloats;
@property(nonatomic,assign)CGPoint center;//第一种就是直接赋值



- (instancetype)initWithParentView:(UIView *)view;

//拍照方法
- (void)takePhotoWithImageBlock:(void(^)(UIImage *originImage,UIImage*ScreenshotsImage))block;
/**
 *  切换闪光灯模式
 *
 *
 */
- (void)switchFlashModeWithBtn:(UIButton*)flashBtn;
/**
 *  点击对焦
 *
 *
 */
//- (void)focusInPoint:(CGPoint)devicePoint;
/**
 *  切换前后镜
 *
 *
 */
- (void)addVideoInputFrontCamera;

#pragma mark 美白按钮点击
-(void)filterAction:(id)sender;

@end
