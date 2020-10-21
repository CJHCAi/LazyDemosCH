//
//  DownloadTool.m
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/13.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import "DownloadTool.h"
#import <AVFoundation/AVFoundation.h>

@interface DownloadTool ()


@end


@implementation DownloadTool
//
-(NSMutableArray *)taskArr{

    if (!_taskArr) {
        
        _taskArr = [NSMutableArray new];
    }
    return _taskArr;
}
//
+ (instancetype)sharedInstance{
    
    static DownloadTool *shareTool = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        shareTool = [[DownloadTool alloc]init];
    });
    
    return shareTool;
}
//
-(void)downFileFromServer:(NSString *)url and:(NSString *)title andCtl:(DownloadViewController *)ctl{
    
    MyDownloadTask *downloadTask = [[MyDownloadTask alloc]init];
    
    [downloadTask resumeTaskWith:url and:title to:ctl];
    
    [self.taskArr addObject:downloadTask];
    
    __weak typeof(MyDownloadTask *) weakTask = downloadTask;
    
    downloadTask.proBlock = ^{
        
        self.proBlock(weakTask);
    };
    
    downloadTask.finishBlock = ^{
    
        [_taskArr removeObject:weakTask];
        
        self.finishBlock();
    };
    
    downloadTask.modBlock = ^(VideoModel *model){
        
        self.modBlock(model);
    };
    
    downloadTask.failedBlock = ^{
    
        self.failedBlock(weakTask);
    };
}

//开始下载
-(void)beginTask:(NSInteger)index{

    MyDownloadTask *downloadTask = _taskArr[index];
    
    [downloadTask beginTask];
}
//暂停
-(void)suspendTask:(NSInteger)index{

    MyDownloadTask *downloadTask = _taskArr[index];
    
    [downloadTask suspendTask];
}
//停止
-(void)cancelTask:(NSInteger)index{

    MyDownloadTask *downloadTask = _taskArr[index];
    
    [downloadTask cancelTask];
}

@end
