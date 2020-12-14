//
//  DLURLSessionOperation.h
//  DownloadManager
//
//  Created by 李五民 on 15/10/27.
//  Copyright © 2015年 Ideamakerz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLURLSessionOperation : NSOperation

- (instancetype)initWithSession:(NSURLSession *)session URLString:(NSString *)urlString;
- (instancetype)initWithSession:(NSURLSession *)session URLString:(NSString *)urlString ResumeData:(NSData *)resumeData;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSDate *startOperationDate;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, assign) BOOL isResume;
@property (nonatomic, assign) BOOL isSuspend;
@property (nonatomic, assign) BOOL alReadyStart;
@property (nonatomic, assign, getter=isOperationStarted) BOOL operationStarted;
- (void)completeOperation;

@end
