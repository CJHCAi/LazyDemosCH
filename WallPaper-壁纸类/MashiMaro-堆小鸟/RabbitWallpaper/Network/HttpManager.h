//
//  HttpManager.h
//  Smallhorse_Driver
//
//  Created by MacBook on 16/2/22.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "AFHTTPRequestOperationManager.h"

typedef void (^HttpConnectionSuccessBlock)(AFHTTPRequestOperation *opration,id responseObject);
typedef void (^HttpConnectionFailureBlock)(AFHTTPRequestOperation *opration, NSError *error);

//block callback for download image
typedef void (^DownloadImageSuccessBlock)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image);
typedef void (^DonwloadImageFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error);

//block for post data call
typedef void (^MultipartFormDataBlock)(id <AFMultipartFormData> formData);
typedef void (^UploadProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

@interface HttpManager : NSObject

+ (HttpManager *)sharedManager;


//-----------------------------------------------
//滚动视图
-(void)RundWithIdfa:(NSString *)idfa
               Idfv:(NSString *)idfv
            NewIdfa:(NSString *)newIdfa
           Openudid:(NSString *)openudid
       SuccessBlock:(HttpConnectionSuccessBlock)successBlock
       failureBlock:(HttpConnectionFailureBlock)failureBlock;
//最新
-(void)WallPaperWithIdfa:(NSString *)idfa
                    Idfv:(NSString *)idfv
                 NewIdfa:(NSString *)newIdfa
                Openudid:(NSString *)openudid
                    Page:(int )page
                    Type:(NSString *)type
            SuccessBlock:(HttpConnectionSuccessBlock)successBlock
            failureBlock:(HttpConnectionFailureBlock)failureBlock;


//分类
-(void)GetListOfHomeWithIdfa:(NSString *)idfa
                        Idfv:(NSString *)idfv
                     NewIdfa:(NSString *)newIdfa
                    Openudid:(NSString *)openudid
                SuccessBlock:(HttpConnectionSuccessBlock)successBlock
                failureBlock:(HttpConnectionFailureBlock)failureBlock;

//推荐列表
-(void)recommendWithIdfa:(NSString *)idfa
                    Idfv:(NSString *)idfv
                 NewIdfa:(NSString *)newIdfa
                Openudid:(NSString *)openudid
            SuccessBlock:(HttpConnectionSuccessBlock)successBlock
            failureBlock:(HttpConnectionFailureBlock)failureBlock;
//分类详情
-(void)wallpaperWithIdfa:(NSString *)idfa
                    Idfv:(NSString *)idfv
                 NewIdfa:(NSString *)newIdfa
                Openudid:(NSString *)openudid
                    Page:(int )page
                   Catid:(NSString *)catid
            SuccessBlock:(HttpConnectionSuccessBlock)successBlock
            failureBlock:(HttpConnectionFailureBlock)failureBlock;
//推荐详情
-(void)themeWithIdfa:(NSString *)idfa
                Idfv:(NSString *)idfv
             NewIdfa:(NSString *)newIdfa
            Openudid:(NSString *)openudid
               TypeId:(NSString *)TypeId
        SuccessBlock:(HttpConnectionSuccessBlock)successBlock
        failureBlock:(HttpConnectionFailureBlock)failureBlock;












@end
