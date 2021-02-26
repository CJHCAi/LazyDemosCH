//
//  AFNetWorkingTool.m
//  Test
//
//  Created by 火虎MacBook on 2020/7/9.
//  Copyright © 2020 蔡建华. All rights reserved.
//

#import "AFNetworkingTool.h"
#import "AFNetworking.h"
#import "CHDeviceInfoManager.h"

@interface AFNetworkingTool ()
@property (nonatomic, strong, readwrite) AFHTTPSessionManager *manager;

@end

@implementation AFNetworkingTool

+ (instancetype)sharedInstance{
    static AFNetworkingTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[self alloc] init];
    });
    return _tool;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _manager = [[AFHTTPSessionManager alloc] init];
        _manager.requestSerializer.timeoutInterval = 10;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", @"image/jpeg", @"image/png", @"image/gif",@"application/octet-stream",@"multipart/form-data",nil];

        _manager.securityPolicy = [AFSecurityPolicy defaultPolicy];

    }
    return self;
}

/**设置公用参数*/
- (NSMutableDictionary *)getCommonParameters{
    //设置区头参数
//    NSString * token = [RYUserInfoHelper shareInstance].getToken;
//    if (token.length > 0) {
//    [_manager.requestSerializer setValue:token forHTTPHeaderField:@"AUTH"];
//    }
    
    //公用参数
    NSMutableDictionary * commonParams = [NSMutableDictionary dictionary];
    NSString * appID = [CHDeviceInfoManager shareInstance].APPID;
    if (appID.length > 0) {
        commonParams[@"appid"] = appID;
    }else{
        NSLog(@"请传入APPID");
    }
    commonParams[@"os"] = @"2";//1 Android 2 IOS
    return commonParams;
}

/**统一处理返回code状态*/
-(NSInteger)judgeCodeHandleWithJsonDic:(NSDictionary *)jsonDic{
    NSInteger code = [jsonDic[@"code"] integerValue];
    if (code == 301) {
        //未登录 或 登录失效
    }
    return code;
}

#pragma mark - Request
/**POST Body传递参数*/
-(void)postRequestRBodyParmasWithUrl:(NSString *)url params:(NSDictionary *)params succeed:(CodeSuccessBlock)succeedBlock failure:(FailureBlock)failureBlock{
    NSLog(@"url:%@ params:%@",url,params);
    NSError *error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     //method 为时post请求还是get请求
     NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
     //设置超时时长
     request.timeoutInterval= 10;
     //设置上传数据type
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     //设置接受数据type
     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //设置请求头
//    if ([RYUserInfoHelper shareInstance].isLogin) {
//        NSString * token = [RYUserInfoHelper shareInstance].getToken;
//        [request setValue:token forHTTPHeaderField:@"AUTH"];
//    }
    
     //将对象设置到requestbody中 ,主要是这部操作
     [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
     //进行网络请求
    NSURLSessionDataTask *  dataTask = [_manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
         
     } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {

     } completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
            
         dispatch_async(dispatch_get_main_queue(), ^{
           if (!error) {
               NSInteger code = [self judgeCodeHandleWithJsonDic:responseObject];
                   if (succeedBlock) {
                       succeedBlock(code,responseObject);
                   }
           } else {
               if (failureBlock) {
                   failureBlock(error);
               }
           }
        });
         
     }];
    
    [dataTask resume];

}

