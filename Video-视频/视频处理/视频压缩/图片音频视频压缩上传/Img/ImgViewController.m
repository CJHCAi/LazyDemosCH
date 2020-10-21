//
//  ImgViewController.m
//  WYMultimediaDemo
//
//  Created by Mac mini on 16/7/21.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import "ImgViewController.h"
#import "Base64ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


#pragma mark - 1. 导入头文件, 遵循两个协议

#import <AVFoundation/AVFoundation.h>

@interface ImgViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>


#pragma mark - 2. 几个属性

// 将要模态出来的 imgPickerController, 通过设置媒体源来确定是相册还是摄像头
@property (strong, nonatomic) UIImagePickerController *imgPickerController;
// 相册选取图片还是拍照
@property (assign, nonatomic) BOOL isPhotoAlbum;
// 选取到的图片
@property (strong, nonatomic) UIImage *selectedImg;


// demo 需要的临时属性
@property (strong, nonatomic) UIButton *imgButton;
@property (strong, nonatomic) UIButton *compressButton;
@property (strong, nonatomic) UIImageView *sourceImgView;
@property (strong, nonatomic) UIImageView *compressImgView;
@property (strong, nonatomic) UILabel *sourceImgLabel;
@property (strong, nonatomic) UILabel *compressImgLabel;

@end

@implementation ImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Base64" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemAction:)];
    
    [self.view addSubview:self.imgButton];
    [self.view addSubview:self.compressButton];
}
- (void)rightBarButtonItemAction:(UIBarButtonItem *)barButtonItem {
    
    Base64ViewController *base64VC = [[Base64ViewController alloc] init];
    // 把压缩后的 data 传过去
    base64VC.fileData = UIImageJPEGRepresentation(self.selectedImg, 0.5);// 压缩图片的 data
    
    [self.navigationController pushViewController:base64VC animated:YES];
}


#pragma mark - 3. 调用相册选取视频或录像, 我们只需要操作以下两个代理方法

