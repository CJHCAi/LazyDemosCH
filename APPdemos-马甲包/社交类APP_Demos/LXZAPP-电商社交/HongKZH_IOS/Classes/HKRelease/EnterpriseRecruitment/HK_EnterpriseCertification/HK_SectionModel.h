//
//  HK_SectionModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HK_FormModel.h"
/*
    tableview section 的数据
*/

@interface HK_SectionModel : NSObject

@property (nonatomic, strong) NSString *header;

@property (nonatomic, strong) NSString *footer;

@property (nonatomic, strong) NSMutableArray<HK_FormModel *> *formItems;

+ (instancetype)modelWithHeader:(NSString *)header footer:(NSString *)footer formItems:(NSMutableArray<HK_FormModel *> *) formItems;

@end
