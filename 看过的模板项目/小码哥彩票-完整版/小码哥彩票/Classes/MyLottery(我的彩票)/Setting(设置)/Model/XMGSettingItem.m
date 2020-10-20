//
//  XMGSettingItem.m
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGSettingItem.h"

@implementation XMGSettingItem
+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle{
    XMGSettingItem *item = [[self alloc] init];
    item.image = image;
    item.title = title;
    item.subTitle = subTitle;
    return item;
}
@end
