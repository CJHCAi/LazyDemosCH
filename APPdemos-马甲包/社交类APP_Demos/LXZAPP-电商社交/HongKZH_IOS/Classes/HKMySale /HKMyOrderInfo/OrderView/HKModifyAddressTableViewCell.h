//
//  HKModifyAddressTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKOrderFromInfoRespone.h"
@protocol HKModifyAddressTableViewCellDelegate <NSObject>

@optional
-(void)showSelectCity;
@end
@interface HKModifyAddressTableViewCell : UITableViewCell
+(instancetype)modifyAddressTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)HKOrderInfoData *model;
@property (nonatomic,weak) id<HKModifyAddressTableViewCellDelegate> delegate;
@end
