//
//  HKLogisticsInfoTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKLogisticsInfoModel;
@interface HKLogisticsInfoTableViewCell : UITableViewCell
+(instancetype)logisticsInfoTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)HKLogisticsInfoModel *model;
@end
