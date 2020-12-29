//
//  HKVideoPlayView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayerVideo.h>
@protocol HKVideoPlayViewDelegate <NSObject>
@optional
-(void)back;
-(void)tagButtonClickBlock;
-(void)finishButtonClickBlock;
@end
typedef void(^TagButtonClickBlock)(void);
typedef void(^FinishButtonClickBlock)(void);
@interface HKVideoPlayView : UIView

@property (nonatomic,strong) NSURL *url;

@property (nonatomic,weak) id<HKVideoPlayViewDelegate> delegate;

@property (nonatomic, strong) UIImage *coverImage;


- (void)prepareWithURL:(NSURL *)url;

- (void)resume; //继续播放

- (AliyunVodPlayerState)playerState;

- (void)pause;

- (void)releasePlayerAndTimer;

@end
