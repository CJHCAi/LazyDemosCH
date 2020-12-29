//
//  HKTBurstingableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HKLeShopHomeRespone.h"
@protocol HKTBurstingableViewCellDelegate <NSObject>

@optional
-(void)gotoBurstingable:(HKLeShopHomeLuckyvouchers*)model;

@end
@interface HKTBurstingableViewCell : BaseTableViewCell
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic,weak) id<HKTBurstingableViewCellDelegate> delegate;
@end
