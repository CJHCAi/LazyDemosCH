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
