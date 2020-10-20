 //
//  XMGHtmlItem.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGHtmlItem.h"



@implementation XMGHtmlItem
+ (instancetype)itemWithDict:(NSDictionary *)dict
{
    XMGHtmlItem *item = [XMGHtmlItem objcWithDict:dict mapDict:@{@"ID":@"id"}];
        
    return item;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        [self setValue:value forKeyPath:@"ID"];
        
    }else{
        
        [super setValue:value forKey:key];
        
    }
    
}

@end
