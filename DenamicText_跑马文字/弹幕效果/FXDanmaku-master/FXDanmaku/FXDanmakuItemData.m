//
//  FXDanmakuItemData.m
//  FXDanmakuDemo
//
//  Created by ShawnFoo on 2017/1/2.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "FXDanmakuItemData.h"
#import "FXDanmakuItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface FXDanmakuItemData ()

@property (nonatomic, copy) NSString *itemReuseIdentifier;

@end

@implementation FXDanmakuItemData

#pragma mark - Factory
+ (nullable instancetype)dataWithItemReuseIdentifier:(NSString *)identifier {
    return [[self alloc] initWithItemReuseIdentifier:identifier priority:FXDataPriorityNormal];
}

+ (nullable instancetype)highPriorityDataWithItemReuseIdentifier:(NSString *)identifier {
    return [[self alloc] initWithItemReuseIdentifier:identifier priority:FXDataPriorityHigh];
}

#pragma mark - Initializer
- (nullable instancetype)initWithItemReuseIdentifier:(NSString *)identifier priority:(FXDataPriority)priority {
    if (self = [super init]) {
        _itemReuseIdentifier = [identifier copy];
        _priority = priority;
    }
    return self.itemReuseIdentifier.length > 0 ? self : nil;
}

@end

NS_ASSUME_NONNULL_END
