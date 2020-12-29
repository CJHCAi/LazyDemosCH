//
//  HKReseaInfoCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@class RecruitInfoRespone;
@protocol HKReseaInfoCellDelegate <NSObject>

@optional
-(void)gotoCompanyInfo;
@end
@interface HKReseaInfoCell : BaseTableViewCell
@property (nonatomic, strong)RecruitInfoRespone *respone;
@property (nonatomic,weak) id<HKReseaInfoCellDelegate> delegate;
@end
