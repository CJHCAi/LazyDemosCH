//
//  DownloadTool.h
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/13.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadViewController.h"
#import "VideoModel.h"
#import "MyDownloadTask.h"

typedef void (^Block1)(VideoModel *);

typedef void (^Block2)();

typedef void (^Block3)(MyDownloadTask *);

@interface DownloadTool : NSObject

@property (nonatomic,copy) Block1 modBlock;

@property (nonatomic,copy) Block2 finishBlock;

@property (nonatomic,copy) Block3 failedBlock;

@property (nonatomic,copy) Block3 proBlock;

@property (nonatomic,strong) NSMutableArray *taskArr;

+ (instancetype)sharedInstance;

//创建下载任务
-(void)downFileFromServer:(NSString *)url and:(NSString *)title andCtl:(DownloadViewController *)ctl;

//开始下载
-(void)beginTask:(NSInteger)index;

//暂停
-(void)suspendTask:(NSInteger)index;

//停止
-(void)cancelTask:(NSInteger)index;

@end
