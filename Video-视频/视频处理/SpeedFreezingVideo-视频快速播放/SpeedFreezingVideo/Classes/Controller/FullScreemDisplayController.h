//
//  FullScreemDisplayController.h
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/29.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface FullScreemDisplayController : UIViewController
- (instancetype)initWithPlayer:(AVPlayer *)player videoOrientation:(AVCaptureVideoOrientation)videoOrientation;
- (instancetype)initWithAssetUrl:(NSURL *)url videoOrientation:(AVCaptureVideoOrientation)videoOrientation;
@end