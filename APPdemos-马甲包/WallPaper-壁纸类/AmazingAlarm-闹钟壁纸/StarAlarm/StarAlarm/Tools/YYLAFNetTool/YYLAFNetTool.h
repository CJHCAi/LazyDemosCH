//
//  YYLAFNetTool.h
//  CoolListen
//
//  Created by dllo on 16/3/7.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BlockOfSuccess)(id result);

typedef NS_ENUM(NSUInteger, YYLResopnseStyle) {
    YYLJSON,
    YYLXML,
    YYLDATA,
};

typedef NS_ENUM(NSUInteger, YYLBodyRequestStyle) {
    YYLRequestJSON,
    YYLRequestString,
};

@interface YYLAFNetTool : NSObject


+ (void)GETNetWithUrl:(NSString *)url
                 body:(id)body
           headerFile:(NSDictionary *)header
             response:(YYLResopnseStyle)responseStyle
              success:(BlockOfSuccess)success
              failure:(void (^)(NSError *error))failure;

+ (void)POSTNetWithUrl:(NSString *)url
                  body:(id)body
            bodyStytle:(YYLBodyRequestStyle)bodyRequestStyle
           headerFile:(NSDictionary *)header
             response:(YYLResopnseStyle)responseStyle
              success:(BlockOfSuccess)success
              failure:(void (^)(NSError *error))failure;

@end
