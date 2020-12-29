//
//  NSDictionary+HKJson.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HKJson)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
