//
//  CXDBTool.h
//  CXShearchBar_Example
//
//  Created by caixiang on 2019/4/26.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CXSearchModel;

NS_ASSUME_NONNULL_BEGIN

@interface CXDBTool : NSObject

/**
 *  根据参数去取数据
 *
 *  @param key
 *
 */
+ (id)statusesWithKey:(NSString *)key;

/**
 *  存储服务器数据到沙盒中
 *
 *  @param statuses 需要存储的数据
 */
+ (void)saveStatuses:(id)statuses key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
