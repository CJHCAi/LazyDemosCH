//
//  HKPushTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKPushModel;
@interface HKPushTableViewCell : UITableViewCell
@property (nonatomic, strong)HKPushModel *model;
+(instancetype)pushTableViewCellWithTableView:(UITableView*)tableView;
@end
