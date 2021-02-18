//
//  LineageModel.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "LineageModel.h"

@implementation LineageModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"datalist" : [LineageDatalistModel class],
             @"levelinfo" : [LineageLevelInfoModel class],
             };
}

@end
@implementation LineageDatalistModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"layers":@"layer"
             };
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.username = @"姚珉";
        self.sex = @"男";
        self.relation = @"关系";
    }
    return self;
}

@end


@implementation LineageLevelInfoModel

@end


