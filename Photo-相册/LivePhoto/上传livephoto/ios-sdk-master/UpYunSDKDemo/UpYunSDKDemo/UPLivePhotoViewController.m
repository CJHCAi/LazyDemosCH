//
//  UPLivePhotoViewController.m
//  UpYunSDKDemo
//
//  Created by 林港 on 16/3/16.
//  Copyright © 2016年 upyun. All rights reserved.
//
#ifdef __IPHONE_9_1

#import "UpYun.h"

#import "UPLivePhotoViewController.h"
#import <Photos/Photos.h>
#import <PhotosUI/PHLivePhotoView.h>

#define NET_MOVIE_FILE  [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tempNetLivePhoto.mov"]]

#define NET_PHOTO_FILE [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tempNetLivePhoto.jpg"]]

@interface UPLivePhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong) PHLivePhoto *livePhotoAsset;
@property (nonatomic, strong) PHLivePhotoView *pHLivePhotoView;
@property (nonatomic, strong) UIButton *createSampleLivePhotosBtn;
@property (nonatomic, strong) UIButton *pickLivePhotosBtn;
@property (nonatomic, strong) UIButton *extractVideoAndPhotoBtn;
@property (nonatomic, strong) UIButton *uploadLivePhotoButton;

@property (nonatomic, strong) UIButton *createNetworkLivePhotosBtn;

@property (nonatomic, copy) NSString *jpgURL;
@property (nonatomic, copy) NSString *movURL;

@property (nonatomic, copy) NSString *jpgLocalPath;
@property (nonatomic, copy) NSString *movLocalPath;

@end

@implementation UPLivePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    if (authorizationStatus != PHAuthorizationStatusAuthorized) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status != PHAuthorizationStatusAuthorized) {
                NSLog(@"运行demo需要获取PhotoLibrary权限");
            }
        }];
    };
    
    CGFloat viewWidth = self.view.frame.size.width;

    
    _pHLivePhotoView = [[PHLivePhotoView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/1.5)];
    _pHLivePhotoView.contentMode = UIViewContentModeScaleToFill;
    
    
    _createSampleLivePhotosBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, viewWidth/1.5+20, 150, 44)];
    _createSampleLivePhotosBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_createSampleLivePhotosBtn setTitle:@"本地合成LivePhoto" forState:UIControlStateNormal];
    [_createSampleLivePhotosBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_createSampleLivePhotosBtn addTarget:self
                                   action:@selector(createLocalLivePhotos)
                         forControlEvents:UIControlEventTouchUpInside];
    
    _pickLivePhotosBtn = [[UIButton alloc] initWithFrame:CGRectMake(170, viewWidth/1.5+20, 120, 44)];
    [_pickLivePhotosBtn setTitle:@"选择LivePhoto" forState:UIControlStateNormal];
    [_pickLivePhotosBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_pickLivePhotosBtn addTarget:self
                           action:@selector(pickLivePhotos)
                 forControlEvents:UIControlEventTouchUpInside];
    
    
    _extractVideoAndPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 140 , 300, 44)];
    [_extractVideoAndPhotoBtn setTitle:@"保存LivePhot到TMP缓存" forState:UIControlStateNormal];
    [_extractVideoAndPhotoBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_extractVideoAndPhotoBtn addTarget:self
                                 action:@selector(extractVideoAndPhoto)
                       forControlEvents:UIControlEventTouchUpInside];
    
    _uploadLivePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 100 , 120, 44)];
    [_uploadLivePhotoButton setTitle:@"上传LivePhoto" forState:UIControlStateNormal];
    [_uploadLivePhotoButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_uploadLivePhotoButton addTarget:self
                                 action:@selector(uploadVideoAndPhoto)
                       forControlEvents:UIControlEventTouchUpInside];
    
    _createNetworkLivePhotosBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, self.view.frame.size.height - 100 , 120, 44)];
    [_createNetworkLivePhotosBtn setTitle:@"网络合成LivePhot" forState:UIControlStateNormal];
    [_createNetworkLivePhotosBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_createNetworkLivePhotosBtn addTarget:self
                               action:@selector(createLivePhotosFromNetwork)
                     forControlEvents:UIControlEventTouchUpInside];
    
    _createSampleLivePhotosBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _pickLivePhotosBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _extractVideoAndPhotoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _uploadLivePhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _createNetworkLivePhotosBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_createSampleLivePhotosBtn];
    [self.view addSubview:_pickLivePhotosBtn];
    [self.view addSubview:_pHLivePhotoView];
    [self.view addSubview:_extractVideoAndPhotoBtn];
    [self.view addSubview:_uploadLivePhotoButton];
    [self.view addSubview:_createNetworkLivePhotosBtn];
}




//本地合成LivePhoto
- (void)createLocalLivePhotos {
    NSString *bundleString = [[NSBundle mainBundle] resourcePath];
    NSString *photoURLstring = [bundleString stringByAppendingPathComponent:@"picture.jpg"];
    NSString *videoURLstring = [bundleString stringByAppendingPathComponent:@"video.mov"];
    
    NSURL *photoURL = [NSURL fileURLWithPath:photoURLstring];
    NSURL *videoURL = [NSURL fileURLWithPath:videoURLstring];
    NSLog(@"photoURL+++%@",photoURL);
    NSLog(@"videoURL+++%@",videoURL);

    [self mergeLivePhotosWithPhotoURL:photoURL VideoURL:videoURL];
}


