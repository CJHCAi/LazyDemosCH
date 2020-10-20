//
//  SSNetManager.h
//  TestAFNetWorking
//
//  Created by shj on 2018/6/10.
//  Copyright © 2018年 shj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSNetManager : NSObject
+ (instancetype)instance;
 
- (void)downloadFile:(NSURL *)url progress:(void (^)(float progress))progressBlock complete:(void (^)(NSURL *filePathUrl))completeBlock;
@end
