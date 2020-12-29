//
//  RecommendBannersModel.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/21.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "RecommendBannersModel.h"

@implementation RecommendBannersModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"recommendBannersIdentifier":@"id"}];
}
@end
