//
//  HK_SeclectFormModel.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_SeclectFormModel.h"

@implementation HK_SeclectFormModel

+ (instancetype)formModelWithCellTitle:(NSString *)cellTitle value:(id)value postKey:(NSString *)postKey placeHolder:(NSString *)placeHolder {
    HK_SeclectFormModel *model = [self new];
    model.cellTitle = cellTitle;
    model.value = value;
    model.postKey = postKey;
    model.placeHolder = placeHolder;
    return model;
}

@end
