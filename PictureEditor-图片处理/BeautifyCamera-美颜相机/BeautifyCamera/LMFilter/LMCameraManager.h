//
//  LMCameraManager.h
//  Test1030
//
//  Created by xx11dragon on 15/10/30.
//  Copyright © 2015年 xx11dragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPUImageFilterGroup;
@class LMFilterGroup;
/**
 *  闪光灯模式
 */
typedef NS_ENUM(NSInteger, LMCameraManagerFlashMode) {
    
    LMCameraManagerFlashModeAuto, //自动
    
    LMCameraManagerFlashModeOff, //关闭
    
    LMCameraManagerFlashModeOn //打开
};

/**
 *  摄像头模式
 */
typedef NS_ENUM(NSInteger, LMCameraManagerDevicePosition) {
    
    LMCameraManagerDevicePositionBack, //后摄像头
    
    LMCameraManagerDevicePositionFront //前摄像头
};

@interface LMCameraManager : NSObject

+(instancetype) cameraManager;



//    摄像头位置
@property (nonatomic , assign) LMCameraManagerDevicePosition position;
//    闪光灯模式
@property (nonatomic , assign) LMCameraManagerFlashMode flashMode;

@property (nonatomic, assign) CGFloat combiIntensity;
@property (nonatomic, assign, setter = setFilterAtIndex:) NSInteger filterIndex;
@property (nonatomic, readonly) LMFilterGroup * currentFilterGroup;

@property (nonatomic, readonly) NSArray * filters;

@property (nonatomic, assign) CGFloat zoomFactor;

-(void) setVieweFrame:(CGRect)frame superview:(UIView *)superview;

//    设置对焦的图片
- (void)setfocusImage:(UIImage *)focusImage;

- (void)startCamera;

- (void)stopCamera;
//    拍照
- (void)snapshotSuccess:(void(^)(UIImage *image))success
        snapshotFailure:(void (^)(void))failure;

//    添加手势
- (void) addGesture:(UIGestureRecognizer *)gesture;


@end
