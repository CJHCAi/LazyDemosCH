//
//  XDRichTextModel.m
//  XDZHBook
//
//  Created by 刘昊 on 2018/4/23.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import "XDRichTextModel.h"

@implementation XDRichTextModel
+(XDRichTextModel *)prepareDictionryChangeToModel:(NSDictionary *)dic{
    XDRichTextModel *model = [[XDRichTextModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
