//
//  ViewController.m
//  test
//
//  Created by dev1 on 2020/2/22.
//  Copyright © 2020 dev1. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "UIViewController+KK_MBProgressHUD.h"
@interface ViewController ()<NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *videoView;
@property (nonatomic, strong) AVPlayerViewController *avPlayerVC;
@property (nonatomic, strong) AVPlayer *avPlayer;

@property (nonatomic, copy) NSString *videoUrl;

@property(nonatomic,strong)NSURLSessionDownloadTask *downloadTask;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
/*
- (NSString *)resourcePath {
    return [[NSBundle mainBundle] resourcePath];
}
- (void)test1 {
    NSString *filepath = [[self resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"douyin.txt"]];
    NSString *retStr = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",retStr);
}
*/
//1
- (void)getUrlFromSrcHtmlWithSrcUrl:(NSString *)urlstr finish:(void(^)(NSString *url))block {
//    NSString *urlstr = self.textField.text;//@"https://v.douyin.com/G6HEWY/";
    NSURL *url =[NSURL URLWithString:urlstr];
    NSURLSession *session =[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask =[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString *retStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"html = %@",retStr);
            block(retStr);
        } else {
            block(nil);
        }
    }];
    [dataTask resume];
}
//2
- (void)getFakeTrueUrlWithString:(NSString *)string finish:(void(^)(NSString *url))block{
    
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:@"playAddr:\\s\".+\"" options:NSRegularExpressionAnchorsMatchLines error:nil];
    [pattern enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {

        NSString *dst = [string substringWithRange:NSMakeRange(result.range.location + 11, result.range.length - 12)];
        NSLog(@"%@", dst);
        
        block(dst);

    }];
    
}
//3
- (NSString *)getVideoUrl:(NSString *)string{
    //替换某个字符
    NSString *dst1 = [string stringByReplacingOccurrencesOfString:@"playwm" withString:@"play"];
    NSString *dst2 = [dst1 stringByReplacingOccurrencesOfString:@"line=0" withString:@"line=1"];
    NSLog(@"%@",dst2);
    
    return dst2;
}

- (IBAction)pasteButton:(UIButton *)sender {
    NSString *pboard = [UIPasteboard generalPasteboard].string;
    if (pboard.length <= 1 || !pboard) {
        return;
    }
    if ([pboard containsString:@"/play/"] && [pboard containsString:@"line=1"]) {
        self.textField.text = pboard;
        return;
    }
    
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:@"https.+/" options:NSRegularExpressionAnchorsMatchLines error:nil];
    [pattern enumerateMatchesInString:pboard options:kNilOptions range:NSMakeRange(0, pboard.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {

        if (result.range.length > 10) {

            NSString *dst = [pboard substringWithRange:NSMakeRange(result.range.location, result.range.length)];
            NSLog(@"srcUrl: %@", dst);
            
            self.textField.text = dst;
            
            *stop = YES;
        }

    }];
}

- (IBAction)jiexiButton:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self mb_showWaiting];
    });
    
     __weak typeof(self) weakSelf =self;
    
    NSString *text = self.textField.text;
    if ([text containsString:@"/play/"] && [text containsString:@"line=1"]) {
        self.videoUrl = text;
        [self playVideo:text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf mb_hideHUD];
        });
        return;
    }
    
    [self getUrlFromSrcHtmlWithSrcUrl:text finish:^(NSString *url) {
        if (url) {
            [weakSelf getFakeTrueUrlWithString:url finish:^(NSString *url) {
                NSString *videoUrl = [weakSelf getVideoUrl:url];
                weakSelf.videoUrl = videoUrl;
                [weakSelf playVideo:videoUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf mb_hideHUD];
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf mb_showError:@"解析错误"];
            });
        }
        
    }];
    
}
- (IBAction)copyVideoUrlButton:(UIButton *)sender {
    if (self.videoUrl) {
        [UIPasteboard generalPasteboard].string = self.videoUrl;
        
    }
}


- (void)playVideo:(NSString *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *playUrl = [NSURL URLWithString:url];
//        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:playUrl];//如果要切换视频需要调AVPlayer的replaceCurrentItemWithPlayerItem:方法
//
//        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
//        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//        playerLayer.frame = self.videoView.frame;//放置播放器的视图
//        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//        [self.view.layer addSublayer:playerLayer];
//        [player play];
        [self addVideoPlayerWithUrl:playUrl];
    });
}
- (void)addVideoPlayerWithUrl:(NSURL *)url {
    if (!_avPlayerVC) {
        _avPlayerVC =[[AVPlayerViewController alloc] init];
        _avPlayerVC.videoGravity = AVLayerVideoGravityResizeAspect;
        _avPlayerVC.showsPlaybackControls = YES;
        _avPlayerVC.view.frame = self.videoView.frame;
        [self.view addSubview:_avPlayerVC.view];
    }
    _avPlayer = [AVPlayer playerWithURL:url];
    _avPlayerVC.player = _avPlayer;
    [_avPlayer play];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _avPlayerVC.view.frame = self.videoView.frame;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}






/** 下载视频 */
- (IBAction)downLoadVedioButton:(UIButton *)sender {
    if (!self.videoUrl) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self mb_showWaiting];
    });
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:self.videoUrl]];
    [self.downloadTask resume];
}

    //下载完成 保存到本地相册
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *cache=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *file=[cache stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:file] error:nil];
    
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(file)) {
        
        UISaveVideoAtPathToSavedPhotosAlbum(file, self, nil, nil);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self mb_showMessage:@"保存成功"];
        });

    }
}

@end
