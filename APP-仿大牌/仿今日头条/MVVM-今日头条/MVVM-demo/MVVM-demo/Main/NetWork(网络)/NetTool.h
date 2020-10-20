//
//  NetTool.h
//  MVVM-demo
//
//  Created by shen_gh on 16/4/12.
//  Copyright © 2016年 申冠华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

@interface NetTool : NSObject

+ (NetTool *)shareManager;


/**
 *  get请求
 *
 *  @param url     url
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)httpGetRequest:(NSString *)url withParameter:(NSDictionary *)parameter success:(void (^)(Response *response))success failure:(void (^)(NSError *error))failure;

@end