//网络合成LivePhot
- (void)createLivePhotosFromNetwork {
    
    if (!_movURL || !_jpgURL) {
        [self alertMessage:@"没有上传livephoto, 将使用默认的URL进行合成！"];
        _jpgURL = @"http://pic49.nipic.com/file/20140927/19617624_230415502002_2.jpg";
        _movURL = @"http://res3.308631.com/20170712b.mp4";
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        NSData *movData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_movURL]];
        NSData *jpgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_jpgURL]];
        [jpgData writeToURL:NET_PHOTO_FILE atomically:YES];
        [movData writeToURL:NET_MOVIE_FILE atomically:YES];
        
        [self mergeLivePhotosWithPhotoURL:NET_PHOTO_FILE VideoURL:NET_MOVIE_FILE];
    });
}

//保存LivePhoto到相册
- (void)mergeLivePhotosWithPhotoURL:(NSURL *)photoURL VideoURL:(NSURL *)videoURL {
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
        
        [request addResourceWithType:PHAssetResourceTypePhoto
                             fileURL:photoURL
                             options:nil];
        [request addResourceWithType:PHAssetResourceTypePairedVideo
                             fileURL:videoURL
                             options:nil];
        
    } completionHandler:^(BOOL success,
                          NSError * _Nullable error) {
        if (success) {
            
            [self alertMessage:@"LivePhotos 已经保存至相册!"];
            
        } else {
            
            NSLog(@"mergeLivePhotos error: %@",error);
            
        }
    }];
}

//选择LivePhoto
- (void)pickLivePhotos {
    NSLog(@"pickLivePhotos  ");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.mediaTypes=@[(NSString*)kUTTypeMovie];
//    picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, (NSString *)kUTTypeLivePhoto, nil];
    [self presentViewController:picker
                       animated:YES
                     completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    NSLog(@"%@", info);
    
    
    NSString * path=info[UIImagePickerControllerMediaURL];
    NSURL * vidroUrl=[NSURL fileURLWithPath:path];
    
    _jpgURL = @"http://pic49.nipic.com/file/20140927/19617624_230415502002_2.jpg";

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
//    NSData * movData = [NSData dataWithContentsOfFile:path];
    NSData *jpgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_jpgURL]];
    [jpgData writeToURL:NET_PHOTO_FILE atomically:YES];
//    [movData writeToURL:NET_MOVIE_FILE atomically:YES];
    
    [self mergeLivePhotosWithPhotoURL:NET_PHOTO_FILE VideoURL:vidroUrl];
    
//    PHLivePhoto *livePhotoAsset = info[UIImagePickerControllerLivePhoto];
    
//    _livePhotoAsset = livePhotoAsset;
//    _pHLivePhotoView.livePhoto = _livePhotoAsset;
});
               
}
//保存LivePhot到TMP缓存
- (void)extractVideoAndPhoto {
    if (!_livePhotoAsset) {
        return;
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:PATH_PHOTO_FILE error:nil];
    
    NSArray *assetResArray= [PHAssetResource assetResourcesForLivePhoto:_livePhotoAsset];
    PHAssetResource *movieResource;
    PHAssetResource *photoResource;
    for (PHAssetResource *assetRes in assetResArray) {
        if (assetRes.type == PHAssetResourceTypePhoto) {
            photoResource = assetRes;
        }
        
        if (assetRes.type == PHAssetResourceTypePairedVideo) {
            movieResource = assetRes;
        }
    }
    
    __block NSMutableString *alertMessage = [NSMutableString new];
    [[PHAssetResourceManager defaultManager] writeDataForAssetResource:movieResource toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE] options:nil completionHandler:^(NSError * _Nullable error) {
        if (error) {
            
            NSLog(@"%@", error);
            
        } else {
            NSLog(@"movie saved path :%@", PATH_MOVIE_FILE);
        }
    }];
    
    [[PHAssetResourceManager defaultManager] writeDataForAssetResource:photoResource toFile:[NSURL fileURLWithPath:PATH_PHOTO_FILE] options:nil completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"photo saved path :%@", PATH_PHOTO_FILE);
            
            [alertMessage appendFormat:@"photo saved path :%@", PATH_PHOTO_FILE];
            [alertMessage appendFormat:@"\n movie saved path :%@", PATH_MOVIE_FILE];
            [self alertMessage:alertMessage];
        }
    }];
}

- (void)alertMessage:(NSString *)message {
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                              }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}


- (void)uploadVideoAndPhoto {
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = @"test654123";
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = @"0/8/1gPFWUQWGcfjFn6Vsn3VWDc=";
    __block UpYun *uy = [[UpYun alloc] init];
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        NSLog(@"response body %@", responseData);
        
        NSArray *array = (NSArray *)responseData;
        for (NSDictionary *dic in array) {
            if ([dic[@"mimetype"] containsString:@"image"]) {
                _jpgURL = [NSString stringWithFormat:@"%@%@", @"http://test654123.b0.upaiyun.com/", dic[@"url"]];
            } else if ([dic[@"mimetype"] containsString:@"video"]) {
                _movURL = [NSString stringWithFormat:@"%@%@", @"http://test654123.b0.upaiyun.com/", dic[@"url"]];
            }
        }
    };
    uy.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"message" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        NSLog(@"error %@", message);
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"percent %.4f", percent);
    };
//    [uy.params setObject:@"" forKey:@""];
    [uy uploadLivePhoto:_livePhotoAsset saveKey:@"testLive2"];
    
}

@end
#endif
