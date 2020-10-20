//
//  ExpertRecommendModel.m
//  FamilyTree
//
//  Created by 姚珉 on 16/8/9.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "ExpertRecommendModel.h"

@implementation ExpertRecommendModel
-(instancetype)init{
    self = [super init];
    if (self) {
        self.ExName = @"";
        self.ExCw = @"";
        self.ExDisease = @"";
        self.ExMemo = @"";
        self.ExDoctortime = @"";
    }
    return self;
}
@end
