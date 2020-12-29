//
//  SportForumAPIHelper.h
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportForumAPIHelper : NSObject

+(SportForumAPIHelper *)sharedInstance;

-(void)SportForumRequestPool:(NSArray*) arraryOperation FinishedBlock:(void(^)(BOOL bFinished))finishedBlock;

@end
