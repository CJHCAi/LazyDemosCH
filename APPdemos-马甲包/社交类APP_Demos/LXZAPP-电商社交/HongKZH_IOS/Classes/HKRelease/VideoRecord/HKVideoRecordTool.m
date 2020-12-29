//
//  HKVideoRecordTool.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKVideoRecordTool.h"

#import "AVC_ShortVideo_Config.h"
#import <AssetsLibrary/AssetsLibrary.h>
#if SDK_VERSION == SDK_VERSION_BASE
#import <AliyunVideoSDK/AliyunVideoSDK.h>
#else
#import "AliyunVideoRecordParam.h"
#import "AliyunMediaConfig.h"
#import "AliyunMediator.h"
#import "AliyunVideoUIConfig.h"
#import "AliyunVideoBase.h"
#import "AliyunVideoCropParam.h"
#endif

#import "HKVideoPlayViewController.h"

@interface HKVideoRecordTool() <AliyunVideoBaseDelegate>

@property (nonatomic, strong) AliyunVideoRecordParam *quVideo;  //录制视频参数配置类

@end

@implementation HKVideoRecordTool

- (void)dealloc{
    DLog(@"%s",__func__);
}

- (instancetype)init {
    return [self initWithDelegate:nil];
}

- (instancetype)initWithDelegate:(UIViewController *)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        [self setupSDKBaseVersionUI];
        //初始化录制参数
        _quVideo = [AliyunVideoRecordParam recordConfigWithVideoRatio:AliyunVideoVideoRatio3To4 videoSize:AliyunVideoVideoSize540P];
        _quVideo.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.mp4",[NSUUID UUID].UUIDString]];
    }
    return self;
}

+ (instancetype)videoRecordWithDelegate:(UIViewController *)delegate {
    return [[self alloc] initWithDelegate:delegate];
}


- (void)setupSDKBaseVersionUI {
#pragma mark 阿里云录制视频配置
    AliyunVideoUIConfig *config = [[AliyunVideoUIConfig alloc] init];
    
    config.backgroundColor = RGB(35, 42, 66);
    config.timelineBackgroundCollor = RGB(35, 42, 66);
    config.timelineDeleteColor = [UIColor redColor];
    config.timelineTintColor = RGB(239, 75, 129);
    config.durationLabelTextColor = [UIColor redColor];
    config.cutTopLineColor = [UIColor redColor];
    config.cutBottomLineColor = [UIColor redColor];
    config.noneFilterText = @"无滤镜";
    config.hiddenDurationLabel = NO;
    config.hiddenFlashButton = NO;
    config.hiddenBeautyButton = NO;
    config.hiddenCameraButton = NO;
    config.hiddenImportButton = NO;
    config.hiddenDeleteButton = NO;
    config.hiddenFinishButton = NO;
    config.recordOnePart = NO;
    config.filterArray = @[@"炽黄",@"粉桃",@"海蓝",@"红润",@"灰白",@"经典",@"麦茶",@"浓烈",@"柔柔",@"闪耀",@"鲜果",@"雪梨",@"阳光",@"优雅",@"朝阳",@"波普",@"光圈",@"海盐",@"黑白",@"胶片",@"焦黄",@"蓝调",@"迷糊",@"思念",@"素描",@"鱼眼",@"马赛克",@"模糊"];
    config.imageBundleName = @"QPSDK";
    config.filterBundleName = @"FilterResource";
    config.recordType = AliyunVideoRecordTypeCombination;
    config.showCameraButton = YES;
    
    [[AliyunVideoBase shared] registerWithAliyunIConfig:config];
}

- (void)toRecordView {
    _quVideo.maxDuration = 30;
    _quVideo.minDuration = 2;
    
    UIViewController *recordViewController = [[AliyunVideoBase shared] createRecordViewControllerWithRecordParam:_quVideo];
    recordViewController.sx_disableInteractivePop = YES;    //禁用全屏手势
    
    [AliyunVideoBase shared].delegate = self;
    if (self.delegate) {
        [self.delegate.navigationController pushViewController:recordViewController animated:YES];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

#pragma mark - AliyunVideoBaseDelegate
#if (SDK_VERSION == SDK_VERSION_BASE || SDK_VERSION == SDK_VERSION_STANDARD)
-(void)videoBaseRecordVideoExit {
    DLog(@"退出录制");
    if (self.delegate) {
        [self.delegate.navigationController popViewControllerAnimated:YES];
    }
}

- (void)videoBase:(AliyunVideoBase *)base recordCompeleteWithRecordViewController:(UIViewController *)recordVC videoPath:(NSString *)videoPath {
    DLog(@"录制完成  %@", videoPath);
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    @weakify(self);
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        DLog(@"录制成功,地址是:%@",videoPath);
//                                        @strongify(self);
                                        if (self.delegate) {
                                            //保存视频地址
                                            [HKReleaseVideoParam shareInstance].filePath = videoPath;
                                            HKVideoPlayViewController *vc = [[HKVideoPlayViewController alloc] initWithUrl:[NSURL fileURLWithPath:videoPath]];
                                            [self.delegate.navigationController pushViewController:vc animated:YES];
                                        }
                                    });
                                }];
}

- (AliyunVideoCropParam *)videoBaseRecordViewShowLibrary:(UIViewController *)recordVC {
    
    DLog(@"录制页跳转Library");
    // 可以更新相册页配置
    AliyunVideoCropParam *mediaInfo = [[AliyunVideoCropParam alloc] init];
    mediaInfo.minDuration = 2.0;
    mediaInfo.maxDuration = 10.0*60;
    mediaInfo.fps = 25;
    mediaInfo.gop = 5;
    mediaInfo.videoQuality = 1;
    mediaInfo.size = AliyunVideoVideoSize540P;
    mediaInfo.ratio = AliyunVideoVideoRatio3To4;
    mediaInfo.cutMode = AliyunVideoCutModeScaleAspectFill;
    mediaInfo.outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cut_save.mp4"];
    return mediaInfo;
}

// 裁剪
- (void)videoBase:(AliyunVideoBase *)base cutCompeleteWithCropViewController:(UIViewController *)cropVC videoPath:(NSString *)videoPath {
    
    DLog(@"裁剪完成  %@", videoPath);
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    @weakify(self);
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        DLog(@"录制成功,地址是:%@",videoPath);
//                                        @strongify(self);
                                        if (self.delegate) {
                                            //保存视频地址
                                            [HKReleaseVideoParam shareInstance].filePath = videoPath;
                                            HKVideoPlayViewController *vc = [[HKVideoPlayViewController alloc] initWithUrl:[NSURL fileURLWithPath:videoPath]];
                                            
                                            [self.delegate.navigationController pushViewController:vc animated:YES];
                                        }
                                    });
                                }];
    
}

- (AliyunVideoRecordParam *)videoBasePhotoViewShowRecord:(UIViewController *)photoVC {
    
    DLog(@"跳转录制页");
    return nil;
}

- (void)videoBasePhotoExitWithPhotoViewController:(UIViewController *)photoVC {
    
    DLog(@"退出相册页");
    [photoVC.navigationController popViewControllerAnimated:YES];
}
#endif

@end
