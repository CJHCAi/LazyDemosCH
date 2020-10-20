//
//  SSNetManager.m
//  TestAFNetWorking
//
//  Created by shj on 2018/6/10.
//  Copyright © 2018年 shj. All rights reserved.
//

#import "SSNetManager.h"
#import <AFNetworking/AFNetworking.h>

@interface SSNetManager()
@property (strong, nonatomic) AFURLSessionManager *sessionManager;
@end

@implementation SSNetManager

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static SSNetManager *obj = nil;
    dispatch_once(&onceToken, ^{
        obj = [[SSNetManager alloc] init];
    });
    return obj;
} 

- (void)downloadFile:(NSURL *)url
            progress:(void (^)(float progress))progressBlock
            complete:(void (^)(NSURL *filePathUrl))completeBlock {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        progressBlock(downloadProgress.fractionCompleted);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 下载的路径设置
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *destinationRUL = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        NSLog(@"%@", destinationRUL.absoluteString);
        return destinationRUL;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completeBlock(filePath);
    }];
    [downloadTask resume];
}

#pragma mark - Object

- (AFURLSessionManager *)sessionManager {
    if (_sessionManager) {
        return _sessionManager;
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    return _sessionManager;
}

@end















