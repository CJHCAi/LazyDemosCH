//
//  MyURLCache.m
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/12.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import "MyURLCache.h"

@implementation MyURLCache

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request{

//    NSLog(@"%@",request.URL);
    
    return nil;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    
//    NSLog(@"%@", [[NSString alloc] initWithData:cachedResponse.data encoding:NSUTF8StringEncoding]);
}

@end
