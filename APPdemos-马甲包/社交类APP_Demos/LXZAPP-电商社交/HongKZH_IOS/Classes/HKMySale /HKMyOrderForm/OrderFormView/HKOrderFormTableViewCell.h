//
//  HKOrderFormTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKSellerorderListRespone.h"
@interface HKOrderFormTableViewCell : UITableViewCell
+(instancetype)orderFormTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)HKSellerorderModel *model;
@end
