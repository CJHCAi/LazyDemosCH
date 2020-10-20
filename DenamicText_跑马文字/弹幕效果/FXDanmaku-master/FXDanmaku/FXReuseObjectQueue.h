//
//  FXReuseObjectQueue.h
//  FXKit
//
//  Created by ShawnFoo on 2016/12/28.
//  Copyright © 2016年 ShawnFoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FXObjectReusable;

NS_ASSUME_NONNULL_BEGIN

typedef id<FXObjectReusable> FXReuseObject;

#pragma mark - FXReuseObjectQueue
@interface FXReuseObjectQueue : NSObject

#pragma mark Initilizer
+ (instancetype)queue;
+ (instancetype)queueWithMaxCountOfUnusedObjects:(NSUInteger)maxCount;
- (instancetype)initWithMaxCountOfUnusedObjects:(NSUInteger)maxCount NS_DESIGNATED_INITIALIZER;

#pragma mark Resubale Object Register
- (void)registerClass:(nullable Class)cls forObjectReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forObjectReuseIdentifier:(NSString *)identifier;
- (void)unregisterResueObjectWithIdentifier:(NSString *)identifier;

#pragma mark Queue Operation
- (void)enqueueReuseObject:(FXReuseObject)object;
- (nullable FXReuseObject)dequeueReuseObjectWithIdentifier:(NSString *)identifier;
- (void)emptyUnusedObjects;

@end


#pragma mark - FXObjectReusable
@protocol FXObjectReusable <NSObject>

- (instancetype)initWithReuseIdentifier:(NSString *)identifier;
- (NSString *)reuseIdentifier;
@optional
- (void)prepareForReuse;

@end

NS_ASSUME_NONNULL_END
