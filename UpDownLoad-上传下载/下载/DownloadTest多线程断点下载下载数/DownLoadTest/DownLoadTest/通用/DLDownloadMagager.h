//
//  DLDownloadMagager.h
//  DownLoadTest
//
//  Created by 李五民 on 15/10/26.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLURLSessionOperation.h"

@protocol YDLDownloadMagagerDelegate <NSObject>

- (void)didReceiveDataWithSpeed:(NSString *)speed progress:(float)progress taskUrlString:(NSString *)taskUrlString;

- (void)didFinishDownloadTaskWithOperation:(NSString *)taskUrlString;

- (void)downloadError:(NSString *)taskUrlString error:(NSError *)error;

@end

@interface DLDownloadMagager : NSObject

+ (DLDownloadMagager *)sharedManager;
@property (nonatomic ,strong) NSURLSession *session;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) NSMutableDictionary *operationDictionary;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, assign) NSUInteger currentNetStatus;
@property (nonatomic, assign) BOOL isWWANDownload;
@property (nonatomic, weak) id<YDLDownloadMagagerDelegate> delegate;
@end
