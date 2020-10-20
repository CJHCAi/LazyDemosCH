//
//  WDetailJPInfoModel.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WDetailJPInfoModel.h"

static WDetailJPInfoModel *JPInfoModel = nil;

@implementation WDetailJPInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"datalist" : [WJPInfoDatalist class]};
}

+(instancetype)sharedWDetailJPInfoModel{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JPInfoModel = [[WDetailJPInfoModel alloc] init];
    });
    return JPInfoModel;
}

@end

@implementation WJPInfoDatalist

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"datas" : [WJPInfoDatas class]};
}

@end

@implementation WJPInfoDatas

@end


