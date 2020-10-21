//
//  ViewController.m
//  LivePhoto-master
//
//  Created by BY_R on 2017/3/2.
//  Copyright © 2017年 BY_R. All rights reserved.
//
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ViewController.h"
#import "JPEG.h"
#import "QuickTimeMov.h"

@interface ViewController ()
@property (nonatomic, strong) PHLivePhotoView   *livePhotoView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.livePhotoView];
    [self loadVideoWithVideoURL:[[NSBundle mainBundle] URLForResource:@"video" withExtension:@"m4v"]];
}

#pragma mark - private
- (void)loadVideoWithVideoURL:(NSURL *)videoURL {
    
    self.livePhotoView.livePhoto = nil;
    // 初始化媒体文件
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
    // AVAssetImageGenerator 该类用于截取视频指定帧的画面
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    // 设定缩略图的方向
    // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
    generator.appliesPreferredTrackTransform = YES;
    
    NSValue *time = [NSValue valueWithCMTime:CMTimeMakeWithSeconds(CMTimeGetSeconds(asset.duration)/2, asset.duration.timescale)];
    // 取出视频每一帧图片
    [generator generateCGImagesAsynchronouslyForTimes:@[time] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (image) {
            
            NSData *data = UIImagePNGRepresentation([UIImage imageWithCGImage:image]);
            if (data.length) {
                // 写文件
                NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
                NSURL *imageURL = [urls[0] URLByAppendingPathComponent:@"image.jpg"];
                NSError *witeError = nil;
                [data writeToURL:imageURL options:NSDataWritingAtomic error:&witeError];
                if (error) {
                    NSLog(@"writeError: %@",error);
                }
                // 获取图片路径
                NSString *image = [imageURL path];
                // 获取视频路径
                NSString *mov = videoURL.path;
                
                NSString *output = [self filePath];
                NSString *assetIdentifier = [NSUUID UUID].UUIDString;
                
                
                @try {
                    NSError *remError = nil;
                    BOOL remRet = [[NSFileManager defaultManager] removeItemAtPath:[output stringByAppendingString:@"/IMG.JPG"] error:&remError];
                    NSError *remoError = nil;
                    BOOL remoRet = [[NSFileManager defaultManager] removeItemAtPath:[output stringByAppendingString:@"/IMG.MOV"] error:&remoError];
                    NSLog(@"remRet: %d, remError: %@; remoRet: %d, remoError: %@", remRet, remError, remoRet, remoError);
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                JPEG *jpeg = [[JPEG alloc] initWithPath:image];
                [jpeg write:[output stringByAppendingString:@"/IMG.JPG"] assetIdentifier:assetIdentifier];
                QuickTimeMov *quickMov = [[QuickTimeMov alloc] initWithPath:mov];
                [quickMov write:[output stringByAppendingString:@"/IMG.MOV"] assetIdentifier:assetIdentifier];
                
                NSArray *urlArray = @[
                                      [NSURL fileURLWithPath:[[self filePath] stringByAppendingString:@"/IMG.MOV"]],
                                      [NSURL fileURLWithPath:[[self filePath] stringByAppendingString:@"/IMG.JPG"]]
                                      ];
                /*
                 * 获取PHLivePhoto图片
                 * 这个回调的调用次数跟urls数组中元素个数有关
                 *  fileURLs    图片地址
                 *  image       正在加载时的静态图片
                 *  targetSize  显示大小
                 *  contentModel图像剪裁方式
                 *  return      返回唯一标识符
                 */
                [PHLivePhoto requestLivePhotoWithResourceFileURLs:urlArray placeholderImage:nil targetSize:self.livePhotoView.bounds.size contentMode:PHImageContentModeAspectFit resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nonnull info) {
                    
                    self.livePhotoView.livePhoto = livePhoto;
                    if (info[PHLivePhotoInfoCancelledKey] != nil) {
                        [self exportLivePhoto];
                    }
                }];
            }
        }
    }];
}
// 保存到本地相册
- (void)exportLivePhoto {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAsset];
        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
        
        [creationRequest addResourceWithType:PHAssetResourceTypePairedVideo fileURL:[NSURL fileURLWithPath:[[self filePath] stringByAppendingString:@"/IMG.MOV"]] options:options];
        [creationRequest addResourceWithType:PHAssetResourceTypePhoto fileURL:[NSURL fileURLWithPath:[[self filePath] stringByAppendingString:@"/IMG.JPG"]] options:options];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@">>>>>> %d, %@", success, error);
    }];
}

- (NSString *)filePath {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path[0] stringByAppendingString:@"/"];
    NSLog(@"filePath: %@",filePath);
    return filePath;
}

#pragma mark - getter and setters
- (PHLivePhotoView *)livePhotoView {
    if (!_livePhotoView) {
        _livePhotoView = [[PHLivePhotoView alloc] initWithFrame:self.view.bounds];
        _livePhotoView.contentMode = UIViewContentModeScaleAspectFill;
        _livePhotoView.clipsToBounds = YES;
    }
    return _livePhotoView;
}
@end
