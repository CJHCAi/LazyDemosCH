//
//  SFTrainsitionAnimate.h
//  SFTrainsitionDemo
//
//  Created by sfgod on 16/5/13.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import <UIKit/UIKit.h>
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

