//
//  NSObject+BlockObserver.m
//  UTengineFrameworkTest
//
//  Created by tanzhiwu on 2018/7/16.
//  Copyright © 2018年 tanzhiwu. All rights reserved.
//

#import "NSObject+BlockObserver.h"
#import <objc/message.h>

@interface HFDefaultObserver : NSObject
@property (nonatomic, copy) HFKVOblock kvoBlock;
@property (nonatomic, copy) HFNotificationBlock notificationBlock;

@end

@implementation HFDefaultObserver
- (instancetype)initWithKVOBlock:(HFKVOblock)kvoBlock
{
    if (self = [super init]) {
        _kvoBlock = kvoBlock;
    }
    return self;
}

- (instancetype)initWithNotificationBlock:(HFNotificationBlock)notificationBlock
{
    if (self = [super init]) {
        _notificationBlock = notificationBlock;
    }
    return self;
}

//实现监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (!self.kvoBlock) {
        return;
    }
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) {
        return;
    }
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) {
        return;
    }
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    if (newValue == [NSNull null]) {
        newValue = nil;
    }
    if (oldValue != newValue) {
        self.kvoBlock(object, oldValue, newValue);
    }
}

- (void)handleNotification:(NSNotification *)notification
{
    !self.notificationBlock ?: self.notificationBlock(notification);
}

@end

@implementation NSObject (BlockObserver)

static  NSString * const KHFObserverKey = @"KHFObserverKey";
static  NSString * const KHFNotificationObserversKey = @"KHFNotificationObserversKey";

// 替换dealloc方法，自动注销observer
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalDealloc = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method newDealloc = class_getInstanceMethod(self, @selector(autoRemoveObserverDealloc));
        method_exchangeImplementations(originalDealloc, newDealloc);
    });
}

- (void)autoRemoveObserverDealloc
{
    if (objc_getAssociatedObject(self, (__bridge const void *)KHFObserverKey) || objc_getAssociatedObject(self, (__bridge const void *)KHFNotificationObserversKey)) {
        [self HF_removeAllObserverBlocks];
        [self HF_removeAllNotificationBlocks];
    }
    //这句相当于直接调用dealloc
    [self autoRemoveObserverDealloc];
}

- (void)HF_addObserverForKeyPath:(NSString *)keyPath block:(HFKVOblock)block
{
    if (keyPath.length == 0 || !block) {
        return;
    }
    NSMutableDictionary *observersDict =  objc_getAssociatedObject(self, (__bridge const void *)KHFObserverKey);
    if (!observersDict) {
        observersDict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, (__bridge const void *)KHFObserverKey, observersDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSMutableArray * observers = [observersDict objectForKey:keyPath];
    if (!observers) {
        observers = [NSMutableArray array];
        [observersDict setObject:observers forKey:keyPath];
    }
    HFDefaultObserver *observer = [[HFDefaultObserver alloc] initWithKVOBlock:block];
    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [observers addObject:observer];
}

- (void)HF_removeObserverBlocksForKeyPath:(NSString *)keyPath
{
    if (keyPath.length == 0) {
        return;
    }
    NSMutableDictionary *observersDict = objc_getAssociatedObject(self, (__bridge const void *)KHFObserverKey);
    if (observersDict) {
        NSMutableArray *observers = [observersDict objectForKey:keyPath];
        [observers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeObserver:obj forKeyPath:keyPath];
        }];
        [observersDict removeObjectForKey:keyPath];
    }
}

- (void)HF_removeAllObserverBlocks
{
    NSMutableDictionary *observersDict = objc_getAssociatedObject(self, (__bridge const void *)KHFObserverKey);
    if (observersDict) {
        
        [observersDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *obsevers, BOOL * _Nonnull stop) {
            [obsevers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self removeObserver:obj forKeyPath:key];
            }];
        }];
        [observersDict removeAllObjects];
    }
}

- (void)HF_addNotificationForName:(NSString *)name block:(HFNotificationBlock)block
{
    if (name.length == 0 || !block) {
        return;
    }
    NSMutableDictionary *observersDict = objc_getAssociatedObject(self, (__bridge const void *)KHFNotificationObserversKey);
    if (!observersDict) {
        observersDict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, (__bridge const void *)KHFNotificationObserversKey, observersDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSMutableArray *observers = [observersDict objectForKey:name];
    if (!observers) {
        observers = [NSMutableArray array];
        [observersDict setObject:observers forKey:name];
    }
    HFDefaultObserver *observer = [[HFDefaultObserver alloc] initWithNotificationBlock:block];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(handleNotification:) name:name object:nil];
    [observers addObject:observer];
    
}

- (void)HF_removeNotificationBlocksForName:(NSString *)name
{
    if (name.length == 0) {
        return;
    }
    NSMutableDictionary *observersDict = objc_getAssociatedObject(self, (__bridge const void *)KHFNotificationObserversKey);
    if (observersDict) {
        NSMutableArray *observers = [observersDict objectForKey:name];
        [observers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] removeObserver:obj name:name object:nil];
        }];
        [observersDict removeObjectForKey:name];
    }
   
}

- (void)HF_removeAllNotificationBlocks
{
    NSMutableDictionary *observersDict = objc_getAssociatedObject(self, (__bridge const void *)KHFNotificationObserversKey);
    [observersDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *observers, BOOL * _Nonnull stop) {
        [observers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] removeObserver:obj name:key object:nil];
        }];
    }];
    [observersDict removeAllObjects];
}

@end
