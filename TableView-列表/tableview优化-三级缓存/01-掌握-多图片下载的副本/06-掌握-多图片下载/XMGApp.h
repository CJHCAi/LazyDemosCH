//
//  XMGApp.h
//  06-掌握-多图片下载
//
//  Created by xiaomage on 15/7/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGApp : NSObject
/** 图标 */
@property (nonatomic, strong) NSString *icon;
/** 下载量 */
@property (nonatomic, strong) NSString *download;
/** 名字 */
@property (nonatomic, strong) NSString *name;

+ (instancetype)appWithDict:(NSDictionary *)dict;
@end
