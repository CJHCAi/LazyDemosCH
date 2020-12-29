//
//  HKVideoPlayViewController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    本地播放器，视频录制完成后
 */
@interface HKVideoPlayViewController : UIViewController

- (instancetype)initWithUrl:(NSURL *)url;

@property (nonatomic,strong) NSURL *url;

@end
