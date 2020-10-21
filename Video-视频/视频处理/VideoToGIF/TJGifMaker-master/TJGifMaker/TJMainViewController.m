//
//  TJMainViewController.m
//  TJGifMaker
//
//  Created by TanJian on 17/6/9.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import "TJMainViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "GIFManager.h"
#import "UIView+Extension.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import "TJImagePickerController.h"


static CGFloat KTimeMarginForGif = 0.2;//gif两张图片的时间间隔（默认）
static CGFloat KCountPerSecond = 8;//视频转gif，每秒取几张图片

@interface TJMainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *gif;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat gifMargin;

@end


@implementation TJMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _gif = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.width-300)*0.5, 70, 300, 300)];
    _gif.backgroundColor = [UIColor yellowColor];
    _gif.contentMode = UIViewContentModeScaleAspectFit;
    [_gif sd_setImageWithURL:[NSURL URLWithString:@"https://lumiere-a.akamaihd.net/v1/images/smile_-_pooh_b9b622d6.gif"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [self.view addSubview:_gif];
    
    UITextField *timeField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.width-200)*0.5, _gif.height+_gif.y, 200, 30)];
    timeField.placeholder = @"请输入gif时间间隔";
    timeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    timeField.backgroundColor = [UIColor lightGrayColor];
    timeField.textColor = [UIColor blackColor];
    timeField.delegate = self;
    [self.view addSubview:timeField];
    
    UIButton *makeGIF = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width*0.05, self.view.height-50, self.view.width*0.3, 30)];
    [makeGIF setTitle:@"图片生成gif" forState:UIControlStateNormal];
    makeGIF.backgroundColor = [UIColor lightGrayColor];
    [makeGIF addTarget:self action:@selector(makeGif) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:makeGIF];
    
//    UIButton *playGIF = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width*0.4, self.view.height-50, self.view.width*0.25, 30)];
//    [playGIF setTitle:@"播放gif" forState:UIControlStateNormal];
//    playGIF.backgroundColor = [UIColor lightGrayColor];
//    [playGIF addTarget:self action:@selector(playGif) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:playGIF];
    
    UIButton *saveGIF = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width*0.7, self.view.height-50, self.view.width*0.25, 30)];
    [saveGIF setTitle:@"保存gif" forState:UIControlStateNormal];
    saveGIF.backgroundColor = [UIColor lightGrayColor];
    [saveGIF addTarget:self action:@selector(saveGifToAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveGIF];
    
    UIButton *cutGIF = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width*0.05, self.view.height-100, self.view.width*0.25, 30)];
    [cutGIF setTitle:@"分解gif" forState:UIControlStateNormal];
    cutGIF.backgroundColor = [UIColor lightGrayColor];
    [cutGIF addTarget:self action:@selector(cutGif) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cutGIF];
    
    UIButton *videoPickBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width*0.05, self.view.height-150, self.view.width*0.25, 30)];
    [videoPickBtn setTitle:@"视频转gif" forState:UIControlStateNormal];
    videoPickBtn.backgroundColor = [UIColor lightGrayColor];
    [videoPickBtn addTarget:self action:@selector(pickVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:videoPickBtn];
    
    UIButton *cameraVideo = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width*0.35, self.view.height-150, self.view.width*0.3, 30)];
    [cameraVideo setTitle:@"拍视频转gif" forState:UIControlStateNormal];
    cameraVideo.backgroundColor = [UIColor lightGrayColor];
    [cameraVideo addTarget:self action:@selector(videoWithCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraVideo];

    UIButton *photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width*0.05, self.view.height-200, self.view.width*0.25, 30)];
    [photoBtn setTitle:@"照片转gif" forState:UIControlStateNormal];
    photoBtn.backgroundColor = [UIColor lightGrayColor];
    [photoBtn addTarget:self action:@selector(makeGifWithPhotos) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
}


//图片合成gif
-(void)makeGif{
    
    [self finishTimer];
    
    NSMutableArray *gifImages = [NSMutableArray arrayWithCapacity:2];
    for (int i = 0; i<13; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [gifImages addObject:image];
        
    }
    
//    self.gif.image = [[GIFManager shareInstance] animatedGIFWithImages:gifImages marginDuration:_gifMargin>0?_gifMargin:KTimeMarginForGif];
    
    __weak typeof(self) weakself = self;
    [[GIFManager shareInstance] composeGIF:gifImages playTime:_gifMargin>0?_gifMargin:KTimeMarginForGif complete:^{
        
        [weakself playGif];
        
    }];
    
}

