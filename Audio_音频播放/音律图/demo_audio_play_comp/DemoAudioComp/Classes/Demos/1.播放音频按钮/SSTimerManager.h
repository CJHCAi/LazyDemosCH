//
//  SSTimerManager.h
//  DemoAudioComp
//
//  Created by SHEN on 2018/9/5.
//  Copyright © 2018年 shj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSTimerManager : NSObject

+ (instancetype)instance;
- (void)start;
- (void)stop;

@end
