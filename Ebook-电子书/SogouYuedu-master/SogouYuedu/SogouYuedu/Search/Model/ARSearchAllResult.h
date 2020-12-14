//
//  ARSearchAllResult.h
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARSearchAllResult : NSObject

@property(nonatomic,copy)NSString *list;

@property(nonatomic,assign)NSUInteger pagenum;

@property(nonatomic,assign)NSUInteger pagesize;

@property(nonatomic,assign)NSUInteger pagetotal;

@property(nonatomic,assign)NSUInteger totalnum;

@end
