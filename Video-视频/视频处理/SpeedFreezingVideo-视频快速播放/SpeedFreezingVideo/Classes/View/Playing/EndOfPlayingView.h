//
//  EndOfPlayingView.h
//  SpeedFreezingVideo
//
//  Created by lzy on 16/8/14.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VideoOrientation) {
    VideoOrientationPortrait = 0,
    VideoOrientationLandscape = 1
};

@protocol EndOfPlayingViewDelegate <NSObject>
- (void)didClickBackToEditButton;
- (void)didClickReplayButton;
- (void)didClickSaveButton;
@end

@interface EndOfPlayingView : UIView
@property (assign, nonatomic) id<EndOfPlayingViewDelegate> delegate;
- (instancetype)initWithVideoOrientation:(VideoOrientation)orientation
                                delegate:(id<EndOfPlayingViewDelegate>)delegate;
@end
