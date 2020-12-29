//
//  HK_BaseRequest.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseRequest.h"
#import "UserPreferences.h"
#import "AFNetworking.h"
#import <AdSupport/AdSupport.h>
@implementation HK_BaseRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
#if Urldebug
        self.cerpath = nil;
        self.responseType =HJResponsetSerializerJSON;
#else
        int certtype = [UserPreferences getIntWithKey:@"sslcert" withDefault:1];
        NSString * path = nil;
        if (certtype == 1) {
            path = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
        }
        else if (certtype == 2)
        {
            path = [[NSBundle mainBundle] pathForResource:@"server2" ofType:@"cer"];
        }
        self.cerpath = path;
        self.responseType =HJResponsetSerializerJSON;
#endif
        
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary*)parameters
{
    self = [super init];
    if (self) {
#if Urldebug
        self.cerpath = nil;
        self.responseType =HJResponsetSerializerJSON;
#else
        
        
        int certtype = [UserPreferences getIntWithKey:@"sslcert" withDefault:1];
        NSString * path = nil;
        if (certtype == 1) {
            path = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
        }
        else if (certtype == 2)
        {
            path = [[NSBundle mainBundle] pathForResource:@"server2" ofType:@"cer"];
        }
        self.cerpath = path;
        self.responseType =HJResponseSerializerHTTP;
#endif
        self.responseType =HJResponsetSerializerJSON;
        _dicParameters = parameters;
    }
    return self;
}

-(void)prepareRequest{
//    NSString *url = Host;
//    [self buildGetRequest:url form:[HK_Header request_Header]];
}

-(void)processString:(NSString *)str{
    DLog(@"processString:%@", str);
    
}

-(void)processDictionary:(id)dictionary{
//    DLog(@"processDictionary:%@", dictionary);
}

-(void)processFile:(NSString *)filePath{
    
    DLog(@"processFile:%@", filePath);
}

