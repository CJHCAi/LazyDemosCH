//
//  HKAliyunOSSUploadVideoTool.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VODUpload/VODUploadSVideoClient.h>
#import <VODUpload/VODUploadClient.h>
typedef void(^UpdataSuccess)(VodSVideoUploadResult*result);
typedef void(^UpdataProgress)(CGFloat progress);
@interface HKAliyunOSSUploadVideoTool : NSObject
SISingletonH(HKAliyunOSSUploadVideoTool)
@property (nonatomic, copy)UpdataSuccess success;
@property (nonatomic, copy)UpdataProgress progress ;
@property (nonatomic, strong)VODUploadSVideoClient *client;
- (void)hk_pause;

- (void)hk_resume;

- (void)hk_refreshWithAccessKeyId:(NSString *)accessKeyId
               accessKeySecret:(NSString *)accessKeySecret
                   accessToken:(NSString *)accessToken
                    expireTime:(NSString *)expireTime;

- (void)hk_cancel;

- (void)hk_uploadWithVideoPath:(NSString *)videoPath  imagePath:(NSString *)imagePath title:(NSString*)title requestSuccess:(void (^)(BOOL isUpload,NSString*msg))request updataSuccess:(UpdataSuccess)updataSuccess uploadProgressWithUploadedSize:(UpdataProgress)progress;
@end
