//
//  XMGSettingItem.h
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XMGSettingItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
// 用来保存每一行cell的功能
@property (nonatomic, strong) void(^itemOpertion)(NSIndexPath *indexPath);


+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle;

@end
