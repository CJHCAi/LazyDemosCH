//
//  MyDownLoadTask.m
//  afDownloader
//
//  Created by MgenLiu on 14-1-20.
//  Copyright (c) 2014年 Mgen. All rights reserved.
//

#import "MyDownLoadTask.h"
#import "AFNetworking.h"

@interface MyDownLoadTask ()
{
    NSURLRequest *_request;
    AFHTTPRequestOperation *_afOperation;
}
@end

@implementation MyDownLoadTask

- (instancetype)initWithUrl:(NSString*)url DownloadProcess:(MyDownloadProcess)myDownloadProcess CompleteProcess:(MyDownloadComplete)myDownloadComplete;
{
    if(!url)
        return nil;
    
    self = [super init];
    if (!self)
        return nil;
    
    __weak MyDownLoadTask *weakSelf = self;
    _url = url;
    if (![_url hasPrefix:@"http"])
    {
        _url = [NSString stringWithFormat:@"http://%@", _url];
    }
    _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    _afOperation = [[AFHTTPRequestOperation alloc] initWithRequest:_request];
    [_afOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        weakSelf.progress = (double)totalBytesRead / totalBytesExpectedToRead;
        weakSelf.bytesProgress = [NSString stringWithFormat:@"%@/%@", [weakSelf formatByteCount:totalBytesRead], [weakSelf formatByteCount:totalBytesExpectedToRead]];
        
        if (myDownloadProcess != nil) {
            myDownloadProcess(weakSelf.progress);
        }
    }];
    [_afOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        weakSelf.bytesTotal = [weakSelf formatByteCount:operation.response.expectedContentLength];
        weakSelf.isCompleted = YES;
        
        if (myDownloadComplete != nil) {
            myDownloadComplete(weakSelf.isCompleted, weakSelf.bytesTotal, nil, operation.responseData);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        weakSelf.error = error.localizedDescription;
        weakSelf.isCompleted = NO;
        
        if (myDownloadComplete != nil) {
            myDownloadComplete(weakSelf.isCompleted, weakSelf.bytesTotal, weakSelf.error, nil);
        }
    }];
    return self;
}

- (void)start
{
    [_afOperation start];
}

- (void)stop
{
    [_afOperation cancel];
}

- (NSString*)formatByteCount:(long long)size
{
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}

@end
