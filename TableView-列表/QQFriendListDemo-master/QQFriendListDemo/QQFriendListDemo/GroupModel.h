//
//  GroupModel.h
//  核心动画
//
//  Created by 朱伟阁 on 2019/1/26.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FriendModel;

NS_ASSUME_NONNULL_BEGIN

@interface GroupModel : NSObject

@property(nonatomic, strong) NSArray<FriendModel *> *friends;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *online;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)groupWithDict:(NSDictionary *)dict;

+ (NSDictionary *)mj_objectClassInArray;

@property(nonatomic, assign,getter=isVisible) BOOL visible;

@end

NS_ASSUME_NONNULL_END
