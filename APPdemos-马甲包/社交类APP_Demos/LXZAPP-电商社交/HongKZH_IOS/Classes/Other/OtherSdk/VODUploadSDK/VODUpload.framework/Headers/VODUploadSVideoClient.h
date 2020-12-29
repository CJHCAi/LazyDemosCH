//
//  VODUploadSimpleClient.h
//  VODUpload
//
//  Created by Worthy on 2017/11/2.
//  Copyright © 2017年 Leigang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VODUploadSVideoModel.h"

@protocol VODUploadSVideoClientDelegate <NSObject>

- (void)uploadSuccessWithResult:(VodSVideoUploadResult *)result;

- (void)uploadFailedWithCode:(NSString *)code message:(NSString *)message;

- (void)uploadProgressWithUploadedSize:(long long)uploadedSize totalSize:(long long)totalSize;

- (void)uploadTokenExpired;

- (void)uploadRetry;

- (void)uploadRetryResume;

@optional
- (void)uploadSuccessWithVid:(NSString *)vid imageUrl:(NSString *)imageUrl __deprecated_msg("using uploadSuccessWithResult: instead");

@end

@interface VODUploadSVideoClient : NSObject

@property (nonatomic, weak) id<VODUploadSVideoClientDelegate> delegate;

/**
 transcode default value is YES
 */
@property (nonatomic, assign) BOOL transcode;

/**
 Max retry count, default value is INT_MAX
 Client will retry automatically in every 2 seconds when network is unavailable
 */
@property (nonatomic, assign) uint32_t maxRetryCount;

/**
 Sets single object download's max time
 */
@property (nonatomic, assign) NSTimeInterval timeoutIntervalForRequest;

/**
 directory path about create record uploadId file
 */
@property (nonatomic, copy) NSString * recordDirectoryPath;

/**
 size of upload part, default value is 1024 * 1024
 */
@property (nonatomic, assign) NSInteger uploadPartSize;

- (BOOL)uploadWithVideoPath:(NSString *)videoPath
                  imagePath:(NSString *)imagePath
                 svideoInfo:(VodSVideoInfo *)svideoInfo
                accessKeyId:(NSString *)accessKeyId
            accessKeySecret:(NSString *)accessKeySecret
                accessToken:(NSString *)accessToken;

- (void)pause;

- (void)resume;

- (void)refreshWithAccessKeyId:(NSString *)accessKeyId
               accessKeySecret:(NSString *)accessKeySecret
                   accessToken:(NSString *)accessToken
                    expireTime:(NSString *)expireTime;

- (void)cancel;

@end
