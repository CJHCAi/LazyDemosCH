//
//  DzwBaseNetWork.m
//  Example
//
//  Created by dzw on 2018/7/18.
//  Copyright © 2018年 dzw. All rights reserved.
//

#import "DzwBaseNetWork.h"
#import "AFNetworking.h"  //af3.0封装
#import "DzwSessionManager.h"


@implementation DzwBaseNetWork

/*
 get 请求方法  post 请求方法
 
 *  @param URLString  请求的路径
 *  @param parameters 请求的参数
 *  @param success    成功的block
 *  @param failure    失败的block
 
 */
+(void)baseRequest:(NSString *)URLString httpMethod:(BaseNetWorkStyle)method parameters:(id)parameters success:(void(^)(id responseObject))success failString: (void(^)(NSError* error))failString{
    
    DzwSessionManager *manager = [DzwSessionManager shareManager];
    switch (method) {
            
        case BaseNetWorkStyleGet:{
            [manager GET:URLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failString) {
                    failString(error);
                }
            }];
           
        }
            
            break;
            
            
        case BaseNetWorkStylePost : {
            
            [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failString) {
                    failString(error);
                }
            }];
            
        }
            
            break;
    }
    
    
}


/*
 
 上传单张图片
 
 */

+(void)uploadPicture:(NSString*)URLString
          parameters:(id)parameters
             success:(void(^)(id responseObject))success
          failString: (void(^)(NSError* error))failString;{
    DzwSessionManager *manager = [DzwSessionManager shareManager];
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /*
         在网络开发中，上传文件时，是文件不允许被覆盖，要解决文件重名问题，可以在上传时使用当前的系统时间作为文件名
         */
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString* str = [formatter stringFromDate:[NSDate date]];
        NSString* filename = [NSString stringWithFormat:@"%@.png",str];
        
        //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
        
        //  压缩
        UIImage *iamge = [UIImage imageNamed:filename];
        NSData *data = UIImagePNGRepresentation(iamge);
        
        [formData appendPartWithFileData:data name:@"file" fileName:filename mimeType:@"image/png"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {//成功
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failString) {
            failString(error);
        }
    }];
}

/*
 
 上传多张图片
 
 */

+(void)uploadPictures:(NSString*)URLString
          targetWidth:(CGFloat )width
       imageDataArray:(NSArray *)imageDataArray
           parameters:(id)parameters
              success:(void(^)(id responseObject))success
           failString: (void(^)(NSError* error))failString{
    
    DzwSessionManager *manager = [DzwSessionManager shareManager];
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i<imageDataArray.count; i++){
            
            NSData * image = imageDataArray[i];
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSString *name = [NSString stringWithFormat:@"image_%d.png",i ];
            
            //            /**为了性能考虑，压缩一下图片*/
            //            //image的分类方法
            //            UIImage *  resizedImage =  [UIImage IMGCompressed:image targetWidth:width];
            //
            //            NSData * imgData = UIImageJPEGRepresentation(resizedImage, .5);
            
            //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
            [formData appendPartWithFileData:image name:name fileName:fileName mimeType:@"image/png"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {//成功 到下一层中解析
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failString) {
            failString(error);
        }
        
    }];
    
    
    
}

/*
 上传文件
 
 */

+(void)uploadFile:(NSString *)URLString
       parameters:(id)parameters
         fileData:(NSData *)fileData
          success:(void(^)(id responseObject))success
       failString: (void(^)(NSError* error))failString{
    
    DzwSessionManager *manager = [DzwSessionManager shareManager];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //将得到的二进制数据拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
        [formData appendPartWithFileData :fileData name:@"file" fileName:@"audio.MP3" mimeType:@"audio/MP3"];
        
        //进度
        //  progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {//成功
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failString) {
            failString(error);
        }
    }];
    
}


/*
 
 视频上传
 
 *  @param parameters   上传视频预留参数---视具体情况而定 可移除
 *  @param videoPath    上传视频的本地沙河路径
 *  @param URLString     上传的url
 *  @param successBlock 成功的回调
 *  @param failureBlock 失败的回调
 *  @param progress     上传的进度
 
 */

