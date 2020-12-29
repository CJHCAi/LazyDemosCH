//
//  HKSendRedEnvelopesTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HKMoneyModel.h"
@protocol HKSendRedEnvelopesTableViewCellDelagate <NSObject>

@optional
-(void)subComplains:(HKMoneyModel*)model;

@end
@interface HKSendRedEnvelopesTableViewCell : BaseTableViewCell
@property (nonatomic,weak) id<HKSendRedEnvelopesTableViewCellDelagate> delegate;
@end
