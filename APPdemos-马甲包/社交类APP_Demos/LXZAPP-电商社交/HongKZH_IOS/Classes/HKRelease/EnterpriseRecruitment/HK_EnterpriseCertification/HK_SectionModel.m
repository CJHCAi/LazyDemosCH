//
//  HK_SectionModel.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_SectionModel.h"

@implementation HK_SectionModel

+ (instancetype)modelWithHeader:(NSString *)header footer:(NSString *)footer formItems:(NSMutableArray<HK_FormModel *> *) formItems {
    HK_SectionModel *model = [[HK_SectionModel alloc] init];
    model.header = header;
    model.footer = footer;
    model.formItems = formItems;
    return model;
}

@end
