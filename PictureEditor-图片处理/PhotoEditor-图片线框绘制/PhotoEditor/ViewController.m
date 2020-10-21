//
//  ViewController.m
//  PhotoEditor
//
//  Created by 0xfeedface on 16/7/11.
//  Copyright © 2016年 0xfeedface. All rights reserved.
//

#import "ViewController.h"
#import "DrawCoreViewController.h"

typedef enum : NSUInteger {
    ImageSourceTypeCamara,
    ImageSourceTypeLibrary
} ImageSourceType;

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)chooseImage:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camaraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self camaraGo:ImageSourceTypeCamara];
    }];
    
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self camaraGo:ImageSourceTypeLibrary];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:camaraAction];
    [alert addAction:libraryAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 调用相机

- (void)camaraGo:(ImageSourceType)type {
    switch (type) {
        case ImageSourceTypeCamara:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }   else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示:" message:@"当前设备不支持相机" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            }
            break;
        case ImageSourceTypeLibrary:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker
                                   animated:YES
                                 completion:nil];
            }   else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示:" message:@"当前设备不支持查看相册" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *theImage = nil;
    // 判断，图片是否允许修改
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    DrawCoreViewController *drawViewController = [[DrawCoreViewController alloc] initWithImage:theImage];
    drawViewController.loadImage = ^(UIImage *nImage){
        self.imageView.frame = CGRectMake(0, 0, nImage.size.width > self.view.frame.size.width ? self.view.frame.size.width:nImage.size.width, (nImage.size.width > self.view.frame.size.width ? self.view.frame.size.width:nImage.size.width) * nImage.size.height / nImage.size.width);
        self.imageView.image = nImage;
        self.imageView.center = self.view.center;
    };
    
    [self presentViewController:drawViewController animated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
