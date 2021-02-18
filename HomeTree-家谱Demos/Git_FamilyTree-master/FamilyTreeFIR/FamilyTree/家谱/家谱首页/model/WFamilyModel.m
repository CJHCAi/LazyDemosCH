//
//  WFamilyModel.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WFamilyModel.h"
static WFamilyModel *familModel = nil;
@implementation WFamilyModel



+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"datalist" : [WFDatalist class]};
}


+(instancetype)shareWFamilModel{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        familModel = [[WFamilyModel alloc] init];
        familModel.myFamilyId = @"";
    });
    return familModel;
}
@end

@implementation WFDatalist

@end


