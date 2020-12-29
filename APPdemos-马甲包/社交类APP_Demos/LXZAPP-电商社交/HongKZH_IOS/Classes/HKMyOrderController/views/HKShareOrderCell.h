//
//  HKShareOrderCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hk_MyOrderDataModel.h"
typedef void(^BarButtonClickBlock)(Hk_subOrderList *list,NSInteger index);

@interface HKShareOrderCell : UITableViewCell

@property (nonatomic, strong)Hk_subOrderList *list;

@property (nonatomic, copy) BarButtonClickBlock block;

@end
