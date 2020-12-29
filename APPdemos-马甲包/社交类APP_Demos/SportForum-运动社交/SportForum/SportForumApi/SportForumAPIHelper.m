//
//  SportForumAPIHelper.m
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import "SportForumAPIHelper.h"
#import "SportForum.h"

typedef void(^SportForumAPIHelperHandle)(BOOL bFinished);
__strong static SportForumAPIHelper *singleton = nil;
__strong static NSMutableDictionary* sDictFinishBlock = nil;
__strong static NSMutableDictionary* sDictPoolOperation = nil;

@implementation SportForumAPIHelper

-(id)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCheckTasksFinish:) name:IS_REQUEST_TASKS_FINISHED object:nil];
    }
    
    return self;
}

+(SportForumAPIHelper *)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[self alloc] init];
        sDictFinishBlock = [[NSMutableDictionary alloc]init];
        sDictPoolOperation = [[NSMutableDictionary alloc]init];
    });
    
    return singleton;
}

+ (NSString*) stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

-(void)SportForumRequestPool:(NSArray*) arraryOperation FinishedBlock:(void(^)(BOOL bFinished))finishedBlock
{
    NSString *strIdentify = [SportForumAPIHelper stringWithUUID];
    
    [sDictFinishBlock setObject:finishedBlock forKey:strIdentify];
    [sDictPoolOperation setObject:arraryOperation forKey:strIdentify];
    
    for (NSUInteger i = 0; i < [arraryOperation count]; i++) {
        BaseOperation *baseOperation = arraryOperation[i];
        baseOperation.taskPoolID = strIdentify;
        [baseOperation.requestOperation start];
    }
}

-(void)handleCheckTasksFinish:(NSNotification*) notification{
    NSDictionary* dictUserInfo = [notification userInfo];
    
    BOOL bFinished = YES;
    NSString *strOperationId = [dictUserInfo objectForKey:@"OperationId"];
    NSString *strTaskPoolId = [dictUserInfo objectForKey:@"TaskPoolId"];
    
    SportForumAPIHelperHandle operationFinishedCallback = [sDictFinishBlock objectForKey:strTaskPoolId];
    NSArray *arrayOperation = [sDictPoolOperation objectForKey:strTaskPoolId];
    
    if (operationFinishedCallback == nil || arrayOperation == nil) {
        return;
    }
    
    for (NSUInteger i = 0; i < [arrayOperation count]; i++) {
        BaseOperation *baseOperation = arrayOperation[i];
        
        if (![baseOperation.operationID isEqualToString:strOperationId] && ![baseOperation.requestOperation isFinished]) {
            bFinished = NO;
            break;
        }
    }
    
    if (bFinished) {
        operationFinishedCallback(bFinished);
        [sDictFinishBlock removeObjectForKey:strTaskPoolId];
        [sDictPoolOperation removeObjectForKey:strTaskPoolId];
    }
}

@end
