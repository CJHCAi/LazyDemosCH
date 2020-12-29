//
//  HKObject2JsonTool.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKObject2JsonTool : NSObject

+ (NSString *)getJsonFromObj:(id)obj;

+ (NSDictionary*)getObjectData:(id)obj;

@end
