//
//  BaseArray.h
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseArray : NSObject

@property(strong,nonatomic)NSString * subName;//元素的类型名
@property(strong,nonatomic)NSMutableArray * data;//存放数据的数组

-(id)initWithSubName:(NSString *)subName;
@end
