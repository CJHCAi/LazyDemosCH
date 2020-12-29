//
//  MyDownLoadTask.h
//  afDownloader
//
//  Created by MgenLiu on 14-1-20.
//  Copyright (c) 2014年 Mgen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MyDownloadProcess)(CGFloat progress);
typedef void(^MyDownloadComplete)(BOOL isCompleted, NSString* strByteTotal, NSString *error, NSData *responseData);

@interface MyDownLoadTask : NSObject

@property (nonatomic, strong, readonly) NSString *url;
- (instancetype)initWithUrl:(NSString*)url DownloadProcess:(MyDownloadProcess)myDownloadProcess CompleteProcess:(MyDownloadComplete)myDownloadComplete;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL isCompleted;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *bytesProgress;
@property (nonatomic, strong) NSString *bytesTotal;

- (void)start;
- (void)stop;

@end
