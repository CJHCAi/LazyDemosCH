//
//  HKLogisticsNameTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKOrderFromInfoRespone.h"
@interface HKLogisticsNameTableViewCell : UITableViewCell
+(instancetype)logisticsNameTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)HKOrderInfoData *model;
@end
