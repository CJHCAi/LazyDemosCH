//
//  QuickTimeMov.h
//  LearnTestDemo
//
//  Created by BY_R on 2017/3/2.
//  Copyright © 2017年 BY_R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface QuickTimeMov : NSObject

- (id)initWithPath:(NSString *)path;
- (NSString *)readAssetIdentifier;
- (NSNumber *)readStillImageTime;
- (void)write:(NSString *)dest assetIdentifier:(NSString *)assetIdentifier;

@end
