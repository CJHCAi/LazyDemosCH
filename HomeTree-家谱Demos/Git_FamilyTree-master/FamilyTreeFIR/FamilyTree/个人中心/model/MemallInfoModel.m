//
//  MemallInfoModel.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "MemallInfoModel.h"

@implementation MemallInfoModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"grxc" : [MemallInfoGrxcModel class],
             @"jzdt" : [MemallInfoJzdtModel class],
             @"hyjp" : [MemallInfoHyjpModel class]
             };
}


@end


@implementation MemallInfoGrysModel

@end


@implementation MemallInfoGrqwModel


@end

@implementation MemallInfoGrxcModel


@end


@implementation MemallInfoScbzModel

@end


@implementation MemallInfoJzdtModel

@end

@implementation MemallInfoHyjpModel

@end

@implementation DevoutModel



@end
