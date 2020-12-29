//
//  HKFreightListTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HKFreightListRespone.h"
@protocol HKFreightListTableViewCellDelegate <NSObject>

@optional
-(void)gotoEditWithModel:(HKFreightListData*)model;

@end
@interface HKFreightListTableViewCell : BaseTableViewCell
@property (nonatomic, strong)HKFreightListData *model;
@property(nonatomic, assign) BOOL isSelect;
@property (nonatomic,weak) id<HKFreightListTableViewCellDelegate> delegate;
@end
