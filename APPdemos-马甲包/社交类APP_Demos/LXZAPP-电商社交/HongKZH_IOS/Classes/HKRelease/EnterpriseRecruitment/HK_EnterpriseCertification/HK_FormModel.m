//
//  HK_FormModel.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_FormModel.h"

@implementation HK_FormModel

static float const cellHeightValue = 50.f;

- (instancetype)init {
    if (self = [super init]) {
        //设置行高默认值
        self.cellHeight = cellHeightValue;
        self.required = YES;
    }
    return self;
}


+ (instancetype)formModelWithCellTitle:(NSString *)cellTitle value:(id)value postKey:(NSString *)postKey {
    HK_FormModel *model = [self new];
    model.cellTitle = cellTitle;
    model.value = value;
    model.postKey = postKey;
    return model;
}

//验证数据完整性
- (void)verifyDataIntegrityWithFaliureBlock:(void(^)(NSString *cellTitle)) block {
    if (self.required) {
        DLog(@"self.value ====== %@----%@",self.value,[self.value class]);
        if (self.value == nil) {  //如果没有赋值,则调用 失败的block
            block(self.cellTitle);
        } else {
            if ([self.value isKindOfClass:[NSString class]]) {
                if ([self.value isEqualToString:@""]) { //如果赋值为@""字符串,也需要重新赋值
                    block(self.cellTitle);
                }
            }
        }
    }
}


@end
