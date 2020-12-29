//
//  HKShopCounCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyCopunDetailResponse.h"
#import "HKCollageResPonse.h"
#import "HKUserVipResponse.h"
@interface HKShopCounCell : UITableViewCell

@property (nonatomic, strong)HKMyCopunDetailResponse *response;
@property (nonatomic, strong)HKCollageResPonse * collageRes;
@property (nonatomic, strong)HKUserVipResponse *vipResponse;
@end
