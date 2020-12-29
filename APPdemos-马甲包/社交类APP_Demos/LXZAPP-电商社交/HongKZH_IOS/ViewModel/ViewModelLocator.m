//
//  ViewModelLocator.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "ViewModelLocator.h"
#import "GSSynthesizeSingleton.h"
#import "NSArray+SafeAccess.h"


@interface ViewModelLocator()
{
//    BOOL isAddrUpdate;
    BOOL isUserInForUpdate;
    BOOL isUserUpdate;
    BOOL isGroupUpdate;
//    AliPay_TYPE typealipay;
}

@end
@implementation ViewModelLocator
GSSynthesizeSingleton(View,ModelLocator);

-(NSMutableArray *)enterpriseDetailsArray
{
    if (!_enterpriseDetailsArray) {
        _enterpriseDetailsArray = [[NSMutableArray alloc] init];
    }
    return _enterpriseDetailsArray;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        isUserInForUpdate =YES;
        isGroupUpdate = YES;
        isUserUpdate = YES;
    }
    return self;
}











@end
