//
//  BaseOperation.h
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseOperation : NSObject

@property(strong, nonatomic) NSOperation *requestOperation;
@property(strong, nonatomic) NSString *operationID;
@property(strong, nonatomic) NSString *taskPoolID;

@end
