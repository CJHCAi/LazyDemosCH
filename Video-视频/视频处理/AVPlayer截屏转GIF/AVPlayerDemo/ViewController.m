//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by 李强 on 17/2/27.
//  Copyright © 2017年 李强. All rights reserved.
//

#import "ViewController.h"
#import "LQPlayerProgressLine.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import "UIImage+GIF.h"
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    AVPlayer *player;
    AVPlayerItem *playerItem;
    LQPlayerProgressLine * progressView;
    AVPlayerItemVideoOutput *videoOutput;
    
    
    //判断slider是否按下，
    BOOL isOpen;
}
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) CMTime current;
@property (nonatomic, weak) UIButton *imageV;
@property (nonatomic, weak) AVPlayer *playLayer;
@property (nonatomic, strong) UIImagePickerController *piker;
@property (nonatomic, assign) BOOL flag;
@property (nonatomic, strong) NSMutableArray *thumbnailArray;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    //进行初始化创建
    //    NSURL *url = [NSURL URLWithString:@"http://asp.cntv.lxdns.com/asp/hls/main/0303000a/3/default/c056c9829b4842daaa7259a31cef8f19/main.m3u8"];//http://vdn.apps.cntv.cn/api/getHttpVideoInfo.do?pid=364df9c2d319479e8bcf0a5628bd254e
    NSURL *url = [NSURL URLWithString:@"http://vod.cntv.lxdns.com/flash/mp4video58/TMS/2017/03/12/364df9c2d319479e8bcf0a5628bd254e_h26412000000nero_aac128-2.mp4"];
    self.url = url;
    NSDictionary *settings = @{(id)kCVPixelBufferPixelFormatTypeKey :
                                   [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                               };
    videoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:settings];
    playerItem=[AVPlayerItem playerItemWithURL:url];
    [playerItem addOutput:videoOutput];
    //创建player
    player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
    //生成layer层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    self.playLayer = player;
    //设置坐标
    layer.frame = CGRectMake(0, 0, 480, 480);
    
    //把layer层假如到self.view.layer中
    [self.view.layer addSublayer:layer];
    //进行播放
    [player play];
    
    /**以上是基本的播放界面，但是没有前进后退**/
    //观察是否播放，KVO进行观察，观察playerItem.status
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //观察缓存现在的进度，KVO进行观察，观察loadedTimeRanges
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //显示GIF图的按钮
    UIButton *view= [[UIButton alloc]initWithFrame:CGRectMake(50, 500, 100, 100)];
    [self.view addSubview:view];
    [view addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    view.backgroundColor = [UIColor redColor];
    self.imageV = view;
    //长按手势截GIF图
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longp:)];
    [self.view addGestureRecognizer:longP];
}
- (void)longp:(UILongPressGestureRecognizer *)longp{
    NSLog(@"%zd",longp.state);
    switch (longp.state) {
        case UIGestureRecognizerStateBegan:
            self.flag = YES;
            [self getThumbnails];
            NSLog(@"开始截图");
            break;
        case UIGestureRecognizerStateEnded:
            self.flag = NO;
            NSLog(@"结束截图");
            NSLog(@"----%@",self.thumbnailArray);
            //生成gif
            [self.imageV setImage:[self createGitWithImageArray:self.thumbnailArray] forState:UIControlStateNormal];
            [self.thumbnailArray removeAllObjects];
            
            break;
        default:
            break;
    }
}
- (void)getThumbnails{
    [self screenShot];
    
}
- (UIImage *)createGitWithImageArray:(NSArray <UIImage *> *)imageArray{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"animated4.gif"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
        NSLog(@"删除--");
    }
    CGImageDestinationRef destination =CGImageDestinationCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path], kUTTypeGIF, imageArray.count, NULL);
    
    NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.3f] forKey:(NSString *)kCGImagePropertyGIFDelayTime] forKey:(NSString *)kCGImagePropertyGIFDictionary];
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:(NSString *)kCGImagePropertyGIFLoopCount]forKey:(NSString *)kCGImagePropertyGIFDictionary];
    for (int i = 0; i<imageArray.count; i++) {
        UIImage *shacho = imageArray[i];
        CGImageDestinationAddImage(destination, shacho.CGImage, (CFDictionaryRef)frameProperties);
    }
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
//    NSLog(@"animated GIF file created at %@", path);
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return [UIImage sd_animatedGIFWithData:data];
}

