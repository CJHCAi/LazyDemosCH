//
//  ZHBProductAttrsInfoModel.m
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/29.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "ZHBProductAttrsInfoModel.h"

#pragma mark - ZHBProductAttrsInfoModel
@implementation ZHBProductAttrsInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"title": @"title",
             @"type": @"type",
             @"value": @"value"
             };
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"value" : [ZHBBottonsValueModel class],
             };
}
@end


#pragma mark - ZHBBottonsValueModel

@implementation ZHBBottonsValueModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"bottons": @"bottons",
             @"name": @"name"
             };
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"bottons" : [ZHBBottonsModel class],
             };
}

// 重写get方法,如果该bottons中的所有id都无货,返回无货
- (BOOL)isNoStock
{
    BOOL isAllNoStock = YES;

    for (ZHBBottonsModel *bottonItem in self.bottons) {
        if ([bottonItem.isStock integerValue] > 0) {
            isAllNoStock = NO;
            break;
        }
    }

    if (isAllNoStock) {
        NSLog(@"全部无货%@",self.name);
    }
    return isAllNoStock ? YES : _isNoStock;
}
@end


#pragma mark - ZHBBottonsModel

@implementation ZHBBottonsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"bottonId": @"id",
             @"isStock": @"isStock"
             };
}

- (BOOL)isEqual:(id)object
{
    
    return [self yy_modelIsEqual:object];
}

- (NSUInteger)hash
{
    return [self yy_modelHash];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self yy_modelCopy];
}
@end
