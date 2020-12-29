//
//  HKUserProductCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HK_UserProductList.h"

@protocol HKCicleSelectProductDelegete <NSObject>

-(void)selectProductWithModel:(HKUserProduct *)model;

@end

typedef void(^UserProdcutCellBlock)(HKUserProduct *product, BOOL isShow);

@interface HKUserProductCell : UITableViewCell

@property (nonatomic, strong) HKUserProduct *userProduct;

@property (nonatomic, copy) UserProdcutCellBlock block;

@property (nonatomic, weak)id <HKCicleSelectProductDelegete>delegete;

@end
