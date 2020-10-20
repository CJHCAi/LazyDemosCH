//
//  DzwSessionManager.m
//  Example
//
//  Created by dzw on 2018/7/18.
//  Copyright © 2018年 dzw. All rights reserved.
//

#import "DzwSessionManager.h"


static NSInteger const kDefaultRequestTime = 30;

@implementation DzwSessionManager

+(instancetype)shareManager{
    static DzwSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DzwSessionManager alloc] init];
    });
    
    return manager;
    
}

-(instancetype)init{
    if (self = [super init]) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        self.requestSerializer.timeoutInterval = kDefaultRequestTime;
    }
    
    return self;

}

@end
