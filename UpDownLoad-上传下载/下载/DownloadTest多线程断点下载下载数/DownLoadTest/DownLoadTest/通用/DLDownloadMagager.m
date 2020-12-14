//
//  DLDownloadMagager.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/26.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLDownloadMagager.h"
#import "NSString+Hash.h"
#import "DLURLSessionOperation.h"
#import "MZUtility.h"
#import "AppDelegate.h"

@interface DLDownloadMagager()<NSURLSessionDelegate>

@property (nonatomic, strong) NSOutputStream *stream;
@property (nonatomic, assign) NSUInteger contentLength;
@property (nonatomic, copy) NSString *contentPath;
@property (nonatomic, strong) NSMutableArray *downloadArray;

@end

@implementation DLDownloadMagager

+ (DLDownloadMagager *)sharedManager
{
    static DLDownloadMagager *downloadManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadManager = [[DLDownloadMagager alloc] init];
    });
    return downloadManager;
}

- (id)init{
    self = [super init];
    if (self) {
        self.currentNetStatus = -1;
        self.isWWANDownload = YES;
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 2;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"yanxiu.DownLoadTest"];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        self.downloadArray = [[NSMutableArray alloc] init];
        self.operationDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - NSURLSession Delegates
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",downloadTask.taskDescription);
        float progress = (double)downloadTask.countOfBytesReceived/(double)downloadTask.countOfBytesExpectedToReceive;
        DLURLSessionOperation *operation = [self.operationDictionary objectForKey:downloadTask.taskDescription];
        NSTimeInterval downloadTime = -1 * [operation.startOperationDate timeIntervalSinceNow];
        NSString *speed = [NSString stringWithFormat:@"%.2f %@",[MZUtility calculateFileSizeInUnit:(unsigned long long)(bytesWritten / downloadTime)],[MZUtility calculateUnit:(unsigned long long)(unsigned long long)(bytesWritten / downloadTime)]];
        operation.startOperationDate = [NSDate date];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveDataWithSpeed:progress:taskUrlString:)]) {
            [self.delegate didReceiveDataWithSpeed:speed progress:progress taskUrlString:downloadTask.taskDescription];
        }
    //});
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *fileNameByMD5 = [downloadTask.taskDescription md5String];
    NSString *destinationPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"] stringByAppendingPathComponent:fileNameByMD5];
    NSURL *fileURL = [NSURL fileURLWithPath:destinationPath];
    NSLog(@"directory Path = %@",destinationPath);
    if(![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        if (location) {
            NSError *error = nil;
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileURL error:&error];
            if (error)
                [MZUtility showAlertViewWithTitle:@"DLDownloadManager" msg:error.localizedDescription];
        }
    }
    DLURLSessionOperation *operation = [self.operationDictionary objectForKey:downloadTask.taskDescription];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishDownloadTaskWithOperation:)]) {
        [self.delegate didFinishDownloadTaskWithOperation:downloadTask.taskDescription];
    }
    [operation cancel];
    [operation completeOperation];
    [self.operationDictionary removeObjectForKey:downloadTask.taskDescription];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(error)
    {
        if(error.code != NSURLErrorCancelled)
        {
            DLURLSessionOperation *operation = [[DLDownloadMagager sharedManager].operationDictionary objectForKey:task.taskDescription];
            operation.resumeData = (NSData *)[error.userInfo objectForKey:@"NSURLSessionDownloadTaskResumeData"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishDownloadTaskWithOperation:)]) {
                [self.delegate downloadError:task.taskDescription error:error];
            }
        }
    }
}
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
    
    if ([DLDownloadMagager sharedManager].queue.operationCount > 0) {
        [[DLDownloadMagager sharedManager].queue cancelAllOperations];
    };
}

@end
