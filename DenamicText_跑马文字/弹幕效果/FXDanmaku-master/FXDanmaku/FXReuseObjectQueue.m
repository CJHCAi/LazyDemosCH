//
//  FXReuseObjectQueue.m
//  FXKit
//
//  Created by ShawnFoo on 2016/12/28.
//  Copyright © 2016年 ShawnFoo. All rights reserved.
//

#import "FXReuseObjectQueue.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSMutableSet *FXReuseObjectSet;
typedef NSMutableDictionary<NSString*, FXReuseObjectSet> *FXReuseObjectSetDictionary;
typedef NSMutableDictionary<NSString*, id> *FXNibsOrClassNamesDictionary;

@interface FXReuseObjectQueue ()

@property (nonatomic, assign) NSUInteger maxCountOfUnusedObjects;
@property (nonatomic, strong) FXReuseObjectSetDictionary unusedObjectsSetDictionary;
@property (nonatomic, strong) FXNibsOrClassNamesDictionary nibsOrClassNamesDictionary;
@property (nonatomic, strong) id memoryWarningNotifToken;

@end

@implementation FXReuseObjectQueue

#pragma mark - Factory
+ (instancetype)queue {
    return [self queueWithMaxCountOfUnusedObjects:0];
}

+ (instancetype)queueWithMaxCountOfUnusedObjects:(NSUInteger)maxCount {
    return [[self alloc] initWithMaxCountOfUnusedObjects:maxCount];
}

#pragma mark - LifeCycle
- (instancetype)initWithMaxCountOfUnusedObjects:(NSUInteger)maxCount {
    if (self = [super init]) {
        _maxCountOfUnusedObjects = maxCount > 0 ? maxCount : 20;
		[self setupObserver];
    }
    return self;
}

- (instancetype)init {
    return [self initWithMaxCountOfUnusedObjects:0];
}

- (void)dealloc {
	[self removeObserver];
}

#pragma mark - Observer
- (void)setupObserver {
    __weak typeof(self) weakSelf = self;
    self.memoryWarningNotifToken =
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification
													  object:nil
													   queue:nil
												  usingBlock:^(NSNotification * _Nonnull note)
	 {
		 [weakSelf emptyUnusedObjects];
	 }];
}

- (void)removeObserver {
	[[NSNotificationCenter defaultCenter] removeObserver:self.memoryWarningNotifToken];
}

#pragma mark - Resubale Object Register
- (void)registerClass:(nullable Class)cls forObjectReuseIdentifier:(NSString *)identifier {
	[self registerNibOrClass:cls withReuseIdentifier:identifier];
}

- (void)registerNib:(nullable UINib *)nib forObjectReuseIdentifier:(NSString *)identifier {
    [self registerNibOrClass:nib withReuseIdentifier:identifier];
}

- (void)registerNibOrClass:(nullable id)nibOrClass withReuseIdentifier:(NSString *)identifier {
	BOOL isNib = [nibOrClass isKindOfClass:[UINib class]];
	BOOL isClassObject = [nibOrClass class] == nibOrClass;
	if (isNib || isClassObject) {
		self.nibsOrClassNamesDictionary[identifier] = isClassObject ? NSStringFromClass(nibOrClass) : nibOrClass;
	}
	else {
		[self unregisterResueObjectWithIdentifier:identifier];
	}
}

- (void)unregisterResueObjectWithIdentifier:(NSString *)identifier {
    if (identifier.length) {
        [self.nibsOrClassNamesDictionary removeObjectForKey:identifier];
    }
}

#pragma mark - Queue Operation
- (void)enqueueReuseObject:(FXReuseObject)object {
    NSString *identifier = nil;
    if ([object respondsToSelector:@selector(reuseIdentifier)]
        && (identifier = [object reuseIdentifier]))
    {
        FXReuseObjectSet set = [self unusedObjectsSetWithIdentifier:identifier];
        if (set.count < self.maxCountOfUnusedObjects) {
            if ([object respondsToSelector:@selector(prepareForReuse)]) {
                [object prepareForReuse];
            }
            [set addObject:object];
        }
    }
}

- (nullable FXReuseObject)dequeueReuseObjectWithIdentifier:(NSString *)identifier {
    if (identifier) {
        FXReuseObjectSet set = [self unusedObjectsSetWithIdentifier:identifier];
        if (set.count) {
            FXReuseObject object = [set anyObject];
            [set removeObject:object];
            return object;
        }
        else {
            return [self reuseObjectWithIdentifier:identifier];
        }
    }
    return nil;
}

- (void)emptyUnusedObjects {
    [self.unusedObjectsSetDictionary removeAllObjects];
}

#pragma mark - LazyLoading
- (FXReuseObjectSetDictionary)unusedObjectsSetDictionary {
	if (!_unusedObjectsSetDictionary) {
		_unusedObjectsSetDictionary = [NSMutableDictionary dictionary];
	}
	return _unusedObjectsSetDictionary;
}

- (FXNibsOrClassNamesDictionary)nibsOrClassNamesDictionary {
	if (!_nibsOrClassNamesDictionary) {
		_nibsOrClassNamesDictionary = [NSMutableDictionary dictionary];
	}
	return _nibsOrClassNamesDictionary;
}

#pragma mark - Accessor
- (FXReuseObjectSet)unusedObjectsSetWithIdentifier:(NSString *)identifier {
	FXReuseObjectSet set = self.unusedObjectsSetDictionary[identifier];
	if (!set) {
		set = [NSMutableSet set];
		self.unusedObjectsSetDictionary[identifier] = set;
	}
	return set;
}

- (nullable FXReuseObject)reuseObjectWithIdentifier:(NSString *)identifier {
	id nibOrClassName = self.nibsOrClassNamesDictionary[identifier];
	if ([nibOrClassName isKindOfClass:[NSString class]]) {
		Class cls = NSClassFromString(nibOrClassName);
		if ([cls instancesRespondToSelector:@selector(initWithReuseIdentifier:)]) {
			return [[cls alloc] initWithReuseIdentifier:identifier];
		}
		return [[cls alloc] init];
	}
	else if ([nibOrClassName isKindOfClass:[UINib class]]) {
		return [(UINib *)nibOrClassName instantiateWithOwner:nil options:nil].firstObject;
	}
	return nil;
}

@end

NS_ASSUME_NONNULL_END
