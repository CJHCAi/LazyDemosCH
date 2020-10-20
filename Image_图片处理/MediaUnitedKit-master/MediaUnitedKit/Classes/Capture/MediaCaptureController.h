//
//  MediaCaptureController.h
//  MediaUnitedKit
//
//  Created by LEA on 2017/9/21.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  自定义视频拍摄
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMotion/CoreMotion.h>
#import <ImageIO/ImageIO.h>

@protocol MediaCaptureManagerDelegate;
@interface MediaCaptureController : UIViewController<AVCaptureFileOutputRecordingDelegate,UIAlertViewDelegate>
{
    dispatch_queue_t sessionQueue;                  // 创建一个队列，防止阻塞主线程
    AVCaptureDevice *captureDevice;                 // 采集设备
    AVCaptureSession *captureSession;               // 采集
    AVCaptureVideoPreviewLayer *previewLayer;       // 相机图层
    AVCaptureDeviceInput *inputDevice;              // 输入
    CGFloat scaleNum;                               // 伸缩系数
    NSTimer *recordTimer;                           // 定时器
    int recordSeconds;                              // 记录定时
}
@property (nonatomic, strong) CMMotionManager *motionManager;

// 视频输出
@property (nonatomic,strong) AVCaptureMovieFileOutput *movieFileOutput;
// 图片输出
@property (nonatomic,strong) AVCaptureStillImageOutput *imageOutput;

// 各个按钮
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *previewBtn;
@property (nonatomic,strong) UIButton *videoBtn;
@property (nonatomic,strong) UIButton *photoBtn;
@property (nonatomic,strong) UIButton *switchBtn;
@property (nonatomic,strong) UIButton *frontBtn;

// 闪关灯控制
@property (nonatomic,strong) UIView *flashView;
@property (nonatomic,strong) UIButton *flashBtn;

// 视频录制时闪烁的绿点
@property (nonatomic,strong) UIImageView *dotImageView;
// 视频时长
@property (nonatomic,strong) UILabel *timeLabel;
// 预览图片
@property (nonatomic,strong) UIImage *previewImage;
// 预览文件名称
@property (nonatomic,strong) NSString *previewFileName;
// 定焦视图
@property (nonatomic,strong) UIImageView *focusImageView;
// 定焦视图
@property (nonatomic,strong) UIView *bgView;
// 屏幕方向
@property (nonatomic,assign) AVCaptureVideoOrientation orientation;
// 代理
@property (nonatomic, assign) id<MediaCaptureManagerDelegate> delegate;

@end

@protocol MediaCaptureManagerDelegate <NSObject>

@optional
- (void)mediaCaptureController:(UIViewController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

@end
