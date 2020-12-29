//
//  HKSelfToolInfoViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "GetMediaAdvAdvByIdRespone.h"
#import "HKCityTravelsRespone.h"
@interface HKSelfToolInfoViewController : HKBaseViewController
@property (nonatomic, strong)GetMediaAdvAdvByIdRespone *responde ;
@property (nonatomic, strong)HKCityTravelsRespone *cityResponse;
@end
