//
//  HKCompanyProfileTableViewCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

/*企业招聘---企业信息 cell*/
#import "HK_RecruitEnterpriseInfoData.h"
@interface HKCompanyProfileTableViewCell : UITableViewCell
@property (nonatomic, strong) HK_RecruitEnterpriseInfoData *data;
@end
