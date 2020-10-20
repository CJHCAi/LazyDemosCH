//
//  FXDanmakuConfiguration.h
//  FXDanmakuDemo
//
//  Created by ShawnFoo on 2017/1/4.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

typedef NS_ENUM(NSUInteger, FXDanmakuItemInsertOrder) {
    FXDanmakuItemInsertOrderFromTop,
    FXDanmakuItemInsertOrderFromBottom,
    FXDanmakuItemInsertOrderRandom
};

typedef NS_ENUM(NSUInteger, FXDanmakuItemMoveDirection) {
    FXDanmakuItemMoveDirectionRightToLeft,
    FXDanmakuItemMoveDirectionLeftToRight
};

@interface FXDanmakuConfiguration : NSObject <NSCopying>

/**
 Data will not enqueue if the count of data in queue has reached this capacity.
 */
@property (nonatomic, assign) NSUInteger dataQueueCapacity;

/**
 The order of all items' insertion.
 */
@property (nonatomic, assign) FXDanmakuItemInsertOrder itemInsertOrder;

/**
 The direction of all items' movement.
 */
@property (nonatomic, assign) FXDanmakuItemMoveDirection itemMoveDirection;

/**
 Row hight will be also the danmakuItem's height.
 */
@property (nonatomic, assign) CGFloat rowHeight;

/**
 Estimated vertical space between two row. Can't be negative! >=0
 */
@property (nonatomic, assign) CGFloat estimatedRowSpace;

/**
 The ratio(movement/danmaku's width) to reset occupied row that is displaying item.
 
 For example, when this value is 0.25 and the width of danmaku view is 100pt, then after moving 25pt(0.1 * 100pt)
 from the begining, the danmakuItem is not occupied its row anymore, so any other items can be inserted to this unoccupied row.
 */
@property (nonatomic, assign) float moveRatioToResetOccupiedRow;

/**
 The min velocity of item movement.
 */
@property (nonatomic, assign) NSUInteger itemMinVelocity;

/**
 The max velocity of item movement.
 */
@property (nonatomic, assign) NSUInteger itemMaxVelocity;

+ (instancetype)defaultConfiguration;
+ (instancetype)singleRowConfigurationWithHeight:(CGFloat)height;

@end
