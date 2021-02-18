//
//  WIDModel.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WIDModel.h"
static WIDModel *widModel = nil;
@implementation WIDModel
+(instancetype)sharedWIDModel{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        widModel = [[WIDModel alloc] init];
        widModel.becomeFirstJP = false;
    });
    
    return widModel;
    
}


@end


