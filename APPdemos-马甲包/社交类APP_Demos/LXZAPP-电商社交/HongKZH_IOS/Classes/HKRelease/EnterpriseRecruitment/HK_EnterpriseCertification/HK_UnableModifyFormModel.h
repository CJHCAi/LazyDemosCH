//
//  HK_UnableModifyFormModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_FormModel.h"
/*
    不可修改内容的 cell 类型
 */
@interface HK_UnableModifyFormModel : HK_FormModel

@property (nonatomic, strong) NSString *placeHolder;

+ (instancetype)formModelWithCellTitle:(NSString *)cellTitle value:(id)value postKey:(NSString *)postKey placeHolder:(NSString *)placeHolder ;
@end
