//
//  WShopCommonModel.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/26.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WShopCommonModel.h"
static WShopCommonModel *shopCommonModel = nil;
@implementation WShopCommonModel
+(instancetype)shareWShopCommonModel{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shopCommonModel = [[WShopCommonModel alloc] init];
    
    });
    return shopCommonModel;
}
@end
