//
//  MyDownloadTask.m
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/21.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import "MyDownloadTask.h"
#import <AVFoundation/AVFoundation.h>
#import "DownloadTool.h"

@interface MyDownloadTask ()
{
    NSString *_size;
    
    NSInteger _flag;
}

@end

@implementation MyDownloadTask

//初始化
- (instancetype)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

//开始下载任务
- (void)resumeTaskWith:(NSString *)url and:(NSString *)title to:(DownloadViewController *)ctl{
    
    self.url = url;
    self.title = title;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configuration.timeoutIntervalForRequest = 120;
    configuration.timeoutIntervalForResource = 120;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //同步操作，先建立任务再开始
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //下载Task操作
        _task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] progress:^(NSProgress * _Nonnull downloadProgress) {
            
            _size = [NSString stringWithFormat:@"%.1fM",1.0 * downloadProgress.totalUnitCount / 1024 / 1024];
            
            self.progress = downloadProgress;
            
            //异步通知tableview刷新下载进度
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                if (ctl.tableView2) {
                    
                    self.proBlock();
                }
            });
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            
            NSString *filePath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",title]];
            
            //如果同名文件已经存在，则默认在文件名后面加一个(1),(2)...以此类推，要不然保存到相册会出问题
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                
                NSInteger flag = [[DEFAULT objectForKey:@"flag"] integerValue];
                
                if (!flag) {
                    
                    flag = 1;
                }
                
                filePath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@(%ld).mp4",title,flag++]];
                
                [DEFAULT setObject:@(flag) forKey:@"flag"];
            }
            
            return [NSURL fileURLWithPath:filePath];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            if (!error) {
                //通知将完成的任务从任务数组中移除
                self.status = DownloadTaskStatusCompleted;
                self.finishBlock();
                
                //下载完毕之后，将视频信息存储到模型中
                NSDictionary *dic = [self getVideoMsgFromPath:url];
                VideoModel *model = [VideoModel new];
                model.url = url;
                model.poster = UIImagePNGRepresentation(dic[@"poster"]);
                model.title = title;
                model.duration = dic[@"duration"];
                model.memorySize = _size;
                model.path = [filePath path];
                
                //解档取出原有的模型数组
                NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:VIDEO];
                
                if (arr) {
                    
                    [arr addObject:model];
                    
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
                    if ([data writeToFile:VIDEO atomically:YES]){
                        
                        NSLog(@"写入成功");
                    }else{
                        
                        NSLog(@"写入失败");
                    }
                }else{
                    
                    arr = [NSMutableArray new];
                    [arr addObject:model];
                    
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
                    if ([data writeToFile:VIDEO atomically:YES]){
                        
                        NSLog(@"写入成功");
                    }else{
                        
                        NSLog(@"写入失败");
                    }
                }
                
                self.modBlock(model);
                
                //保存到本地相册
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([filePath path])) {
                    
                    UISaveVideoAtPathToSavedPhotosAlbum([filePath path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
            }else{
                
                NSLog(@"%@",error);
                
                HUDTEXT(error.localizedDescription, ctl.view);
                self.status = DownloadTaskStatusFailed;
                
                if (error.code != -999) {  //-999是取消下载任务，不回调失败
                    
                    self.failedBlock();
                }
            }
        }];
    });
    
    //任务建好之后开始下载
    [_task resume];
    
    //状态为正在下载
    _status = DownloadTaskStatusRunning;
}
//
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    
    if (!error) {
        
        NSLog(@"%@",videoPath);
    }else{
        
        NSLog(@"%@",error);
    }
}
//获取视频的各种信息 (视频略缩图，视频时长，视频大小)
- (NSDictionary *)getVideoMsgFromPath:(NSString *)filePath{
    //视频路径URL
    NSURL *fileURL = [NSURL URLWithString:filePath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    //略缩图
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *shotImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    //时长
    CMTime videoTime = [asset duration];
    NSInteger seconds = ceil(videoTime.value / videoTime.timescale);
    
    if (shotImage == nil || [self formatFromSecond:seconds] == nil) {
        
        return @{};
    }
    //放到一个字典中返回
    return @{@"poster" : shotImage,
             @"duration" : [self formatFromSecond:seconds]};
}
//传入 秒  得到 xx:xx:xx
-(NSString *)formatFromSecond:(NSInteger)seconds{
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",(long)seconds / 3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(long)(seconds % 3600) / 60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",(long)seconds % 60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}
//开始
-(void)beginTask{
    
    [_task resume];
    
    //状态为正在下载
    _status = DownloadTaskStatusRunning;
}
//暂停
-(void)suspendTask{
    
    [_task suspend];
    
    //状态为暂停下载
    _status = DownloadTaskStatusSuspended;
}
//停止
-(void)cancelTask{

    [_task cancel];
}


@end
