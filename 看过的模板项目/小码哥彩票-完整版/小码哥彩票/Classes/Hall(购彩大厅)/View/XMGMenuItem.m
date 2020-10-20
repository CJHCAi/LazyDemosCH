//
//  XMGMenuItem.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/28.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGMenuItem.h"

@implementation XMGMenuItem
+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title
{
    XMGMenuItem *item = [[self alloc] init];
    item.image = image;
    item.title = title;
    
    return item;
}
@end