//现有gif分解成图片
-(void)cutGif{
    
    [self finishTimer];
    
    NSString *gifpath=[[NSBundle mainBundle]pathForResource:@"gif5" ofType:@"gif"];
    
    __weak typeof(self) weakself = self;
    [[GIFManager shareInstance] decomposeGIF:gifpath outputType:GIF_OUTPUT_TYPE_IMAGE complete:^(NSArray *imageArr,GIF_OUTPUT_TYPE type){
        
        __block int i = 0;
        
        if (type == GIF_OUTPUT_TYPE_IMAGE) {
            
            weakself.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                
                UIImage *image = imageArr[i];
                weakself.gif.image = image;
                i++;
            }];
            
        }else{
            
            weakself.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                
                if (i == imageArr.count) {
                    i = 0;
                }
                NSString *imgPath = imageArr[i];
                [weakself.gif sd_setImageWithURL:[NSURL fileURLWithPath:imgPath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    NSLog(@"%d",i);
                    i++;
                    
                }];
                
            }];
            
        }
        
    }];
  
}
//结束timer
-(void)finishTimer{
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
}


//播放gif
-(void)playGif{
    
    NSURL *gifPath = [[GIFManager shareInstance] currentUrl];
    
    [_gif sd_setImageWithURL:gifPath completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        NSLog(@"加载完成");

    }];

}

//保存gif到相册
-(void)saveGifToAlbum{
    
    NSURL *gifPath = [[GIFManager shareInstance] currentUrl];
    NSData *gifData = [NSData dataWithContentsOfURL:gifPath];
    
    [[GIFManager shareInstance] saveGIFToAlbumWithData:gifData];
    
}

//相册选择视频
-(void)pickVideo{
    
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeVideo,kUTTypeMovie,kUTTypeMPEG4, nil];
    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

//相机拍摄视频
-(void)videoWithCamera{
    
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeVideo,kUTTypeMovie,kUTTypeMPEG4, nil];
    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

//相机选择照片
-(void)makeGifWithPhotos{
    
    TJImagePickerController *picker = [[TJImagePickerController alloc]init];
    
    __weak typeof(self) weakself = self;
    picker.photoPickDoneBlock = ^(NSArray *imageArr){
        
        //如果需要加入到微信表情，需要对其进行缩放
//        NSMutableArray *newImgArr = [NSMutableArray arrayWithCapacity:2];
//        for (UIImage *image in imageArr) {
//            UIImage *newImg = [[GIFManager shareInstance] scaleImage:image toScale:0.3];
//            [newImgArr addObject:newImg];
//        }
        
        [[GIFManager shareInstance] composeGIF:imageArr playTime:_gifMargin>0?_gifMargin:KTimeMarginForGif complete:^{
            
            [weakself playGif];
        }];
        
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:picker];
    [self presentViewController:nav animated:YES completion:nil];
    
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
    }else{
        
        [self finishTimer];
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
        CMTime durtion = asset.duration;
        CGFloat timeLength = durtion.value/durtion.timescale;
        NSLog(@"%ld",(long)timeLength);
        
        NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:2];
        for (int i = 0; i<timeLength*KCountPerSecond; i++) {
            
            UIImage *image = [[GIFManager shareInstance] getCoverImage:url atTime:i/KCountPerSecond isKeyImage:NO];
            [imageArr addObject:image];
            
            
           // 微信要求gif为240*240（时间不能太长，不然微信限制表情添加）
            if (image.size.height>image.size.width) {
                
                CGFloat scale = 230.0/image.size.height;
                //如果需要加入到微信表情，需要对其进行缩放
                UIImage *newImg = [[GIFManager shareInstance] scaleImage:image toScale:scale];
                [imageArr addObject:newImg];
            }else{
                
                CGFloat scale = 230.0/image.size.width;
                //如果需要加入到微信表情，需要对其进行缩放
                UIImage *newImg = [[GIFManager shareInstance] scaleImage:image toScale:scale];
                [imageArr addObject:newImg];
            }
            
            
        }
        
//        _gif.image = [[GIFManager shareInstance] animatedGIFWithImages:imageArr marginDuration:_gifMargin>0?_gifMargin:KTimeMarginForGif complete:^{
//            
//
//            
//        }];
        
        __weak typeof(self) weakself = self;
        [[GIFManager shareInstance] composeGIF:imageArr playTime:_gifMargin>0?_gifMargin:KTimeMarginForGif complete:^{
            
            [weakself playGif];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark textfield代理
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    _gifMargin = textField.text.floatValue;
    
    if (_gifMargin>10) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"时间过长,应该在0到10秒" message:@"取默认值0.2" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        textField.text = [NSString stringWithFormat:@"%.2f",KTimeMarginForGif];
    }else if (_gifMargin<0){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"时间错误,应该在0到10秒" message:@"取默认值0.2" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        textField.text = [NSString stringWithFormat:@"%.2f",KTimeMarginForGif];
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    _gifMargin = KTimeMarginForGif;
    
}

@end