/**POST 或GET*/
- (void)requestWithType:(RequestType)type  url:(NSString *)url parameters:(NSDictionary *)params success:(CodeSuccessBlock)success failure:(FailureBlock)failure{
    //设置公用参数 请求头
     NSMutableDictionary *totalParams = [NSMutableDictionary dictionary];
     [totalParams addEntriesFromDictionary:[self getCommonParameters]];
     [totalParams addEntriesFromDictionary:params];
     NSLog(@"URL:%@ params:%@",url,totalParams);
    
    if (type == POST) {
        [self.manager POST:url parameters:totalParams headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //统一处理Code
                NSInteger code = [self judgeCodeHandleWithJsonDic:responseObject];
                 if (success) {
                     success(code,responseObject);
                 }

            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
        
    }else{
        
        [self.manager GET:url parameters:totalParams headers:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //统一处理Code
                NSInteger code = [self judgeCodeHandleWithJsonDic:responseObject];
                  if (success) {
                      success(code,responseObject);
                  }

            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}

/**GET请求*/
- (void)GET:(NSString *)url parameters:(NSDictionary *)params success:(CodeSuccessBlock)success failure:(FailureBlock)failure{
    
        NSMutableDictionary *totalParams = [NSMutableDictionary dictionary];
        [totalParams addEntriesFromDictionary:[self getCommonParameters]];
        [totalParams addEntriesFromDictionary:params];
        NSLog(@"URL:%@ params:%@",url,totalParams);
    
    [self.manager GET:url parameters:totalParams headers:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            //统一处理Code
            NSInteger code = [self judgeCodeHandleWithJsonDic:responseObject];
             if (success) {
                 success(code,responseObject);
             }
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**POST*/
- (void)POST:(NSString *)url parameters:(NSDictionary *)params success:(CodeSuccessBlock)success failure:(FailureBlock)failure{
    
    NSMutableDictionary *totalParams = [NSMutableDictionary dictionary];
    [totalParams addEntriesFromDictionary:[self getCommonParameters]];
    [totalParams addEntriesFromDictionary:params];
    NSLog(@"URL:%@ params:%@",url,totalParams);
    
    [self.manager POST:url parameters:totalParams headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        //统一处理Code
        NSInteger code = [self judgeCodeHandleWithJsonDic:responseObject];
        if (success) {
               success(code,responseObject);
           }
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**上传单张图片*/
-(void)uploadImageWithUrl:(NSString *)url params:(NSDictionary *)params fileKey:(NSString *)fileKey image:(UIImage *)image progress:(ProgressBlock)progress  success:(CodeSuccessBlock)success failure:(FailureBlock)failure {
    // 设置公用参数 和 请求头
    NSMutableDictionary * totalParams = [NSMutableDictionary dictionary];
    NSMutableDictionary * commenDic = [self getCommonParameters];
    [totalParams addEntriesFromDictionary:commenDic];
    [totalParams addEntriesFromDictionary:params];

    [self.manager POST:url parameters:params headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImagePNGRepresentation(image);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", dateStr];
        
        [formData appendPartWithFileData:imageData name:fileKey fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           CGFloat value = uploadProgress.completedUnitCount/uploadProgress.totalUnitCount * 1.0;
          if (progress) {
                progress(value);
          }
       });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger code = [self judgeCodeHandleWithJsonDic:responseObject];
            if (success) {
                success(code,responseObject);
            }
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (failure) {
            failure(error);
        }
    }];
}

/**上传多张图片*/
-(void)uploadImagesWithUrl:(NSString *)url params:(NSMutableDictionary *)params fileKey:(NSString *)fileKey images:(NSMutableArray <UIImage *>*)imagesArray progress:(ProgressBlock)progress success:(CodeSuccessBlock)success failure:(FailureBlock)failure{
    
    // 设置公用参数 和 请求头
    NSMutableDictionary * totalParams = [NSMutableDictionary dictionary];
    [totalParams addEntriesFromDictionary:[self getCommonParameters]];
    [totalParams addEntriesFromDictionary:params];

    [_manager POST:url parameters:totalParams headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        for (int i = 0; i < imagesArray.count; i++) {
            UIImage *image = imagesArray[i];
            NSData *imageData = UIImagePNGRepresentation(image);
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png",dateString];

            [formData appendPartWithFileData:imageData name:fileKey fileName:fileName mimeType:@"image/png"];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
             CGFloat value = uploadProgress.completedUnitCount/uploadProgress.totalUnitCount * 1.0;
            if (progress) {
                progress(value);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [self judgeCodeHandleWithJsonDic:responseObject];
        if (success) {
            success(code,responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**下载文件*/
-(void)downloadWithurl:(NSString *)url progress:(ProgressBlock)progress success:(CodeSuccessBlock)success failure:(FailureBlock)failure{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
       dispatch_async(dispatch_get_main_queue(), ^{
           if (progress) {
                CGFloat value = downloadProgress.completedUnitCount/downloadProgress.totalUnitCount * 1.0;
                progress(value);
           }
       });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //获取沙盒cache路径
        NSURL * cacheUrl = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [cacheUrl URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failure) {
                    failure(error);
                }
            }else{
                if (success) {
                    success(200,filePath.path);
                }
            }

        });
       
    }];
    [downloadTask resume];
}


@end
