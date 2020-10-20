//
//  MPVolumeObserverPro.h
//  CameraDemo
//
//  Created by apple on 2017/4/7.
//  Copyright © 2017年 yangchao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


@class MPVolumeObserverPro;
@protocol MPVolumeObserverProtocol <NSObject>
-(void) volumeButtonCameraClick:(MPVolumeObserverPro *) button;
-(void) volumeButtonStarVideoClick:(MPVolumeObserverPro *) button;
-(void) volumeButtonEndVideoClick:(MPVolumeObserverPro *) button;

@end


@interface MPVolumeObserverPro : NSObject

@property (nonatomic, assign) id<MPVolumeObserverProtocol> delegate;

+(MPVolumeObserverPro*) sharedInstance;
-(void)startObserveVolumeChangeEvents;
-(void)stopObserveVolumeChangeEvents;

@end
