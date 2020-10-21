//
//  FrameMaskingLayer.h
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/26.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface FrameMaskingLayer : CALayer
- (void)addRemovePath:(UIBezierPath *)removePath;
@end
