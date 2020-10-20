//
//  XMGSettingGroup.h
//  小码哥彩票
//
//  Created by xiaomage on 15/7/1.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGSettingGroup : NSObject

// items(XMGSettingItem)
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *headTitle;
@property (nonatomic, strong) NSString *footTitle;

+ (instancetype)groupWithItems:(NSArray *)items;

@end
