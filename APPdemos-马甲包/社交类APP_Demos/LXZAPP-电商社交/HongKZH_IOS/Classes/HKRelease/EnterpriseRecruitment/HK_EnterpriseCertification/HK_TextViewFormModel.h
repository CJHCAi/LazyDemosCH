//
//  HK_TextViewFormModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_FormModel.h"

@interface HK_TextViewFormModel : HK_FormModel

@property (nonatomic, strong) NSString *placeHolder;    //textfield 的placeHolder

+ (instancetype)formModelWithCellTitle:(NSString *)cellTitle value:(id)value postKey:(NSString *)postKey placeHolder:(NSString *)placeHolder;

@end
