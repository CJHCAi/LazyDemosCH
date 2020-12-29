//
//  HKUserProductViewController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "HK_UserProductList.h"
@protocol SelectProductDelegete <NSObject>

-(void)selectProduct:(HKUserProduct *)model;

@end

typedef void(^ClickDisplayBlock)(void);
@interface HKUserProductViewController : HK_BaseView

@property (nonatomic, strong) NSMutableArray *selectItems;

@property (nonatomic, assign) NSInteger boothCount;

@property (nonatomic, copy) ClickDisplayBlock block;

@property (nonatomic, weak)id <SelectProductDelegete>delegete;

@property (nonatomic, assign)BOOL isCicle;

@end
