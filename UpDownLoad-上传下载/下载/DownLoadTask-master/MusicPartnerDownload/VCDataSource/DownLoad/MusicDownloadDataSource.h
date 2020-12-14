//
//  MusicDownloadDataSource.h
//  MusicPartnerDownload
//
//  GitHub:https://github.com/szweee
//  Blog:  http://www.szweee.com
//
//  Created by 索泽文 on 16/2/16.
//  Copyright © 2016年 索泽文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicPartnerDownloadManager.h"
#import "TaskEntity.h"

@interface MusicDownloadDataSource : NSObject

typedef void(^DownloadStatusChangeBlock)(TaskDownloadState mpDownloadState,NSString *downLoadUrlString);


// 未完成的任务
@property (nonatomic , strong) NSMutableArray *unFinishedTasks;

// 未完成的任务
@property (nonatomic , copy) DownloadStatusChangeBlock downloadStatusChangeBlock;

/**
 *  读取未下载完成的任务
 */
-(void)loadUnFinishedTasks;

/**
 *  开始下载未完成的任务
 */
-(void)startDownLoadUnFinishedTasks;

-(void)deleAllTask;


/**
 *  开始所有任务
 */
-(void)startAllTask;

/**
 *  暂停所有任务
 */
-(void)pauseAllTask;

@end
