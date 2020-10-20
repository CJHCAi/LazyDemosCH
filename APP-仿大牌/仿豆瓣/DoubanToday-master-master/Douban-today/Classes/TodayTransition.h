//
//  TodayTransition.h
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    TodayTransitionTypePush = 0,
    TodayTransitionTypePop,
    
} TodayTransitionType;

@interface TodayTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) TodayTransitionType type;

+ (instancetype)transitionWithTransitionType:(TodayTransitionType)type;
- (instancetype)initWithTransitionWithTransitionType:(TodayTransitionType)type;

@end
