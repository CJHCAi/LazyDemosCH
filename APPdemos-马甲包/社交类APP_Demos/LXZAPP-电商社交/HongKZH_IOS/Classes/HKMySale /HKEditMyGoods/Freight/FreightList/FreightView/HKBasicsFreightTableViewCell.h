//
//  HKBasicsFreightTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HKFreightListRespone.h"
@protocol HKBasicsFreightTableViewCellDelegate <NSObject>

@optional
-(void)selectProWithModelListData:(HKFreightListData *)model;

@end
@interface HKBasicsFreightTableViewCell : BaseTableViewCell
@property (nonatomic, strong)HKFreightListData *model;
@property (nonatomic,weak) id<HKBasicsFreightTableViewCellDelegate> delegate;
@end
