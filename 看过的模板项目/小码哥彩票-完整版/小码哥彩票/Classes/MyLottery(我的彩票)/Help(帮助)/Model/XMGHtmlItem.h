//
//  XMGHtmlItem.h
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGHtmlItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *html;
@property (nonatomic, strong) NSString *ID;

+ (instancetype)itemWithDict:(NSDictionary *)dict;

@end
