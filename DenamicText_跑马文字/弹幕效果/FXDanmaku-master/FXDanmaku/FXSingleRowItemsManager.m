//
//  FXSingleRowItemsManager.m
//  FXDanmakuDemo
//
//  Created by ShawnFoo on 2017/1/5.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "FXSingleRowItemsManager.h"
#import "FXDanmakuItem.h"

@interface FXSingleRowItemsManager ()

@property (nonatomic, strong) NSHashTable<FXDanmakuItem *> *items;

@end

@implementation FXSingleRowItemsManager

#pragma mark - LazyLoading
- (NSHashTable<FXDanmakuItem *> *)items {
    if (!_items) {
        _items = [NSHashTable weakObjectsHashTable];
    }
    return _items;
}

#pragma mark - Hit Test
- (FXDanmakuItem *)itemAtPoint:(CGPoint)point {
    for (FXDanmakuItem *item in self.items) {
        if ([item.layer.presentationLayer hitTest:point]) {
            return item;
        }
    }
    return nil;
}

#pragma mark - Operations
- (void)addDanmakuItem:(FXDanmakuItem *)item {
    if ([item isKindOfClass:[FXDanmakuItem class]]) {
        [self.items addObject:item];
    }
}

- (void)removeDanmakuItem:(FXDanmakuItem *)item {
    [self.items removeObject:item];
}

@end
