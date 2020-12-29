//
//  KTHttpTool.h
//  IntegratedSystem
//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//  Created by 杨付华 on 2017/2/28.
//  Copyright © 2017年 KEENTEAM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTHttpTool : NSObject
//GET 请求
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

//POST 请求
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

+ (void)postkt:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;


@end

