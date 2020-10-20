//
//  FXDanmakuConfig.m
//  FXDanmakuDemo
//
//  Created by ShawnFoo on 2017/1/4.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "FXDanmakuConfiguration.h"
#import "FXDanmakuMacro.h"
#import <objc/runtime.h>

@implementation FXDanmakuConfiguration

#pragma mark - Default Configuration
+ (instancetype)defaultConfiguration {
    FXDanmakuConfiguration *config = [FXDanmakuConfiguration new];
    
    config.dataQueueCapacity = 666;
    config.itemInsertOrder = FXDanmakuItemInsertOrderFromTop;
    config.itemMoveDirection = FXDanmakuItemMoveDirectionRightToLeft;
    
    config.rowHeight = 40;
    config.estimatedRowSpace = 2;
    config.moveRatioToResetOccupiedRow = 0.25;
    
    config.itemMinVelocity = 90;
    config.itemMaxVelocity = 120;
    
    return config;
}

+ (instancetype)singleRowConfigurationWithHeight:(CGFloat)height {
    const NSUInteger cSpeed = 90;
    
    FXDanmakuConfiguration *config = [self defaultConfiguration];
    config.dataQueueCapacity = 120;
    config.rowHeight = height;
    config.estimatedRowSpace = 0;
    config.moveRatioToResetOccupiedRow = 0.1;
    config.itemMinVelocity = cSpeed;
    config.itemMaxVelocity = cSpeed;
    
    return config;
}

#pragma mark - KVO
+ (BOOL)automaticallyNotifiesObserversOfItemMaxVelocity {
    return NO;
}

#pragma mark - Designated Initializer 
- (instancetype)init {
    if (self = [super init]) {
        _dataQueueCapacity = NSUIntegerMax;
    }
    return self;
}

#pragma mark - Accessor
- (void)setItemMaxVelocity:(NSUInteger)itemMaxVelocity {
    if (itemMaxVelocity < _itemMinVelocity) {
        FXLogD(@"The itemMaxVelocity can't be smaller than minVelocity");
    }
    else {
        [self willChangeValueForKey:FXNSStringFromSelectorName(itemMaxVelocity)];
        _itemMaxVelocity = itemMaxVelocity;
        [self didChangeValueForKey:FXNSStringFromSelectorName(itemMaxVelocity)];
    }
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    FXDanmakuConfiguration *configuration = [[[self class] alloc] init];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (properties) {
        for (int i = 0; i < count; i++) {
            NSString *key = [NSString stringWithFormat:@"%s", property_getName(properties[i])];
            [configuration setValue:[self valueForKey:key] forKey:key];
        }
        free(properties);
    }
    return configuration;
}

@end
