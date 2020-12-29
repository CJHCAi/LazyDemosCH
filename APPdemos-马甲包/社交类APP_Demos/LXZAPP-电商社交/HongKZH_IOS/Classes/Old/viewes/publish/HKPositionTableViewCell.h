//
//  HKPositionTableViewCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_RecriutPosition.h"
/*企业招聘---职位 cell*/
#import "HK_RecruitPositionData.h"
@interface HKPositionTableViewCell : UITableViewCell
@property (nonatomic, strong) HK_RecruitPositionData *positionData;


-(void)confiueCellWithModel:(HK_positionData *)data;

@end
