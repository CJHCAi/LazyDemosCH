//
//  CliffordTributeModel.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CliffordTributeModel.h"
static CliffordTributeModel *model = nil;
@implementation CliffordTributeModel
+(instancetype)shareClifordArr{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model =[[CliffordTributeModel alloc] init];
    });
    return model;
}
@end
