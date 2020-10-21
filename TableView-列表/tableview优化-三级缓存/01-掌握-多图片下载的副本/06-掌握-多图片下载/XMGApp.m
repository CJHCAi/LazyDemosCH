//
//  XMGApp.m
//  06-掌握-多图片下载
//
//  Created by xiaomage on 15/7/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGApp.h"

@implementation XMGApp
+ (instancetype)appWithDict:(NSDictionary *)dict
{
    XMGApp *app = [[self alloc] init];
    [app setValuesForKeysWithDictionary:dict];
    return app;
}
@end
