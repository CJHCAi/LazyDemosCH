//
//  HKEnterpriseHotAdvTypeListTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@class EnterpriseHotAdvTypeListRedpone;
@protocol HKEnterpriseHotAdvTypeListTableViewCellDelegate <NSObject>

@optional
-(void)updatetypeWithTag:(NSInteger)tag;

@end
@interface HKEnterpriseHotAdvTypeListTableViewCell : BaseTableViewCell
@property (nonatomic, strong)EnterpriseHotAdvTypeListRedpone *respone;
@property (nonatomic,weak) id<HKEnterpriseHotAdvTypeListTableViewCellDelegate> delegate;

@property(nonatomic, assign) NSInteger index;
@end
