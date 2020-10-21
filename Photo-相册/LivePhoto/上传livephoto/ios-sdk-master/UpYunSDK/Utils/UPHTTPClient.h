//
//  UPHTTPClient.h
//  UPYUNSDK
//
//  Created by DING FENG on 11/30/15.
//  Copyright © 2015 DING FENG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UPHTTPClient;

typedef void(^HttpSuccessBlock)(NSURLResponse *response, id responseData);
typedef void(^HttpFailBlock)(NSError *error);
typedef void(^HttpProgressBlock)(int64_t completedBytesCount, int64_t totalBytesCount);

@interface UPHTTPClient : NSObject

- (void)uploadRequest:(NSMutableURLRequest *)request
              success:(HttpSuccessBlock)successBlock
              failure:(HttpFailBlock)failureBlock
             progress:(HttpProgressBlock)progressBlock;

- (void)cancel;

- (void)timeoutIntervalForRequest:(NSTimeInterval)timeoutForRequest;
- (void)timeoutIntervalForResource:(NSTimeInterval)timeoutForResource;

@end
