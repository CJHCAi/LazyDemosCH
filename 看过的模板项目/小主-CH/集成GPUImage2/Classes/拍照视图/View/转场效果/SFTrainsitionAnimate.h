//
//  SFTrainsitionAnimate.h
//  CameraDemo
//
//  Created by apple on 2017/6/28.
//  Copyright © 2017年 yangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    animate_push = 0,
    animate_pop = 1,
    
} Animate_Type;
@interface SFTrainsitionAnimate : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithAnimateType:(Animate_Type)type andDuration:(CGFloat)dura;

@property (assign, nonatomic) CGFloat duration;
@property (assign, nonatomic) Animate_Type type;

@end
