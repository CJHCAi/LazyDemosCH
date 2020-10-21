//
//  CXSearchProtocol.h
//  CXShearchBar_Example
//
//  Created by caixiang on 2019/4/29.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CXSearchProtocol <NSObject>

/**
 内容
 */
@property (nonatomic, copy) NSString *content;

/**
 搜索内容id
 */
@property (nonatomic, copy) NSString *searchId;

@end

NS_ASSUME_NONNULL_END
