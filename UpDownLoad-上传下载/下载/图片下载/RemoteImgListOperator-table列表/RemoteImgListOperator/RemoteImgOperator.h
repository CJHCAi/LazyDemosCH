//
//  RemoteImgOperator.h
//  RemoteImgListOperatorDemo
//
//  Created by jimple on 14-1-7.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RemoteImgOperatorDelegate;
@interface RemoteImgOperator : NSObject

@property (unsafe_unretained) id<RemoteImgOperatorDelegate>delegate;

// 从网络下载图片
- (BOOL)getRemoteImgFromURL:(NSString *)strSrcURL;
- (BOOL)getRemoteImgFromURL:(NSString *)strSrcURL progressDelegate:(id)progress;

// 取消下载
- (void)cancelRequest;

- (void)setProgressDelegate:(id)progress;
- (id)getProgressDelegate;

@end

@protocol RemoteImgOperatorDelegate <NSObject>

- (void)remoteImgOper:(RemoteImgOperator *)oper getImgSucc:(NSData *)dataImg fromURL:(NSString *)strURL;
- (void)remoteImgOper:(RemoteImgOperator *)oper getImgFailedFromURL:(NSString *)strURL;

@end