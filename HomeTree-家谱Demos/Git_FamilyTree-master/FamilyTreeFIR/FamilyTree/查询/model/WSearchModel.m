//
//  WSearchModel.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WSearchModel.h"

static WSearchModel *searchModel = nil;

@implementation WSearchModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"genlist" : [WSearchGenlist class]};
}

+(instancetype)shardSearchModel{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        searchModel = [[WSearchModel alloc] init];
        
    });
    return searchModel;
}
@end
@implementation WPage

@end


@implementation WSearchGenlist

@end


