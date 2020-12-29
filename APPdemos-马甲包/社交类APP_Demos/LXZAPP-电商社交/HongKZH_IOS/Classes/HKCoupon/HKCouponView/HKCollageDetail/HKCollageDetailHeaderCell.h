//
//  HKCollageDetailHeaderCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCollageOrderResponse.h"
typedef void(^shareBlock)(void);

@interface HKCollageDetailHeaderCell : UITableViewCell

@property (nonatomic, copy) shareBlock block;
@property (nonatomic, strong)HKCollageOrderResponse *response;

@end
