//
//  NetTool.m
//  MVVM-demo
//
//  Created by shen_gh on 16/4/12.
//  Copyright © 2016年 申冠华. All rights reserved.
//

#import "NetTool.h"
#import "AFNetworking.h"

@implementation NetTool

//单例，每次只允许一次网络请求
+ (NetTool *)shareManager{
    static NetTool *manager=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        //一次只允许一个请求
        if (manager==nil) {
            manager=[[NetTool alloc]init];
        }
    });
    return manager;
}

- (void)httpGetRequest:(NSString *)url withParameter:(NSDictionary *)parameter success:(void (^)(Response *response))success failure:(void (^)(NSError *error))failure{
    
    NSLog(@"........get request url:%@",url);
    NSLog(@"........参数parameters:%@",parameter);
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates=YES;
    
    //每次开始下载任务前做如下判断
    NSMutableArray *requestArray=[NSMutableArray array];
    for (NSString *request in requestArray) {
        if ([url isEqualToString:request]) {
            return;
        }
    }
    [requestArray addObject:url];
    
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *responseString=[operation responseString];
        NSData *data=[responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        Response *responseObj=[[Response alloc]initWithDictionary:jsonDic];
        
        success(responseObj);
        [requestArray removeObject:url];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
            [requestArray removeObject:url];
        }
    }];
}

@end
