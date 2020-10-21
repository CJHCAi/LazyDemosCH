//
//  SpeedMultipleView.h
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/22.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpeedMultipleViewDelegate <NSObject>

- (void)SpeedMultipleViewDidSelectedSpeedRate:(double)rate;

@end

@interface SpeedMultipleView : UIView

@property (weak, nonatomic) id<SpeedMultipleViewDelegate> delegate;
+ (SpeedMultipleView *)createView;

@end
