//
//  ViewController.m
//  Example usage for CSVideoReverse class
//
//  Created by Chris Sung on 3/5/17.
//  Copyright © 2017 chrissung. All rights reserved.
//

#import "ViewController.h"


#import <MobileCoreServices/MobileCoreServices.h>

#import <AssetsLibrary/AssetsLibrary.h>
@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ViewController {
	NSString *outputPath;
	AVPlayer *avPlayer;
    NSURL * videoURL;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    UIButton * selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame=CGRectMake(100, 50, 100, 30);
    [selectBtn setTitle:@"选择相片" forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectVideo) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.backgroundColor=[UIColor redColor];
    [self.view addSubview:selectBtn];

}

-(void)selectVideo
{
    
    UIImagePickerController * pickerController=[[UIImagePickerController alloc]init];
    pickerController.delegate=self;
    pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    pickerController.editing=NO;
    [self presentViewController:pickerController animated:YES completion:nil];



}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",info);
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.movie"])
    {
        videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        [self reverseVideo];
    }
}

-(void)reverseVideo
{
  
    // 测试输入文件
//    NSString *inputPath = [[NSBundle mainBundle] pathForResource:@"input" ofType:@"mov"];
    
    //为我们创建一个路径反向输出视频
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    outputPath = [documentsPath stringByAppendingFormat:@"/reversed.mov"];
    
    // 反向视频类的实例
    CSVideoReverse *reverser = [[CSVideoReverse alloc] init];
    reverser.delegate = self;
    reverser.showDebug = YES; // NSLog逆转的细节处理
    
    // 自定义设置
    //kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange似乎是最常见的像素类型Instagram,Facebook,Twitter,et al
    reverser.readerOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey, nil];
    
    // 开始逆转过程
    [reverser reverseVideoAtPath:videoURL outputPath:outputPath];


}

#pragma mark CSVideoReverseDelegate Methods
- (void)didFinishReverse:(bool)success withError:(NSError *)error {
	if (!success) {
		NSLog(@"%s error: %@", __FUNCTION__, error.localizedDescription);
		return;
	}
	
	//否则,成功展示视频
    
    [self showReversedVideo];
    
    
    	NSURL *outputUrl = [NSURL fileURLWithPath:outputPath isDirectory:NO];
    [self saveVideoWithUrl:outputUrl];
}

- (void)showReversedVideo {
    
    
	NSURL *outputUrl = [NSURL fileURLWithPath:outputPath isDirectory:NO];
	AVURLAsset *asset = [AVURLAsset URLAssetWithURL:outputUrl options:nil];
	
	AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset];
	avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
	
	AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
	
	// 得到视图大小
	CGSize size = self.view.bounds.size;
	
	//得到视频大小
	AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
	CGFloat outputWidth = videoTrack.naturalSize.width;
	CGFloat outputHeight = videoTrack.naturalSize.height;
//    CGFloat outputWidth = self.view.frame.size.width;
//    CGFloat outputHeight =480;

	
	// 处理任何方向的细节
	CGAffineTransform txf = [videoTrack preferredTransform];
	bool isPortrait = NO;
	
	if (txf.a == 0 && txf.b == 1.0 && txf.c == -1.0 && txf.d == 0) {
        // PortraitUp
		isPortrait = YES;
	}
	else if (txf.a == 0 && txf.b == -1.0 && txf.c == 1.0 && txf.d == 0) { // PortraitDown
		isPortrait = YES;
	}
	
	// 结束相关交换
	if (isPortrait && outputWidth > outputHeight) {
		outputWidth = videoTrack.naturalSize.height;
		outputHeight = videoTrack.naturalSize.width;
	}
	else if (!isPortrait && outputHeight > outputWidth) {
		outputWidth = videoTrack.naturalSize.height;
		outputHeight = videoTrack.naturalSize.width;
	}
	
	// 设置playerLayer到视图
	CGFloat widthScale = outputWidth / size.width;
	CGFloat heightScale = outputHeight / size.height;
	CGFloat maxScale = widthScale > heightScale ? widthScale : heightScale;
	
	CGFloat displayWidth = outputWidth / maxScale;
	CGFloat displayHeight = outputHeight / maxScale;
	
	float x = (size.width - displayWidth) / 2.0;
	float y = (size.height - displayHeight) / 2.0;
	
//	playerLayer.frame = CGRectMake(x, y, displayWidth, displayHeight);
    playerLayer.frame = CGRectMake(x, 100, self.view.frame.size.width, 480);

	[playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	[self.view.layer addSublayer:playerLayer];
	
	// 设置循环
	[[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
																										object:nil
																										 queue:nil
																								usingBlock:^(NSNotification *note) {
																									[avPlayer seekToTime:kCMTimeZero]; // loop
																									[avPlayer play];
																								}];
	
	//添加事件到视图中
	[[self view] addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
	
	[avPlayer play];
}

// 视频的启动和暂停
- (void)handleTap:(UITapGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateEnded) {
		if (avPlayer.rate > 0 && !avPlayer.error) { // playing, so pause
			[avPlayer pause];
		}
		else { // stopped, so play
			[avPlayer play];
		}
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// 处理任何可以重建的资源
}


//保存视频
-(void)saveVideoWithUrl:(NSURL *)outPutUrl
{
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outPutUrl])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:outPutUrl completionBlock:^(NSURL *assetURL, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 
                 if (error)
                 {
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alert show];
                 }
                 else
                 {
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已保存到相册" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                     [alert show];
                     
                     
                 }
             });
         }];
    }
    
    
    
}


@end
