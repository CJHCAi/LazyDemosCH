//
//  DFUserDefaultStorageService.h
//  coder
//
//  Created by Allen Zhong on 15/5/9.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFUserDefaultStorageService : NSObject

@property (nonatomic, strong) NSUserDefaults *ud;


-(void) sync;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com