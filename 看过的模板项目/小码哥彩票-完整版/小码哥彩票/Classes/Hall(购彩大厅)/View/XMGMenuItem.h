//
//  XMGMenuItem.h
//  小码哥彩票
//
//  Created by xiaomage on 15/6/28.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XMGMenuItem : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title;

@end