-(void)businessBlock:(BuinessCompletionBlock)businessBlock;
{
    self.buinessCompletionBlock = businessBlock;
}
+(void)buildPostImageRequest:(NSString *)urlString body:(NSDictionary *)body  progress:(HJHttpProgress)progres callback:(HJHttpRequest)callback
{
    //取出image
    UIImage *image = body[@"image"];
    NSString *imageURL = body[@"imageURL"];
    
    NSString *imageNameAndSuff = [imageURL componentsSeparatedByString:@"/"].lastObject;
    NSString *imageName = [imageNameAndSuff componentsSeparatedByString:@"."].firstObject;
    NSString *mimeType = [imageNameAndSuff componentsSeparatedByString:@"."].lastObject;
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValuesForKeysWithDictionary:body];
    [parameter removeObjectForKey:@"image"];
    [parameter removeObjectForKey:@"imageURL"];
    
    [HJNetwork uploadImageURL:urlString
                   parameters:parameter
                       images:@[image]
                         name:@"imgSrc"
                     fileName:imageName
                     mimeType:mimeType
                     progress:^(NSProgress *progress) {
                         progres(progress);
                     } callback:^(id responseObject, NSError *error) {
                         callback(responseObject,error);
                     }];
}
+(void)buildPostRequest:(NSString *)urlString body:(NSDictionary *)body success:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError *_Nullable error))failure{
    [HJNetwork setRequestTimeoutInterval:10];
    [HJNetwork POSTWithURL:[Host stringByAppendingString:urlString] parameters:body cachePolicy:HJCachePolicyIgnoreCache callback:^(id responseObject, NSError *error){
        if (!error) {
//            [self processDictionary:responseObject];
            success(responseObject);
        }else{
            failure(error);
        }
    }];
}
-(void)buildPostRequest:(NSString *)urlString body:(NSDictionary *)body
{
//    if (![HJNetwork isNetwork]) {
    
    [HJNetwork POSTWithURL:urlString parameters:body cachePolicy:HJCachePolicyIgnoreCache callback:^(id responseObject, NSError *error){
            if (!error) {
                [self processDictionary:responseObject];
                if (self.successBlock) {
                    self.successBlock(error,200,responseObject);
                }
            }
        }];

    
    //    // 证书
    //    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    //    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    //    NSSet * cerSet = [NSSet setWithObjects:cerData, nil];
    //
    //    //    // https签名验*****br />//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    securityPolicy.validatesDomainName = NO;
    //    securityPolicy.allowInvalidCertificates = YES;
    //
    //    [securityPolicy setPinnedCertificates:cerSet];
    //
    //
    //    [self setSecurityPolicy:securityPolicy];
    
//    NSString *fullPath = urlString;
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    //设置请求头
//    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
//    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    manager.requestSerializer = requestSerializer;
//    
//    manager.securityPolicy.allowInvalidCertificates=YES;
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
//    
//#if DEBUG
//    DLog(@"\n【请求】接口：%@ \n 参数：%@\n",fullPath, body);
//#endif
//    
//    
//    //post
//    [manager POST:fullPath parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //返回的正文数据
//        NSDictionary *jsonObject = (NSDictionary*)responseObject;
//#if DEBUG
//        DLog(@"\n【响应】接口：%@ \n 返回数据：%@\n",fullPath, jsonObject);
//#endif
//        NSNumber *code = [jsonObject objectForKey:@"responseCode"];
//        if ([code isEqualToNumber:@200]) {
//            //请求成功
////            if (success) {
////                success(jsonObject);
////            }
//        }
//        else{
//            //失败
////            if (failed) {
////                NSError *err = [NSError errorWithDomain:fullPath code:[code integerValue] userInfo:jsonObject];
////                failed(err);
////            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //网络问题,存入数据库，稍后重新请求
//        DLog(@"\n接口：%@ \n 网络请求错误：%@\n",fullPath, error);
////        if (failed) {
////            failed(error);
////        }
//    }];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    }
//    else
//    {
//        if (self.successBlock) {
//            self.successBlock(nil,HJNetworkStatusNotReachable,nil);
//        }
//    }
}

+(void)getParameterWithDict:(NSDictionary*)dic{
    NSMutableDictionary* wx = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [wx setValue:dic forKey:@"user"];
    
    if (dic) {
        if (![dic objectForKey:HKZHKey]) {
            [dic setValue:HKZHVal forKey:HKZHKey];
        }
        if (![dic objectForKey:@"version"]) {
            [dic setValue:kVer forKey:@"version"];
        }
        if (![dic objectForKey:@"version2"]) {
            [dic setValue:kVev2 forKey:@"version2"];
        }
        if (![dic objectForKey:@"channel"]) {
            [dic setValue:@"AppStore" forKey:@"channel"];
        }
        
        if (![dic objectForKey:@"platform"]) {
            [dic setValue:[NSString stringWithFormat:@"%@_%@",[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion]] forKey:@"platform"];
        }
        
        if (![dic objectForKey:@"native"]) {
            [dic setValue:@"1" forKey:@"native"];
        }
        if (![dic objectForKey:@"mobile_id"]) {
            [dic setValue:advertisingId forKey:@"mobile_id"];
        }
    }else{
        NSMutableDictionary* severdic = [[NSMutableDictionary alloc] initWithCapacity:1];
        [severdic setValue:HKZHVal forKey:HKZHKey];
        [severdic setValue:kVev2 forKey:@"version2"];
        [severdic setValue:kVer forKey:@"version"];
        [severdic setValue:@"AppStore" forKey:@"channel"];
        [severdic setValue:@"1" forKey:@"native"];
        [severdic setValue:[NSString stringWithFormat:@"%@_%@",[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion]] forKey:@"platform"];
        [severdic setValue:advertisingId forKey:@"mobile_id"];
        dic = severdic;
    }

}
@end
