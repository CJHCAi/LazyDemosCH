//
//  HKDetailshopTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@class CommodityDetailsRespone;
@protocol HKDetailshopTableViewCellDelegate <NSObject>

@optional
-(void)gotoDetailsWithID:(NSString*)productId;
-(void)gotoShopsWithShopId:(NSString *)shopId;
@end
@interface HKDetailshopTableViewCell : BaseTableViewCell
@property (nonatomic, strong)CommodityDetailsRespone *respone;
@property (nonatomic,weak) id<HKDetailshopTableViewCellDelegate> delegate;
@end
