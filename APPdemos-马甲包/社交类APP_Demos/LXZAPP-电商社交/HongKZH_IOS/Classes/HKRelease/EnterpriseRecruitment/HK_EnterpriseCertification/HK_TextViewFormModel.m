//
//  HK_TextViewFormModel.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_TextViewFormModel.h"

@implementation HK_TextViewFormModel

+ (instancetype)formModelWithCellTitle:(NSString *)cellTitle value:(id)value postKey:(NSString *)postKey placeHolder:(NSString *)placeHolder {
    HK_TextViewFormModel *model = [self new];
    model.cellTitle = cellTitle;
    model.value = value;
    model.postKey = postKey;
    model.placeHolder = placeHolder;
    model.cellHeight = 188;
    return model;
}

@end
