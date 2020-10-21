//
//  VideoEditingController.h
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/18.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

extern const char kOrientation;

@class AVPlayerItem;
@interface VideoEditingController : UIViewController

- (instancetype)initWithAssetUrl:(NSURL *)assetUrl;
- (instancetype)initWithPlayItem:(AVPlayerItem *)playItem;
@end
