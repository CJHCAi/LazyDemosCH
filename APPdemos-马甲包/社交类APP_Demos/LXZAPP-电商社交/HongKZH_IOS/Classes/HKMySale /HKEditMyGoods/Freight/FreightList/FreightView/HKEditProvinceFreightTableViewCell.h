//
//  HKEditProvinceFreightTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HKFreightListRespone.h"
@protocol HKEditProvinceFreightTableViewCellDelegate <NSObject>

@optional
-(void)delegateSublist:(HKFreightListSublist*)model;
-(void)selectProWithModel:(HKFreightListSublist*)model;
@end
@interface HKEditProvinceFreightTableViewCell : BaseTableViewCell
@property (nonatomic, strong)HKFreightListSublist *model;
@property (nonatomic,weak) id<HKEditProvinceFreightTableViewCellDelegate> delegate;
@end
