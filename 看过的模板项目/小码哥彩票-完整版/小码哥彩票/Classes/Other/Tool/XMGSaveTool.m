//
//  XMGSaveTool.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGSaveTool.h"

@implementation XMGSaveTool

+ (id)objectForKey:(NSString *)defaultName{
   return  [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}


+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
     [[NSUserDefaults standardUserDefaults] setObject:defaultName forKey:defaultName];
}
@end
