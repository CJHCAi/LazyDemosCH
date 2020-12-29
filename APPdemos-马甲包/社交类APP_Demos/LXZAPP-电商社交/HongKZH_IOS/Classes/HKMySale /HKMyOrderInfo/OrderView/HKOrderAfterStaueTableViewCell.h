//
//  HKOrderAfterStaueTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKOrderFromInfoRespone;
@interface HKOrderAfterStaueTableViewCell : UITableViewCell
@property (nonatomic, strong)HKOrderFromInfoRespone *orderInfoModel;
+(instancetype)orderAfterStaueTableViewCellWithTableView:(UITableView*)tableView;
@end