-(IBAction)screenShot{
    if (self.flag) {
        
        if(player.currentItem.status == AVPlayerStatusReadyToPlay){
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                
                CMTime currentTime = player.currentItem.currentTime;
                
                CVPixelBufferRef buffer = [videoOutput copyPixelBufferForItemTime:currentTime itemTimeForDisplay:nil];
                
                CIImage *ciImage = [CIImage imageWithCVPixelBuffer:buffer];
                
                CIContext *temporaryContext = [CIContext contextWithOptions:nil];
                CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(buffer), CVPixelBufferGetHeight(buffer))];
                
                UIImage *image = [UIImage imageWithCGImage:videoImage];
                [self.thumbnailArray addObject:image];
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self screenShot];
                    NSLog(@"------");
                });
            });
        }
    }
}
//清楚按钮上的图片
- (void)tap:(UIButton *)tap{
    [self.imageV setImage:nil forState:UIControlStateNormal];
}

//观察是否播放
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        if (playerItem.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"开始播放");
            //需要开始获取数据，包括播放的总时长，播放的缓存，播放的当时时间
            [self loadData];
        }else{
            NSLog(@"播放失败");
        }
    }else{
        //kvo触发的另外一个属性
        NSArray *array = [playerItem loadedTimeRanges];
        //获取范围i
        CMTimeRange range = [array.firstObject CMTimeRangeValue];
        //从哪儿开始的
        CGFloat start = CMTimeGetSeconds(range.start);
        //缓存了多少
        CGFloat duration = CMTimeGetSeconds(range.duration);
        //一共缓存了多少
        CGFloat allCache = start+duration;
        //        NSLog(@"缓存了多少数据：%f",allCache);
        
        //设置缓存的百分比
        CMTime allTime = [playerItem duration];
        //转换
        CGFloat time = CMTimeGetSeconds(allTime);
        CGFloat y = 0;
        if(time > 0){
            y = allCache/time;
        }
        //        NSLog(@"缓存百分比：--------%f",y);
        if (!isnan(y)) {
            progressView.cacheProgress = y;
        }
    }
}


#pragma mark -- 获取播放数据
- (void)loadData{
    
    __weak typeof(playerItem) weakItem = playerItem;
    __weak typeof(progressView) weakPro = progressView;
    __weak typeof(self) weakSelf = self;
    //第一个参数是每隔多长时间调用一次，在这里设置的是每隔1秒调用一次
    [player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        //当前播放时间
        weakSelf.current = time;
        CGFloat current = weakItem.currentTime.value/weakItem.currentTime.timescale;
        //获取总时长
        CMTime time1 = weakItem.duration;
        float x = CMTimeGetSeconds(time1);
        //设置滑动条进度
        float v = current/x;

        weakPro.playProgress = v;
    }];
}

#pragma mark --- 创建UI
- (void)createUI{
    CGRect rect = CGRectMake(0, 480, self.view.frame.size.width, 6);
    progressView = [LQPlayerProgressLine playerProgressLineWithFrame:rect];
    [self.view addSubview:progressView];
}

//添加点击事件
- (void)sliderClick:(UISlider *)slider{
    NSLog(@"添加点击事件");
    isOpen = YES;
}

//抬起来的事件
- (void)sliderClickUp:(UISlider *)slider{
    NSLog(@"抬起来的事件");
    isOpen = NO;
    
    
    //从这里开始播放
    CGFloat g = slider.value;
    //获取总时长
    CMTime time1 = playerItem.duration;
    float x = CMTimeGetSeconds(time1);
    //进行播放
    [player seekToTime:CMTimeMake(x * g,1)];
    //播放
    [player play];
    
}

- (NSMutableArray *)thumbnailArray{
    if (_thumbnailArray == nil) {
        _thumbnailArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return _thumbnailArray;
}


@end
