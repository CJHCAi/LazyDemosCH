//
//  HK_SeclectFormModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_FormModel.h"
/*
    需要选择,有箭头的样式
 */
@interface HK_SeclectFormModel : HK_FormModel

@property (nonatomic, strong) NSString *placeHolder;

//@property (nonatomic, strong) NSMutableArray *optionItems;

+ (instancetype)formModelWithCellTitle:(NSString *)cellTitle value:(id)value postKey:(NSString *)postKey placeHolder:(NSString *)placeHolder;
@end
