//
//  ViewController.m
//  ImageCropDemo
//
//  Created by yinyu on 15/11/10.
//  Copyright © 2015年 yinyu. All rights reserved.
//

#import "ViewController.h"
#import "CropImageViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

/**裁剪图片的界面*/
- (void)cropImage: (UIImage *)image {
    
    CropImageViewController *cropImageViewController = [[CropImageViewController alloc]initWithNibName:@"CropImageViewController" bundle:nil];
    cropImageViewController.image = image;
    [self.navigationController pushViewController: cropImageViewController animated: YES];
    
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *toCropImage = info[UIImagePickerControllerOriginalImage];
    [self cropImage: toCropImage];
    [picker dismissViewControllerAnimated: YES completion: NULL];
    
}

#pragma mark - IBAction
/**测试图片裁剪*/
- (IBAction)clickImageCropBtn:(id)sender {
    
    UIImage *toCropImage = [UIImage imageNamed: @"test"];
    [self cropImage: toCropImage];
    
}

/**裁剪相机图片*/
- (IBAction)clickCameraCropBtn:(id)sender {

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController: imagePicker animated:YES completion: NULL];
}

/**从相册中裁剪图片*/
- (IBAction)clickAlbumCropBtn:(id)sender {

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController: imagePicker animated:YES completion: NULL];
    
}

@end
