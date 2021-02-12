//
//  Cyhkeychain.h
//  VPNconect
//
//  Created by Macx on 16/4/20.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface LSTKeyChain  : NSObject
/**
 *  保存键值至钥匙串
 *
 *  @param service 保存标识
 *  @param data    保存的对象
 */
+ (void)save_key:(NSString *)service data_values:(id)data;
/**
 *  查询钥匙串
 *
 *  @param service <#service description#>
 *
 *  @return <#return value description#>
 */
+ (id)load_key:(NSString *)service;
/**
 *  删除钥匙串
 *
 *  @param service <#service description#>
 */
+ (void)delete_key:(NSString *)service;

@end
