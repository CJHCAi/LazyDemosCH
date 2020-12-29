//
//  HKLuckyBurstListTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@class HKLuckyBurstListRespone,HKluckyBurstDetailRespone;
@protocol HKLuckyBurstListTableViewCellDelegate <NSObject>

@optional
-(void)toInfoVc;
-(void)burstEnd;
@end
@interface HKLuckyBurstListTableViewCell : BaseTableViewCell
@property (nonatomic, strong)HKLuckyBurstListRespone *respone;
@property (nonatomic,weak) id<HKLuckyBurstListTableViewCellDelegate> delegate;
@property (nonatomic, strong)HKluckyBurstDetailRespone *model;
@end
