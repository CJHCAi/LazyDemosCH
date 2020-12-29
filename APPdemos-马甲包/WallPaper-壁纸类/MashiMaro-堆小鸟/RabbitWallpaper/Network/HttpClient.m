//
//  HttpClient.m
//  Smallhorse_Driver
//
//  Created by MacBook on 16/2/17.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import "HttpClient.h"
#import "CommonStatic.h"


@implementation HttpClient
+ (HttpClient *)sharedClient
{
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:kInterfaceBaseUrl]];
    });
    
    return _sharedClient;
}
@end
