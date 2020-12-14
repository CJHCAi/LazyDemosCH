//
//  TaskEntity.h
//  MusicPartnerDownload
//
//  GitHub:https://github.com/szweee
//  Blog:  http://www.szweee.com
//
//  Created by 索泽文 on 16/2/12.
//  Copyright © 2016年 索泽文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    TaskStateRunning       = 1,/** 下载中 */
    TaskStateSuspended     = 2,/** 下载暂停 */
    TasktateCompleted      = 3,/** 下载完成 */
    TaskStateFailed        = 4 /** 下载失败 */
}TaskDownloadState;


typedef void(^TaskEntityDownloadProgressBlock)(CGFloat progress, CGFloat totalMBRead, CGFloat totalMBExpectedToRead);

typedef void(^TaskEntityDownloadCompleteBlock)(TaskDownloadState mpDownloadState,NSString *downLoadUrlString);


@interface TaskEntity : NSObject

@property (nonatomic , strong) NSString *downLoadUrl;

// 任务状态
@property (nonatomic , assign) TaskDownloadState taskDownloadState;

@property (nonatomic , assign) CGFloat progress;

@property (nonatomic , copy) TaskEntityDownloadProgressBlock progressBlock;
@property (nonatomic , copy) TaskEntityDownloadCompleteBlock completeBlock;


@property (nonatomic , strong) NSString *imgName;

@property (nonatomic , strong) NSString *name;

@property (nonatomic , strong) NSString *desc;

@property (nonatomic , strong) NSString *mpDownLoadPath;

@end