+(void)uploadVideo:(NSString* )URLString
        parameters:(id)parameters
         videoPath:(NSString* )videoPath
           success:(void(^)(id responseObject))success
        failString: (void(^)(NSError* error))failString
          progress:(uploadProgress)progress{
    
    DzwSessionManager *manager = [DzwSessionManager shareManager];
    //获取视频资源
    AVURLAsset* urlAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:videoPath]];
    
    /**压缩*/
    
    //    NSString *const AVAssetExportPreset640x480;
    //    NSString *const AVAssetExportPreset960x540;
    //    NSString *const AVAssetExportPreset1280x720;
    //    NSString *const AVAssetExportPreset1920x1080;
    //    NSString *const AVAssetExportPreset3840x2160;
    
    AVAssetExportSession* exportSession = [[AVAssetExportSession alloc]initWithAsset:urlAsset presetName:AVAssetExportPreset640x480];
    
    /**创建日期格式化器*/
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    /**转化后直接写入Library---caches*/
    
    NSString *  videoWritePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/output-%@.mp4",[formatter stringFromDate:[NSDate date]]]];
    
    exportSession.outputURL = [NSURL URLWithString:videoWritePath];
    
    
    exportSession.outputFileType =  AVFileTypeMPEG4;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch ([exportSession status]) {
            case AVAssetExportSessionStatusCompleted:{
                
                [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    //获得沙盒中的视频内容
                    
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:videoWritePath] name:@"write you want to writre" fileName:videoWritePath mimeType:@"video/mpeg4" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    if (progress) {
                        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                    }
                    
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (success) {//成功
                        success(responseObject);
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (failString) {
                        failString(error);
                    }
                    
                    
                }];
                
                
            }
                break;
                
            default:
                break;
        }
    }];
    
}


/*
 
 文件下载
 
 *  @param parameters   文件下载预留参数---视具体情况而定 可移除
 *  @param savePath     下载文件保存路径
 *  @param URLString        请求的url
 *  @param successBlock 下载文件成功的回调
 *  @param failureBlock 下载文件失败的回调
 *  @param progress     下载文件的进度显示
 
 */

+(void)downloadFile:(NSString* )URLString
         parameters:(id)parameters
           savePath:(NSString* )savePath
            success:(void(^)(id responseObject))success
         failString: (void(^)(NSError* error))failString
           progress:(downloadProgress)progress{
    
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    
    [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress) {
            progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [NSURL URLWithString:savePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (failString) {
            failString(error);
            
        }
        
    }];
    
}

#pragma mark -  取消所有的网络请求

/**
 *  取消所有的网络请求
 *  a finished (or canceled) operation is still given a chance to execute its completion block before it iremoved from the queue.
 */

+(void)cancelAllRequest
{
    DzwSessionManager *manager = [DzwSessionManager shareManager];
    [manager.operationQueue cancelAllOperations];
    
}

/*
 
 取消指定的url请求
 
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的完整url
 
 */

+(void)cancalHttpRequestWithHttpMethod:(NSInteger)httpMethod requestUrl:(NSString*)requestUrl{
    NSError* error;
    
    NSString* requestType = httpMethod == BaseNetWorkStyleGet ? @"get" : @"post";
    DzwSessionManager *manager = [DzwSessionManager shareManager];
    
    NSString* urlToPeCanced  = [[[manager.requestSerializer requestWithMethod:requestType URLString:requestUrl parameters:nil error:&error] URL] path];
    
    for (NSOperation * operation in manager.operationQueue.operations) {
        
        //如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            
            //请求的类型匹配
            BOOL hasMatchRequestType = [requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            //请求的url匹配
            
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            //两项都匹配的话  取消该请求
            if (hasMatchRequestType && hasMatchRequestUrlString) {
                
                [operation cancel];
                
            }
        }
        
    }
}


@end
