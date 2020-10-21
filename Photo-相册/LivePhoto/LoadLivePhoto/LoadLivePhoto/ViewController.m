//
//  ViewController.m
//  LoadLivePhoto
//
//  Created by 刘硕 on 2016/11/1.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) PHLivePhotoView *photoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClick:(UIButton *)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    // 设置mediaTypes 添加LivePhoto类型图片
    NSArray *mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeLivePhoto];
    ipc.mediaTypes = mediaTypes;
    [self presentViewController:ipc animated:YES completion:^{
    }];
}

- (PHLivePhotoView*)photoView {
    if (!_photoView) {
        _photoView = [[PHLivePhotoView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
    }
    return _photoView;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        PHLivePhoto *photo = [info objectForKey:UIImagePickerControllerLivePhoto];
        if (photo) {
            [self.view addSubview:self.photoView];
            _photoView.livePhoto = [info objectForKey:UIImagePickerControllerLivePhoto];
            [_photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
        } else {
            NSLog(@"普通图片");
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)displayClick:(UIButton*)sender {
    [_photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
