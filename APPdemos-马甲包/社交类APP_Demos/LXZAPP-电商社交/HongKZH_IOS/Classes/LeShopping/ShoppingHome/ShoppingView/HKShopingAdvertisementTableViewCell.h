//
//  HKShopingAdvertisementTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol NewUserVipDelegete <NSObject>

-(void)enterNewVipControllerWithIndex:(NSInteger)index;

@end

@interface HKShopingAdvertisementTableViewCell : BaseTableViewCell

@property (nonatomic, weak)id <NewUserVipDelegete>delegete;

@end
