//
//  NSObject+Model.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "NSObject+Model.h"

#import <objc/runtime.h>

@implementation NSObject (Model)

+ (instancetype)objcWithDict:(NSDictionary *)dict mapDict:(NSDictionary *)mapDict
{
    id objc = [[self alloc] init];
    
    
    // 遍历模型中属性
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self, &count);
    
    for (int i = 0 ; i < count; i++) {
        Ivar ivar = ivars[i];
        
        // 属性名称
        NSString *ivarName = @(ivar_getName(ivar));
        
        
        ivarName = [ivarName substringFromIndex:1];
        
        id value = dict[ivarName];
        // 需要由外界通知内部，模型中属性名对应字典里面的哪个key
        // ID -> id
        if (value == nil) {
            if (mapDict) {
            NSString *keyName = mapDict[ivarName];
                
            value = dict[keyName];
            }
        }

            
            [objc setValue:value forKeyPath:ivarName];
        
        
    }
    
    
    return objc;
}

@end
