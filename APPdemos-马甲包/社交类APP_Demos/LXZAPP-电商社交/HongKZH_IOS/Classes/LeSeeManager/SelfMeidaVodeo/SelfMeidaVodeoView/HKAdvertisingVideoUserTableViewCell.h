//
//  HKAdvertisingVideoUserTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@class EnterpriseAdvRespone;
@protocol HKAdvertisingVideoUserTableViewCellDelegate <NSObject>

@optional
-(void)clickWithTag:(NSInteger)tag;
@end
@interface HKAdvertisingVideoUserTableViewCell : BaseTableViewCell
@property (nonatomic,weak) id<HKAdvertisingVideoUserTableViewCellDelegate> delegate;
@property (nonatomic, strong)EnterpriseAdvRespone *respone;
@end
