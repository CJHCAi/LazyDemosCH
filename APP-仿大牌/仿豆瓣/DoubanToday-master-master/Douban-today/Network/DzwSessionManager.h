//
//  DzwSessionManager.h
//  Example
//
//  Created by dzw on 2018/7/18.
//  Copyright © 2018年 dzw. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>

@interface DzwSessionManager : AFHTTPSessionManager

+(instancetype)shareManager;

@end
