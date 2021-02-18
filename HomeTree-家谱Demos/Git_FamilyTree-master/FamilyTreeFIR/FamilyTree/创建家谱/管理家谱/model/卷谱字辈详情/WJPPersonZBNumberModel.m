//
//  WJPPersonZBNumberModel.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WJPPersonZBNumberModel.h"
static WJPPersonZBNumberModel *JPPersonModel = nil;
@implementation WJPPersonZBNumberModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"datalist" : [WJPZBDatalist class]};
}

+(instancetype)sharedWJPPersonZBNumberModel{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JPPersonModel = [[WJPPersonZBNumberModel alloc] init];
        
    });
    return JPPersonModel;
}

@end
@implementation WJPZBDatalist

@end


