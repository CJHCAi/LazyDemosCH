//
//  HKOrderAddressTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKOrderFromInfoRespone.h"
@protocol HKOrderAddressTableViewCellDelegate <NSObject>

@optional
-(void)modifyTheAddress;
-(void)toVcLookLogistics;
@end
@interface HKOrderAddressTableViewCell : UITableViewCell
+(instancetype)orderAddressTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)HKOrderInfoData *model;
@property (nonatomic,weak) id<HKOrderAddressTableViewCellDelegate> delegate;
@end
