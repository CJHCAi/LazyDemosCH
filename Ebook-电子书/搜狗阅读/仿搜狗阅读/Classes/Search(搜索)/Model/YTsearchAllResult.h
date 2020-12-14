//
//  YTsearchAllResult.h
//  仿搜狗阅读
//
//  Created by Mac on 16/6/6.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTsearchAllResult : NSObject

@property(nonatomic,copy)NSString *list;

@property(nonatomic,assign)NSUInteger pagenum;

@property(nonatomic,assign)NSUInteger pagesize;

@property(nonatomic,assign)NSUInteger pagetotal;

@property(nonatomic,assign)NSUInteger totalnum;

@end
