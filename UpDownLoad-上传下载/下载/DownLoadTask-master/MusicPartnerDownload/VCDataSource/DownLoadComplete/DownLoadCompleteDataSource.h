//
//  DownLoadCompleteDataSource.h
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

@interface DownLoadCompleteDataSource : NSObject

// 未完成的任务
@property (nonatomic , strong) NSMutableArray *finishedTasks;

/**
 *  读取下载完成的任务
 */
-(void)loadFinishedTasks;

@end
