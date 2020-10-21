//
//  VideoViewController.m
//  WYMultimediaDemo
//
//  Created by Mac mini on 16/7/21.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoCompressViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


#pragma mark - 1. 导入头文件, 遵循两个协议

#import <AVFoundation/AVFoundation.h>

@interface VideoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>


#pragma mark - 2. 几个属性

// 将要模态出来的 imgPickerController, 通过设置媒体源来确定是相册还是摄像头
@property (strong, nonatomic) UIImagePickerController *imgPickerController;
// 相册选取视频还是录像
@property (assign, nonatomic) BOOL isPhotoAlbum;
// 视频的路径
@property (strong, nonatomic) NSString *videoPathString;


// demo 需要的临时属性
@property (strong, nonatomic) UIButton *videoButton;
@property (strong, nonatomic) UILabel *videoLabel;
@property (strong, nonatomic) UIButton *compressVideoButton;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.videoButton];
}


#pragma mark - 3. 调用相册选取视频或录像, 我们只需要操作以下两个代理方法

// 代理方法(1) : 用户作出完成动作时会触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    if (self.imgPickerController.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {// 相册选取视频
        
        // 获取到这个视频的路径
        self.videoPathString = (NSString *)([info[@"UIImagePickerControllerMediaURL"] path]);
        
        self.videoLabel.text = [NSString stringWithFormat:@"视频的路径为 : %@", self.videoPathString];
        [self.view addSubview:self.videoLabel];
        [self.view addSubview:self.compressVideoButton];
    }else if (self.imgPickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {// 录像
        
        // 录像会自动放到沙盒的某个路径, 获取到这个路径
        self.videoPathString = (NSString *)([info[@"UIImagePickerControllerMediaURL"] path]);
        // 是否保存录像到相册(不写的话就是不保存), 保存后有一个回调方法
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoPathString)) {
            
            UISaveVideoAtPathToSavedPhotosAlbum(self.videoPathString, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    
    // 模态走imgPicker
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 代理方法(2) : 用户作出取消动作时会触发的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // 模态走imgPicker
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 4. 回调

/**
 *  视频保存后的回调
 第一个参数 : 录到并保存在本地的视频路径
 */
- (void)video:(NSString *)videoPathString didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error) {
        
        self.videoLabel.text = [NSString stringWithFormat:@"视频的路径为 : %@", self.videoPathString];
        [self.view addSubview:self.videoLabel];
        [self.view addSubview:self.compressVideoButton];
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频保存错误,请稍后重试!" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *defaltAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:defaltAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - 5. 给定一个事件模态出 imgPicker 来干活

- (void)videoButtonAction:(UIButton *)button {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您好! 我是imgPickerController!" message:@"您是要去相册选取视频呢还是录像呢?" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册选取视频" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        // 选取视频状态
        self.isPhotoAlbum = YES;
        // 模态出 imgPicker 来干活
        [self presentViewController:self.imgPickerController animated:YES completion:nil];
    }];
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"录像" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        // 录像状态
        self.isPhotoAlbum = NO;
        // 模态出 imgPicker 来干活
        [self presentViewController:self.imgPickerController animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"点错了而已" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alertController addAction:photoAction];
    [alertController addAction:videoAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - 6. 懒加载

- (UIImagePickerController *)imgPickerController {
    
    // 调用 imgPickerController 的时候, 判断一下是否支持相册或者摄像头功能
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)] && [UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
        
        if (!_imgPickerController) {
            
            _imgPickerController = [[UIImagePickerController alloc] init];
            _imgPickerController.delegate = self;
            // 产生的媒体文件是否可进行编辑
            _imgPickerController.allowsEditing = YES;
            // 媒体类型
            _imgPickerController.mediaTypes = @[@"public.movie"];
        }
        
        if (self.isPhotoAlbum) {
            
            // 媒体源, 这里设置为相册
            _imgPickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }else{
            
            // 媒体源, 这里设置为摄像头
            _imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 摄像头, 这里设置默认使用后置摄像头
            _imgPickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            // 摄像头模式, 这里设置为录像模式
            _imgPickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            // 录像质量
            _imgPickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
            
            /**
             *  录像质量 :
             
             这三种录像质量会录出一个根据当前设备自适应分辨率的视频文件, MOV格式, 视频采用 H264 编码, 三种质量视频的清晰度还是有明显差别, 所以我一般选取高质量的录像, 然后才去中质量的视频压缩, 最终得到的视频清晰度和高质量没啥区别, 而大小又和中质量直接录的视频没啥区别
             UIImagePickerControllerQualityTypeLow
             UIImagePickerControllerQualityTypeMedium
             UIImagePickerControllerQualityTypeHigh
             
             这三种录像质量会录出一个指定分辨率的视频文件, MOV格式, 视频采用 H264 编码, 但是我们一般选取中质量
             UIImagePickerControllerQualityType640x480
             UIImagePickerControllerQualityTypeIFrame960x540
             UIImagePickerControllerQualityTypeIFrame1280x720
             */
        }
        
        return _imgPickerController;
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备不支持此功能!" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *defaltAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:nil];
        
        [alertController addAction:defaltAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return nil;
    }
}

- (UIButton *)videoButton {
    
    if (!_videoButton) {
        
        _videoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _videoButton.center = CGPointMake(self.view.center.x, 150);
        _videoButton.backgroundColor = [UIColor redColor];
        [_videoButton setTitle:@"先点我一下" forState:(UIControlStateNormal)];
        [_videoButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _videoButton;
}

- (UILabel *)videoLabel {
    
    if (!_videoLabel) {
        
        CGRect tempRect = [[NSString stringWithFormat:@"视频的路径为 : %@", self.videoPathString]boundingRectWithSize:CGSizeMake(kScreenWidth / 2.0, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        _videoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight - tempRect.size.height, kScreenWidth / 2.0, tempRect.size.height)];
        _videoLabel.numberOfLines = 0;
        _videoLabel.backgroundColor = [UIColor orangeColor];
    }
    
    return _videoLabel;
}

- (UIButton *)compressVideoButton {
    
    if (!_compressVideoButton) {
        
        CGRect tempRect = [[NSString stringWithFormat:@"视频的路径为 : %@", self.videoPathString]boundingRectWithSize:CGSizeMake(kScreenWidth / 2.0, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        _compressVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0, kScreenHeight - tempRect.size.height, kScreenWidth / 2.0, tempRect.size.height)];
        _compressVideoButton.backgroundColor = [UIColor yellowColor];
        [_compressVideoButton setTitle:@"点我压缩视频吧" forState:(UIControlStateNormal)];
        [_compressVideoButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_compressVideoButton addTarget:self action:@selector(compressVideoButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _compressVideoButton;
}
- (void)compressVideoButtonAction:(UIButton *)button {
    
    // 此时需要把源视频的路径传递到压缩视频的界面
    VideoCompressViewController *videoCompressVC = [[VideoCompressViewController alloc] init];
    videoCompressVC.sourceVideoPathString = self.videoPathString;
    [self.navigationController pushViewController:videoCompressVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
