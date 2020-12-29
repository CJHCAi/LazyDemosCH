//
//  HK_ChangeReleaseCategoryCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKInitializationRespone.h"
typedef void(^IconButtonClickBlock)(AllcategorysModel *category);

@interface HK_ChangeReleaseCategoryCell : UICollectionViewCell

@property (nonatomic, strong) AllcategorysModel *category;

@property (nonatomic, copy) IconButtonClickBlock iconClickBlock;

@end
