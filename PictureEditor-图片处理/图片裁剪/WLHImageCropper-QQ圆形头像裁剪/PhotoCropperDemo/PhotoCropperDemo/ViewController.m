//
//  ViewController.m
//  PhotoCropperDemo
//
//  Created by ivan on 16/12/1.
//  Copyright © 2016年 wanglh. All rights reserved.
//
/**
 
 *******************************************************
 *
 * 感谢您的支持， 如果下载的代码在使用过程中出现BUG或者其他问题
 * 您可以发邮件到183049213@qq.com
 * github下载地址 https://github.com/wangluhui/WLHImageCropper
 *
 *******************************************************
 
 */
#import "ViewController.h"
#import "PhotoViewController.h"
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,PhotoViewControllerDelegate>

@end

@implementation ViewController{
    UIButton                         *_btn;
    UIImagePickerControllerSourceType _sourceType;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _btn.center = self.view.center;
    [_btn addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    //    [_btn setTitle:@"" forState:UIControlStateNormal];
    _btn.layer.cornerRadius = CGRectGetHeight(_btn.bounds)/2;
    _btn.layer.borderWidth = 1;
    _btn.layer.masksToBounds = YES;
    _btn.layer.borderColor = [UIColor purpleColor].CGColor;
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    _btn.backgroundColor = [UIColor purpleColor];
    _btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:_btn];
}

-(void)changeImage
{
    NSLog(@"change head image");
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"本地相簿",nil];
    [actionSheet showInView:self.view];
}
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://照相机
        {
            //资源类型为照相机
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            _sourceType = sourceType;
            //判断是否有相机
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:nil];
            }else {
                NSLog(@"该设备无摄像头");
            }
        }
            break;
        case 1://本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            //            imagePicker.navigationBar.backgroundColor = [UIColor blackColor];
            imagePicker.delegate = self;
            //            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
#pragma mark -  UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    PhotoViewController *photoVC = [[PhotoViewController alloc] init];
    photoVC.oldImage = image;
//    photoVC.btnBackgroundColor = COLOR_NAV;
    //    photoVC.backImage = ;自定义返回按钮图片
    photoVC.mode = PhotoMaskViewModeCircle;
    photoVC.cropWidth = CGRectGetWidth(self.view.bounds) - 80;
    photoVC.isDark = YES;
    photoVC.delegate = self;
//    photoVC.lineColor = COLOR_NAV;
    [picker pushViewController:photoVC animated:YES];
}
#pragma mark - photoViewControllerDelegate
- (void)imageCropper:(PhotoViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        CATransition *animation = [CATransition animation];
        animation.duration = 0.4f;
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromBottom;
        [_btn.layer addAnimation:animation forKey:nil];
        
        [_btn setBackgroundImage:editedImage forState:UIControlStateNormal];
    }];
    
    
    
}

- (void)imageCropperDidCancel:(PhotoViewController *)cropperViewController
{
    if (_sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [cropperViewController.navigationController popViewControllerAnimated:YES];
    }else{
        [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


@end

