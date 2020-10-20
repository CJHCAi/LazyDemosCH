//
//  DzwBaseNetWork.h
//  Example
//
//  Created by dzw on 2018/7/18.
//  Copyright © 2018年 dzw. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


typedef void(^failString)(NSString* message);

typedef void(^uploadProgress)(float progress);

typedef void(^downloadProgress)(float progress);



typedef NS_ENUM(NSInteger, BaseNetWorkStyle){
    BaseNetWorkStyleGet    = 0,
    BaseNetWorkStylePost   = 1,
};


@interface DzwBaseNetWork : NSObject


/*
 get 请求方法  post 请求方法
 
 *  @param URLString  请求的路径
 *  @param parameters 请求的参数
 *  @param success    成功的block
 *  @param failure    失败的block
 
 */
+(void)baseRequest:(NSString *)URLString httpMethod:(BaseNetWorkStyle)method parameters:(id)parameters success:(void(^)(id responseObject))success failString: (void(^)(NSError* error))failString;


/*
 
 上传单张图片
 
 */

+(void)uploadPicture:(NSString*)URLString
          parameters:(id)parameters
             success:(void(^)(id responseObject))success
          failString: (void(^)(NSError* error))failString;

/*
 
 上传多张图片
 
 *  @param parameters   上传图片等预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @parm width      图片要被压缩到的宽度
 *  @param urlString    上传的url---请填写完整的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 
 */

+(void)uploadPictures:(NSString*)URLString
          targetWidth:(CGFloat )width
       imageDataArray:(NSArray *)imageDataArray
           parameters:(id)parameters
              success:(void(^)(id responseObject))success
           failString: (void(^)(NSError* error))failString;


/*
 上传文件
 
 */

+(void)uploadFile:(NSString *)URLString
       parameters:(id)parameters
         fileData:(NSData *)fileData
          success:(void(^)(id responseObject))success
       failString: (void(^)(NSError* error))failString;


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
          progress:(uploadProgress)progress;




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
           progress:(downloadProgress)progress;


/*
 
 取消指定的url请求
 
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的完整url
 
 */

+(void)cancelAllRequest;


/*
 
 取消指定的url请求
 
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的完整url
 
 */

+(void)cancalHttpRequestWithHttpMethod:(NSInteger)httpMethod requestUrl:(NSString*)requestUrl;



@end
