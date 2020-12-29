//
//  BMModelManager.h
//  Property
//
//  Created by ___liangdahong on 2017/12/8.
//  Copyright © 2017年 ___liangdahong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BMModelManagerBlock)(NSString *str);

@interface BMModelManager : NSObject

+ (NSError *)propertyStringWithJson:(NSString *)json clasName:(NSString *)clasName block:(BMModelManagerBlock)block add:(BOOL)add alignment:(BOOL)alignment;

@end
