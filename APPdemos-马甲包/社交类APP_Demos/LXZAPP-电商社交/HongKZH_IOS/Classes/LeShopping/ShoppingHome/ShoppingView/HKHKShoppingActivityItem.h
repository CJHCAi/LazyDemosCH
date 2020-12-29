//
//  HKHKShoppingActivityItem.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLeShopHomeRespone.h"
#import "GetMediaAdvAdvByIdRespone.h"
@interface HKHKShoppingActivityItem : UICollectionViewCell
@property (nonatomic, strong)HKLeShopHomeLuckyvouchers *model;
@property (nonatomic, strong)HKLeShopHomeToSelectedproducts *productsM;
@property (nonatomic, strong)GetMediaAdvAdvByIdProducts *videoProduct;
@end
