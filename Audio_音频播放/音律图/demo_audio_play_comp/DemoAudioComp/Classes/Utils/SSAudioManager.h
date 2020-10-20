//
//  SSAuidoManager.h
//  DemoAudioComp
//
//  Created by SHEN on 2018/9/6.
//  Copyright © 2018年 shj. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@interface SSAudioManager : NSObject
@property (assign, nonatomic) BOOL isPlaying;
@property (assign, nonatomic) CGFloat currentTime;
@property (assign, nonatomic) CGFloat duration;

+ (instancetype)instance;
- (void)play:(NSURL *)fileUrl;
- (void)stopPlay;

@end
