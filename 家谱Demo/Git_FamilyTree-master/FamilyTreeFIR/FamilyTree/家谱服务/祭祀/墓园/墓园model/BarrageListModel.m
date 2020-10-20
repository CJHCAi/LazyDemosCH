//
//  BarrageListModel.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "BarrageListModel.h"

@implementation BarrageListModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"dm":[BarrageListDmModel class]};
}
@end
@implementation BarrageListDmModel

@end


