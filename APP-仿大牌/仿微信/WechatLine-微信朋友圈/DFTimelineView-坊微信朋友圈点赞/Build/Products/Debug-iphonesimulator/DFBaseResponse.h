//
//  HCBaseResponse.h
//  Heacha
//
//  Created by Allen Zhong on 15/1/13.
//  Copyright (c) 2015年 Datafans Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFBaseResponse : NSObject
@property (nonatomic, strong) id data;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, strong) NSString *errorMsg;

- (instancetype)initWithData:(NSDictionary *)dic;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com