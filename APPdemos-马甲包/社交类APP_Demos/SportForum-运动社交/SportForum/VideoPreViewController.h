//
//  VideoPreViewController.h
//  SportForum
//
//  Created by liyuan on 5/21/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoPreViewController;

@protocol VideoPreViewDelegate <NSObject>

@optional

- (void)videoPreDelete:(VideoPreViewController *)videoPreViewController;

@end

@interface VideoPreViewController : UIViewController

@property (nonatomic, weak) IBOutlet id<VideoPreViewDelegate> delegate;
@property(nonatomic, copy) NSString *strVideoPath;
@property(nonatomic, copy) NSString *strVideoKey;
@property(nonatomic, assign) BOOL bIsNetwork;

@end
