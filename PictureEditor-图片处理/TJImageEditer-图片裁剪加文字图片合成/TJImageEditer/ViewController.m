//
//  ViewController.m
//  TJImageEditer
//
//  Created by TanJian on 16/8/1.
//  Copyright © 2016年 Joshpell. All rights reserved.
//

#import "ViewController.h"
#import "MSMFaceClipperVC.h"
#import "MCPosterEditController.h"

#define  kDeviceWidth        [[UIScreen mainScreen] bounds].size.width
#define  kDeviceHeight       [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    MCPosterEditViewDelegate
    >

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *addImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(200, 200, 100, 45)];
    [addImageBtn setTitle:@"选择图片" forState:UIControlStateNormal];
    [addImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addImageBtn addTarget:self action:@selector(addImageMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addImageBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addImageMethod{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    //imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    MSMFaceClipperVC *vc = [[MSMFaceClipperVC alloc] initWithNibName:@"MSMFaceClipperVC" bundle:nil];
    vc.view.frame = self.view.frame;
    vc.superVC = self;
    vc.imageClipping.image = image;

    [self.navigationController pushViewController:vc animated:YES];

    

}


- (void)getFinalPoster:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(kDeviceWidth*0.25, (kDeviceHeight-60)*0.25, kDeviceWidth*0.5, (kDeviceHeight-60)*0.5);
    [self.view addSubview:imageView];
}


@end