// 代理方法(1) : 用户作出完成动作时会触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    if (self.imgPickerController.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {// 相册选取图片
        
        // 获取到这个图片
        if (self.imgPickerController.allowsEditing) {
            
            // 获取编辑后的图片
            self.selectedImg = info[@"UIImagePickerControllerEditedImage"];
        }else {
            
            // 获取原始图片
            self.selectedImg = info[@"UIImagePickerControllerOriginalImage"];
        }
        
        // 源图片展示
        self.sourceImgView.image = self.selectedImg;
        NSData *sourceImgData = UIImageJPEGRepresentation(self.selectedImg, 1);
        self.sourceImgLabel.text = [NSString stringWithFormat:@"源图片 : %.2fK", sourceImgData.length / 1024.0];
        [self.view addSubview:self.sourceImgView];
        [self.sourceImgView addSubview:self.sourceImgLabel];
    }else if (self.imgPickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {// 拍照
        
        // 获取到这个图片
        if (self.imgPickerController.allowsEditing) {
            
            // 获取编辑后的图片
            self.selectedImg = info[@"UIImagePickerControllerEditedImage"];
        }else {
            
            // 获取原始图片
            self.selectedImg = info[@"UIImagePickerControllerOriginalImage"];
        }
        
        // 这里得保存一下新拍的照片, 然后走回调
        UIImageWriteToSavedPhotosAlbum(self.selectedImg, self, @selector(photo:didFinishSavingWithError:contextInfo:), nil);
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
 *  照片保存后的回调
    第一个参数 : 拍到并保存在本地的照片
 */
- (void)photo:(UIImage *)photo didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error) {
        
        // 源图片展示
        self.sourceImgView.image = self.selectedImg;
        NSData *sourceImgData = UIImageJPEGRepresentation(self.selectedImg, 1);
        self.sourceImgLabel.text = [NSString stringWithFormat:@"源图片 : %.2fK", sourceImgData.length / 1024.0];
        [self.view addSubview:self.sourceImgView];
        [self.sourceImgView addSubview:self.sourceImgLabel];
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频保存错误,请稍后重试!" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *defaltAction = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:defaltAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - 5. 给定一个事件模态出 imgPicker 来干活

- (void)imgButtonAction:(UIButton *)button {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您好! 我是imgPickerController!" message:@"您是要去相册选取图片呢还是拍照呢?" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册选取图片" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        // 选取图片状态
        self.isPhotoAlbum = YES;
        // 模态出 imgPicker 来干活
        [self presentViewController:self.imgPickerController animated:YES completion:nil];
    }];
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        // 拍照状态
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
            _imgPickerController.mediaTypes = @[@"public.image"];
        }
        
        if (self.isPhotoAlbum) {
            
            // 媒体源, 这里设置为相册
            _imgPickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }else{
            
            // 媒体源, 这里设置为摄像头
            _imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 摄像头, 这里设置默认使用后置摄像头
            _imgPickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            // 摄像头模式, 这里设置为拍照模式
            _imgPickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
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

- (UIButton *)imgButton {
    
    if (!_imgButton) {
        
        _imgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _imgButton.center = CGPointMake(self.view.center.x - 50, 150);
        _imgButton.backgroundColor = [UIColor redColor];
        [_imgButton setTitle:@"先点我一下" forState:(UIControlStateNormal)];
        [_imgButton addTarget:self action:@selector(imgButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _imgButton;
}

- (UIButton *)compressButton {
    
    if (!_compressButton) {
        
        _compressButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _compressButton.center = CGPointMake(self.view.center.x + 50, 150);
        _compressButton.backgroundColor = [UIColor orangeColor];
        [_compressButton setTitle:@"压缩图片吧" forState:(UIControlStateNormal)];
        [_compressButton addTarget:self action:@selector(compressButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _compressButton;
}
- (void)compressButtonAction:(UIButton *)button {
    
    // 压缩图片的二进制数据
    NSData *compressImgData = UIImageJPEGRepresentation(self.selectedImg, 0.5);
    self.compressImgLabel.text = [NSString stringWithFormat:@"压缩图片 : %.2fK", compressImgData.length / 1024.0];
    // 压缩图片
    UIImage *compressImg = [UIImage imageWithData:compressImgData];
    self.compressImgView.image = compressImg;
    [self.view addSubview:self.compressImgView];
    [self.compressImgView addSubview:self.compressImgLabel];
}


- (UIImageView *)sourceImgView {
    
    if (!_sourceImgView) {
        
        _sourceImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - (kScreenHeight - 250) / 2.0 * 4 / 3) / 2, kScreenHeight - (kScreenHeight - 250) / 2.0 * 2, (kScreenHeight - 250) / 2.0 * 4 / 3, (kScreenHeight - 250) / 2.0)];
        _sourceImgView.backgroundColor = [UIColor clearColor];
    }
    
    return _sourceImgView;
}

- (UIImageView *)compressImgView {
    
    if (!_compressImgView) {
        
        _compressImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - (kScreenHeight - 250) / 2.0 * 4 / 3) / 2, kScreenHeight - (kScreenHeight - 250) / 2.0, (kScreenHeight - 250) / 2.0 * 4 / 3, (kScreenHeight - 250) / 2.0)];
        _compressImgView.backgroundColor = [UIColor clearColor];
    }
    
    return _compressImgView;
}

- (UILabel *)sourceImgLabel {
    
    if (!_sourceImgLabel) {
        
        _sourceImgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        _sourceImgLabel.backgroundColor = [UIColor yellowColor];
    }
    
    return _sourceImgLabel;
}

- (UILabel *)compressImgLabel {
    
    if (!_compressImgLabel) {
        
        _compressImgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        _compressImgLabel.backgroundColor = [UIColor greenColor];
    }
    
    return _compressImgLabel;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
