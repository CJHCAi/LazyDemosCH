//
//  HttpClient.h
//  Smallhorse_Driver
//
//  Created by MacBook on 16/2/17.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface HttpClient : AFHTTPRequestOperationManager

+ (HttpClient *)sharedClient;


@end
