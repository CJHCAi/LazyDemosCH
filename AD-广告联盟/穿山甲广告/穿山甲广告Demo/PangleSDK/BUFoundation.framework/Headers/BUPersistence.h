//
//  BUPersistence.h
//  BUPersistence
//
//  Created by Chen Hong on 2017/1/10.
//  Copyright © 2017年 Chen Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, BUPersistentType) {
    BUPersistentTypePlist,
    BUPersistentTypeKeyChain,
    BUPersistentTypeCustom,
};

@interface BUPersistenceOption : NSObject

@property (nonatomic) BUPersistentType type;

@property (nonatomic) BOOL shouldRemoveAllObjectsOnMemoryWarning;

@property (nonatomic) BOOL shouldRemoveAllObjectsWhenEnteringBackground;

@property (nonatomic) BOOL supportNSCoding;

@end

@protocol BUPersistenceProtocol <NSObject>

- (NSArray *)allObjects;

- (nullable id)objectForKey:(NSString *)key;

- (nullable NSArray *)objectsForKeys:(NSArray *)keys;

- (void)updateObjectsForKeys:(NSArray *)keys WithBlock:(NSDictionary * (^)(NSArray *objects))block;

- (BOOL)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key;

- (BOOL)hasObjectForKey:(NSString *)key;

- (BOOL)removeAll;

- (BOOL)removeObjectsForKeys:(NSArray<NSString *> *)keys;

- (BOOL)save;

@end

@interface BUPersistence : NSObject <BUPersistenceProtocol>

+ (nullable instancetype)persistenceWithName:(NSString *)name;

+ (nullable instancetype)persistenceWithName:(NSString *)name option:(BUPersistenceOption *)option;

+ (void)deleteWithName:(NSString *)name;

+ (NSString *)cacheDirectory;

@end

NS_ASSUME_NONNULL_END
