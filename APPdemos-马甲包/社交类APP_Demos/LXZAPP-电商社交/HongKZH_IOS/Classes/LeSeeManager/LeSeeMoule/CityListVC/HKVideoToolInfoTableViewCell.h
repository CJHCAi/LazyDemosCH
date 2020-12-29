//
//  HKVideoToolInfoTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HKCityTravelsRespone.h"
@class GetMediaAdvAdvByIdRespone;
@interface HKVideoToolInfoTableViewCell : BaseTableViewCell
@property (nonatomic, strong)GetMediaAdvAdvByIdRespone *responde ;
@property (nonatomic, strong)HKCityTravelsRespone *cityResponse;
@end
