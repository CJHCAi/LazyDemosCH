//
//  HK_TextFieldFormModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_FormModel.h"

/*
    带 textfield 样式的 cellModel
 */

#define PlaceHolder1 @"请填写"
#define PlaceHolder2 @"请选择"

@interface HK_TextFieldFormModel : HK_FormModel

@property (nonatomic, strong) NSString *placeHolder;    //textfield 的placeHolder

+ (instancetype)formModelWithCellTitle:(NSString *)cellTitle value:(id)value postKey:(NSString *)postKey placeHolder:(NSString *)placeHolder;

@end
