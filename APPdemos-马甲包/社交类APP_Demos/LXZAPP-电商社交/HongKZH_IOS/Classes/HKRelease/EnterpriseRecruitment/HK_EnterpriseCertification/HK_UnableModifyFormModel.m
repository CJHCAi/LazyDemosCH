//
//  HK_UnableModifyFormModel.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_UnableModifyFormModel.h"

@implementation HK_UnableModifyFormModel
+ (instancetype)formModelWithCellTitle:(NSString *)cellTitle value:(id)value postKey:(NSString *)postKey placeHolder:(NSString *)placeHolder {
    HK_UnableModifyFormModel *model = [self new];
    model.cellTitle = cellTitle;
    model.value = value;
    model.postKey = postKey;
    model.placeHolder = placeHolder;
    model.required = NO;    //不需要传
    return model;
}
@end
