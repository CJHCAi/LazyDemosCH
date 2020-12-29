//
//  KTHttpTool.m
//  IntegratedSystem
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//  Created by 杨付华 on 2017/2/28.
//  Copyright © 2017年 KEENTEAM. All rights reserved.
//

#import "KTHttpTool.h"

@implementation KTHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    //1、获得请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
   
    //添加可接受类型
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    //2、发送GET请求
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    //1、获得请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //2、添加 可接受类型
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    //3、发送请求
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if([[NSString stringWithFormat:@"%@",responseObject[@"code"]]isEqualToString:@"1000"])
        {
            [SVProgressHUD showErrorWithStatus:@"1000"];
            return ;
        }
        else if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]]isEqualToString:@"1001"]){
            [SVProgressHUD showErrorWithStatus:@"1001"];
            return;
            
        }
        else if (success){
            
            success(responseObject);
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)postkt:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
 
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//传入的参数
//发送请求
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[NSString stringWithFormat:@"%@",responseObject[@"code"]]isEqualToString:@"1000"])
        {
            [SVProgressHUD showErrorWithStatus:@"1000"];
            return ;
        }
        else if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]]isEqualToString:@"1001"]){
            [SVProgressHUD showErrorWithStatus:@"1001"];
            return;
            
        }
        else if (success){
            
            success(responseObject);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


@end
