//
//  BaseObject.m
//  SportForumApi
//
//  Created by liyuan on 14-1-3.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import "BaseObject.h"
#import "BaseArray.h"

@implementation BaseObject

#pragma mark --------利用反射取得NSObject的属性，并存入到数组中
- (NSArray*)getPropertyList
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    
    free(properties);
    return keys;
}

#pragma mark -----------完成对象的自动赋值
- (BOOL)reflectDataFromOtherObject:(NSObject*)dataSource
{
    BOOL ret = NO;

    for (NSString *key in [self getPropertyList]) {
        if ([dataSource isKindOfClass:[NSDictionary class]]) {
            ret = ([dataSource valueForKey:key]==nil)?NO:YES;
        }
        else
        {
            ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
        }
        
        if (ret) {
            id propertyValue = [dataSource valueForKey:key];

            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
                if([propertyValue isKindOfClass:[NSDictionary class]])
                {
                    [[self valueForKey:key] reflectDataFromOtherObject:propertyValue];
                }
                else if ([propertyValue isKindOfClass:[NSArray class]])
                {
                    [self setValue:[self analyzeArrayWithSource:propertyValue KeyValueName:key] forKey:key];
                }
                else
                {
                    [self setValue:propertyValue forKey:key];
                }
            }
        }
    }
    
    return ret;
}

- (NSMutableDictionary *)convertDictionary{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    objc_property_t *props = class_copyPropertyList([self class], &outCount);
    for(int i=0;i<outCount;i++){
        objc_property_t prop = props[i];
        NSString *propName = [[NSString alloc]initWithCString:property_getName(prop) encoding:NSUTF8StringEncoding];
        id propValue = [self valueForKey:propName];
        if(propValue){
            [dict setObject:propValue forKey:propName];
        }
    }
    
    free(props);
    return dict;
}

#pragma mark ---------解析数组
- (BaseArray *)analyzeArrayWithSource:(id)object KeyValueName:(NSString*)strKey
{
    BaseArray * myArr = [[BaseArray alloc] initWithSubName:((BaseArray*)[self valueForKey:strKey]).subName];
    NSArray * data = object;
    Class subClass = NSClassFromString(myArr.subName);

    if(subClass != [NSNull class])
    {
        NSMutableArray * arr =[[NSMutableArray alloc]init];
        for (id obj in data) {
            id subObject =[[subClass alloc] init];
            
            if([subObject isKindOfClass:[BaseObject class]])
            {
                [subObject reflectDataFromOtherObject:obj];
            }
            else
            {
                subObject = obj;
            }
            
            [arr addObject:subObject];
        }
        
        myArr.data = arr;
    }
    
    return myArr;
}

@end
