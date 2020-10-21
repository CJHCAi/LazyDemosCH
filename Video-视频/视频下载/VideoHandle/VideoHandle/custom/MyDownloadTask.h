//
//  MyDownloadTask.h
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/21.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadViewController.h"
#import "VideoModel.h"

typedef void (^Block1)(VideoModel *);

typedef void (^Block2)();

typedef NS_ENUM(NSInteger, DownloadStatus) {
    DownloadTaskStatusRunning,     // 正在下载
    DownloadTaskStatusSuspended,   // 下载暂停
    DownloadTaskStatusCompleted,   // 下载完成
    DownloadTaskStatusFailed       // 下载失败
};

@interface MyDownloadTask : NSObject

@property (nonatomic,copy) Block1 modBlock;

@property (nonatomic,copy) Block2 proBlock;

@property (nonatomic,copy) Block2 finishBlock;

@property (nonatomic,copy) Block2 failedBlock;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSURLSessionDownloadTask *task;

@property (nonatomic,strong) NSProgress *progress;

@property (nonatomic,assign) DownloadStatus status;

//开始下载任务
- (void)resumeTaskWith:(NSString *)url and:(NSString *)title to:(DownloadViewController *)ctl;

//开始
-(void)beginTask;

//暂停
-(void)suspendTask;

//停止
-(void)cancelTask;

@end
