//
//  NSArray+WAllItemString.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/4.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "NSArray+WAllItemString.h"

@implementation NSArray (WAllItemString)
+(NSString *)allItemsStringFromArray:(NSArray *)strArray{
    __block NSString *finStr = @"";
    [strArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        finStr = [NSString stringWithFormat:@"%@%@",obj,finStr];
    }];
    
    return finStr;
}
@end
