//
//  WSelectMyFamModel.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WSelectMyFamModel.h"

static WSelectMyFamModel *famModel = nil;

@implementation WSelectMyFamModel

+(instancetype)sharedWselectMyFamModel{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        famModel = [[WSelectMyFamModel alloc] init];
        famModel.myFamArray = [@[] mutableCopy];
    });
    
  
    return famModel;
}
@end
