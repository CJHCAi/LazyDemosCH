//
//  WpersonInfoModel.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WpersonInfoModel.h"

@implementation WpersonInfoModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"genlist" : [WPersonGenlist class]};
}
@end
@implementation WPersonGenlist

@end


