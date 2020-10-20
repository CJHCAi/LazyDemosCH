//
//  SXTHTTPTool.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/19.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^requestSuccessBlock)(id responseObject);
typedef void(^requestErrorBlock)(NSError *error);

@interface SXTHTTPTool : AFHTTPSessionManager


+ (void)getData:(NSString *)url
          param:(NSDictionary *)param
        success:(requestSuccessBlock)returnSuccess
          error:(requestErrorBlock)returnError;

+ (void)postData:(NSString *)url
           param:(NSDictionary *)param
         success:(requestSuccessBlock)returnSuccess
           error:(requestErrorBlock)returnError;

@end
