//
//  DLDownloadModel.h
//  DownLoadTest
//
//  Created by 李五民 on 15/10/24.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DLDownloadUrlModel.h"
#import "DLURLSessionOperation.h"
@interface DLDownloadModel : JSONModel

@property (nonatomic, strong) DLDownloadUrlModel *urlModel;
@property (nonatomic,assign) NSInteger totalSize;
@property (nonatomic, assign) NSInteger currentSize;
@property (nonatomic, assign) NSInteger statusTask;
@property (nonatomic, assign) NSInteger buttonStatus;
@property (nonatomic, assign) NSInteger downloadSpeed;
@property (nonatomic, assign) float progress;
@property (nonatomic, copy) NSString *speed;

@end
