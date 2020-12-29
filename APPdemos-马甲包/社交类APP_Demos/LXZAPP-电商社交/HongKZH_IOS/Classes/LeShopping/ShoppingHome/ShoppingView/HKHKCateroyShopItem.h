//
//  HKHKCateroyShopItem.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLeShopHomeRespone.h"
@interface HKHKCateroyShopItem : UICollectionViewCell
@property (nonatomic, strong)HKLeShopHomeHotsshopes *model;
@property (nonatomic,assign) BOOL isSelect;
@end
