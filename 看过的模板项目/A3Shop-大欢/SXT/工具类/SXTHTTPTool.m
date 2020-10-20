//
//  SXTHTTPTool.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/19.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTHTTPTool.h"

@implementation SXTHTTPTool

+ (instancetype)share{
    
    static SXTHTTPTool *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SXTHTTPTool alloc]initWithBaseURL:[NSURL URLWithString:@"http://123.57.141.249:8080/beautalk/"]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    });
    
    return manager;
}

+ (void)getData:(NSString *)url
          param:(NSDictionary *)param
        success:(requestSuccessBlock)returnSuccess
          error:(requestErrorBlock)returnError{
    [[SXTHTTPTool share] GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (returnSuccess) {
            returnSuccess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (returnError) {
            returnError(error);
        }
    }];
}

+ (void)postData:(NSString *)url
           param:(NSDictionary *)param
         success:(requestSuccessBlock)returnSuccess
           error:(requestErrorBlock)returnError{
    [[SXTHTTPTool share] POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (returnSuccess) {
            returnSuccess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (returnError) {
            returnError(error);
        }
    }];
}

@end
