//
//  NSObject+BlockObserver.h
//  UTengineFrameworkTest
//
//  Created by tanzhiwu on 2018/7/16.
//  Copyright © 2018年 tanzhiwu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HFKVOblock)(__weak id object, id oldValue, id newValue);
typedef void(^HFNotificationBlock)(NSNotification *notification);
@interface NSObject (BlockObserver)

- (void)HF_addObserverForKeyPath:(NSString *)keyPath block:(HFKVOblock)block;
- (void)HF_removeObserverBlocksForKeyPath:(NSString *)keyPath;
- (void)HF_removeAllObserverBlocks;

- (void)HF_addNotificationForName:(NSString *)name block:(HFNotificationBlock)block;
- (void)HF_removeNotificationBlocksForName:(NSString *)name;
- (void)HF_removeAllNotificationBlocks;

@end
