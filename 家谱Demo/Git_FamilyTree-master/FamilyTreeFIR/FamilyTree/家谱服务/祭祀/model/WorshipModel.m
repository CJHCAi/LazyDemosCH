//
//  WorshipModel.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WorshipModel.h"

@implementation WorshipModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"datalist":[WorshipDatalistModel class]};
}


@end
@implementation WorshipPageModel

@end


@implementation WorshipDatalistModel
-(instancetype)init{
    self = [super init];
    if (self) {
         _worshipDatalistModelEdit = NO;
    }
    return self;
}
@end


