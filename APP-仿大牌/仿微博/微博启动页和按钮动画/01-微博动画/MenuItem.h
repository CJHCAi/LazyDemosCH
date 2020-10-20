//
//  MenuItem.h
//  01-微博动画
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface MenuItem : NSObject


@property (nonatomic, strong) NSString *title;


@property (nonatomic, strong) UIImage *image;


+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image;


@end
