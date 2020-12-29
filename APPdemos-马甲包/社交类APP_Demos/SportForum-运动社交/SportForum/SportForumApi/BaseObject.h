//
//  BaseObject.h
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface BaseObject : NSObject

@property(strong,nonatomic)NSString * subName;//元素的类型名

- (BOOL)reflectDataFromOtherObject:(NSObject*)dataSource;
- (NSMutableDictionary *)convertDictionary;
@end
