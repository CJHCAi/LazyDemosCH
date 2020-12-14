//
//  RemoteImgOperator.m
//  RemoteImgListOperatorDemo
//
//  Created by jimple on 14-1-7.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import "RemoteImgOperator.h"
#import "AFHTTPRequestOperation.h"

@protocol DownloadImgProgressDelegate <NSObject>

- (void)setProgress:(float)newProgress;

@end

@interface RemoteImgOperator ()

@property (nonatomic, readonly) AFHTTPRequestOperation *m_objAFOper;
@property (nonatomic, readonly) id <DownloadImgProgressDelegate> downloadProgressDelegate;

@end


@implementation RemoteImgOperator
@synthesize delegate;
@synthesize m_objAFOper = _objAFOper;
@synthesize downloadProgressDelegate;

- (id)init
{
    self = [super init];
    if (self)
    {
    }else{}
    return self;
}

- (void)dealloc
{
    if (_objAFOper)
    {
        [_objAFOper cancel];
        _objAFOper = nil;
    }else{}
    
    delegate = nil;
    downloadProgressDelegate = nil;
}

- (BOOL)getRemoteImgFromURL:(NSString *)strSrcURL
{
    return [self getRemoteImgFromURL:strSrcURL progressDelegate:nil];
}

- (BOOL)getRemoteImgFromURL:(NSString *)strSrcURL progressDelegate:(id)progress
{
    BOOL bRet = NO;
    
    [self cancelRequest];
    if (strSrcURL && (strSrcURL.length > 0))
    {
        bRet = YES;
        
        [self cancelRequest];
        downloadProgressDelegate = progress;
        
        __block NSString *blockStrURL = [strSrcURL copy];
        __weak typeof(self) blockSelf = self;
        _objAFOper = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strSrcURL]]];
        _objAFOper.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_objAFOper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             @try {
                 NSData *data = (NSData *)responseObject;
                 if (data)
                 {
                     if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(remoteImgOper:getImgSucc:fromURL:)])
                     {
                         // delegate 通知获取成功
                         [blockSelf.delegate remoteImgOper:blockSelf getImgSucc:data fromURL:blockStrURL];
                     }else{}
                 }
                 else
                 {
                     if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(remoteImgOper:getImgFailedFromURL:)])
                     {
                         // delegate 通知获取失败
                         [blockSelf.delegate remoteImgOper:blockSelf getImgFailedFromURL:blockStrURL];
                     }else{}
                 }
             }
             @catch (NSException *exception) {
                 if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(remoteImgOper:getImgFailedFromURL:)])
                 {
                     // delegate 通知获取失败
                     [blockSelf.delegate remoteImgOper:blockSelf getImgFailedFromURL:blockStrURL];
                 }else{}
             }
             @finally {}
         }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(remoteImgOper:getImgFailedFromURL:)])
             {
                 // delegate 通知获取失败
                 [blockSelf.delegate remoteImgOper:blockSelf getImgFailedFromURL:blockStrURL];
             }else{}
         }];
        
        [_objAFOper setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
         {
             if (blockSelf.downloadProgressDelegate)
             {
                 CGFloat f = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
                 [blockSelf.downloadProgressDelegate setProgress:f];
             }else{}
         }];
        
        [_objAFOper start];
    }
    else
    {
        bRet = NO;
    }
    
    return bRet;
}

- (void)cancelRequest
{
    if (_objAFOper)
    {
        [_objAFOper cancel];
        _objAFOper = nil;
    }else{}
}

- (void)setProgressDelegate:(id)progress
{
    downloadProgressDelegate = progress;
}

- (id)getProgressDelegate
{
    return downloadProgressDelegate;
}



















@end
