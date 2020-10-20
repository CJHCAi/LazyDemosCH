//
//  WGennerationModel.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/29.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WGennerationModel.h"

@implementation WGennerationModel


+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"datalist" : [WGeDatalist class]};
}

@end


@implementation Page

@end


@implementation WGeDatalist

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"datas" : [WGeDetailDatas class],
             
             };
}

@end


@implementation WGeDetailDatas

@end


