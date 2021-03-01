//
//  BUCNAuxiliaryManager.h
//  BUCNAuxiliary
//
//  Created by bytedance on 2020/8/26.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BUCNAuxiliaryManager : NSObject
+ (instancetype)shareManager;
///设置地区
+ (void)setTerritory:(NSString *)territory;
///获取地区
+ (NSString *)territory;

@end

NS_ASSUME_NONNULL_END
