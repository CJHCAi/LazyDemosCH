//
//  RemoteImgListOperator.h
//  RemoteImgListOperatorDemo
//
//  Created by jimple on 14-1-7.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RemoteImgListOperator : NSObject

// 接收 成功/失败 通知的名称
// Notification 的 userInfo 中返回一个字典：key为图片URL，value为图片内容NSData。
@property (nonatomic, readonly) NSString *m_strSuccNotificationName;
@property (nonatomic, readonly) NSString *m_strFailedNotificationName;

// 设置列表最大长度
- (void)resetListSize:(NSInteger)iSize;

// 从网路下载图片
- (void)getRemoteImgByURL:(NSString *)strURL;

// 从网络下载图片，带进度条delegate
// 进度条delegate方法： - (void)setProgress:(float)newProgress;
- (void)getRemoteImgByURL:(NSString *)strURL withProgress:(id)progress;
// 移除正在使用的进度条delegate
- (void)removeProgressDelegate:(id)progress;



@end
