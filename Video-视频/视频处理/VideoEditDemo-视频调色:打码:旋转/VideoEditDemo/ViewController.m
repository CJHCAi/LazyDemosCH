//
//  ViewController.m
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/2/24.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "TZImagePickerController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BlurPlayerViewController.h"
#import "RotatePlayerViewController.h"
#import "VideoEditViewController.h"


#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface ViewController ()<TZImagePickerControllerDelegate>


@property (strong,nonatomic)UIButton *startBlurButton;
@property (strong,nonatomic)UIButton *startRotateButton;
@property (strong,nonatomic)UIButton *startVideoEditButton;
@property (assign,nonatomic)NSInteger pushIndex;

@end

@implementation ViewController




-(UIButton *)startBlurButton{
    if (!_startBlurButton) {
        _startBlurButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-200/2, 200, 200, 40)];
        [_startBlurButton setBackgroundColor:[UIColor colorWithRed:8.0f/255.0f green:177.0f/255.0f blue:251.0f/255.0f alpha:1.0f]];
    }
    return _startBlurButton;
}

-(UIButton *)startRotateButton{
    if (!_startRotateButton) {
        _startRotateButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-200/2, 200+40+30, 200, 40)];
        [_startRotateButton setBackgroundColor:[UIColor colorWithRed:243.0f/255.0f green:192.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
    }
    return _startRotateButton;
}

-(UIButton *)startVideoEditButton{
    if (!_startVideoEditButton) {
        _startVideoEditButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-200/2, 200+40+40+30+30, 200, 40)];
        [_startVideoEditButton setBackgroundColor:[UIColor colorWithRed:249.0f/255.0f green:70.0f/255.0f blue:63.0f/255.0f alpha:1.0f]];
    }
    return _startVideoEditButton;
}



-(void)initUI{
    
    
    [self.navigationItem setTitle:@"视频处理"];
    
    
    [self.view addSubview:self.startBlurButton];
    [self.startBlurButton setTitle:@">>>>视频去水印" forState:UIControlStateNormal];
    [self.startBlurButton addTarget:self action:@selector(StartBlur) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.startRotateButton];
    [self.startRotateButton setTitle:@">>>>视频旋转" forState:UIControlStateNormal];
    [self.startRotateButton addTarget:self action:@selector(StartRotate) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.startVideoEditButton];
    [self.startVideoEditButton setTitle:@">>>>画面调色" forState:UIControlStateNormal];
    [self.startVideoEditButton addTarget:self action:@selector(StartVideoEdit) forControlEvents:UIControlEventTouchUpInside];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle tz_localizedStringForKey:@"Back"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [self initUI];
}


-(void)showImagePickerController{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = NO;
    imagePickerVc.allowPickingMultipleVideo = NO;
    imagePickerVc.allowPreview = NO;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];;
    
}

-(void)StartBlur{
    _pushIndex = 0;
    [self showImagePickerController];
}

-(void)StartRotate{
    _pushIndex = 1;
    [self showImagePickerController];
    
}

-(void)StartVideoEdit{
    _pushIndex = 2;
    [self showImagePickerController];

}

-(void)pushViewControllerFormAsset:(NSURL *)assetUrl PushNavgation:(TZImagePickerController *)picker{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if (storyBoard) {
        switch (_pushIndex) {
            case 0:{
                BlurPlayerViewController *BlurPlayerVC = [storyBoard instantiateViewControllerWithIdentifier:@"BlurPlayerVC"];
                if (BlurPlayerVC) {
                    BlurPlayerVC.playUrl = assetUrl;
                    picker.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                    [picker pushViewController:BlurPlayerVC animated:YES];
                }
            }
                break;
            case 1:{
                RotatePlayerViewController *RotatePlayerVC = [storyBoard instantiateViewControllerWithIdentifier:@"RotatePlayerVC"];
                if (RotatePlayerVC) {
                    RotatePlayerVC.playUrl = assetUrl;
                    picker.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                    [picker pushViewController:RotatePlayerVC animated:YES];
                    
                }
                
            }
                break;
            case 2:{
                
                
                VideoEditViewController *VideoEditVC = [storyBoard instantiateViewControllerWithIdentifier:@"VideoEditVC"];
                if (VideoEditVC) {
                    VideoEditVC.playUrl = assetUrl;
                    picker.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                    [picker pushViewController:VideoEditVC animated:YES];
                    
                }
                
            }
                break;
            default:
                break;
        }
    }
    
}


-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset{
    __weak ViewController *weakself = self;
    NSLog(@"获取到视频啦");
    if (asset) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
            option.networkAccessAllowed = YES;
            option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                
            };
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    AVURLAsset *urlAsset = (AVURLAsset *)asset;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakself pushViewControllerFormAsset:urlAsset.URL PushNavgation:picker];
                        NSLog(@"URL = %@",urlAsset.URL);
                    });
                    
                });
            }];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            ALAssetRepresentation *defaultRepresentation = [alAsset defaultRepresentation];
            NSString *uti = [defaultRepresentation UTI];
            NSURL *videoURL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself pushViewControllerFormAsset:videoURL PushNavgation:picker];
                NSLog(@"URL = %@",videoURL);
            });
        }
    }
}

#pragma mark - --- UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.获取图片信息
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString* videoString = [info objectForKey:UIImagePickerControllerMediaURL];
    
    if (!videoString){
        videoString = [info objectForKey:UIImagePickerControllerMediaURL];
    }
    

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
