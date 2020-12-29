//
//  HKEditExpressTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKExpresListRespone.h"
@protocol HKEditExpressTableViewCellDelegate <NSObject>

@optional
-(void)toVcselectExpress;

@end
@interface HKEditExpressTableViewCell : UITableViewCell
+(instancetype)editExpressTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic,weak) id<HKEditExpressTableViewCellDelegate> delegate;
@property (nonatomic, strong)HKExpresModel *model;
@end
