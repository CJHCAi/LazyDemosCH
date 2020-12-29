//
//  HKAliyunOSSUploadVideoTool.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAliyunOSSUploadVideoTool.h"
#import "HK_BaseRequest.h"
#import "HKUploadRespone.h"
#import "HKBaseViewModel.h"
@interface HKAliyunOSSUploadVideoTool()<VODUploadSVideoClientDelegate>

@end

@implementation HKAliyunOSSUploadVideoTool
SISingletonM(HKAliyunOSSUploadVideoTool)
-(VODUploadSVideoClient *)client{
    if (!_client) {
        _client = [[VODUploadSVideoClient alloc] init];
        _client.delegate = self;
        _client.transcode = true;//是否转码，建议开启转码
    }
    return _client;
}

/**
 上传失败
 @param code 错误码
 @param message 错误日志
 */
- (void)uploadFailedWithCode:(NSString *)code message:(NSString *)message{
    [SVProgressHUD showErrorWithStatus:message];
}
/**
 上传进度
 @param uploadedSize 已上传的文件大小
 @param totalSize 文件总大小
 */
- (void)uploadProgressWithUploadedSize:(long long)uploadedSize totalSize:(long long)totalSize{
    CGFloat p = uploadedSize/totalSize;
    self.progress(p);
}
/**
 token过期
 */
- (void)uploadTokenExpired{
    
}
/**
 开始重试
 */
- (void)uploadRetry{
    
}
/**
 重试完成，继续上传
 */
- (void)uploadRetryResume{
    
}

- (void)uploadSuccessWithResult:(VodSVideoUploadResult *)result {
    self.success(result);
}
- (void)hk_uploadWithVideoPath:(NSString *)videoPath  imagePath:(NSString *)imagePath title:(NSString*)title requestSuccess:(void (^)(BOOL isUpload,NSString*msg))request updataSuccess:(UpdataSuccess)updataSuccess uploadProgressWithUploadedSize:(UpdataProgress)progress{
    self.success = updataSuccess;
    self.progress = progress;
    [HKBaseViewModel initUploadSuccess:^(BOOL isSave, HKUploadRespone *respone) {
        if (isSave) {
            VodSVideoInfo *info = [VodSVideoInfo new];
            info.title = title;
            BOOL isUpload =    [self.client uploadWithVideoPath:videoPath imagePath:imagePath svideoInfo:info accessKeyId:respone.data.accessKeyId accessKeySecret:respone.data.accessKeySecret accessToken:respone.data.securityToken];
            request(isUpload,@"");
        }else{
            request(NO,@"请求配置失败");
        }
    }];
    
}

- (void)hk_pause{
    [self.client pause];
}

- (void)hk_resume{
    [self.client resume];
}

- (void)hk_refreshWithAccessKeyId:(NSString *)accessKeyId
               accessKeySecret:(NSString *)accessKeySecret
                   accessToken:(NSString *)accessToken
                       expireTime:(NSString *)expireTime{
    [self.client refreshWithAccessKeyId:accessKeyId accessKeySecret:accessKeySecret accessToken:accessToken expireTime:expireTime];
}

- (void)hk_cancel{
    [self.client cancel];
}
@end
