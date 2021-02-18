//
//  WBookingModel.m
//  FamilyTree
//
//  Created by 王子豪 on 16/8/4.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WBookingModel.h"

@implementation WBookingModel



+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"datalist" : [WbDatalist class]};
}
@end




@implementation WbPage

@end


@implementation WbDatalist

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"detail" : [WbDetail class]};
}

@end


@implementation WbOrder

@end


@implementation WbDetail

@end


