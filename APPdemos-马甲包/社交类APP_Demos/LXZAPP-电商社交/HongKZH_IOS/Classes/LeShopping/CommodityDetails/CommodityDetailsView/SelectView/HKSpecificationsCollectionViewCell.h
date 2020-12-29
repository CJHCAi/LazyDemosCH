//
//  HKSpecificationsCollectionViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommodityDetailsRespone.h"
@interface HKSpecificationsCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)CommodityDetailsesColors *colorsM;
@property (nonatomic, strong)CommodityDetailsesSpecs *specs;

@property(nonatomic, assign) BOOL isSelect;
@end
