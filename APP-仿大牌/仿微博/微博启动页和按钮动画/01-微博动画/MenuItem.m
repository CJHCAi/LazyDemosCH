//
//  MenuItem.m
//  01-微博动画
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image
{
    MenuItem *itme = [[self alloc] init];
    
    itme.title = title;
    itme.image = image;
    
    return itme;
}

@end
