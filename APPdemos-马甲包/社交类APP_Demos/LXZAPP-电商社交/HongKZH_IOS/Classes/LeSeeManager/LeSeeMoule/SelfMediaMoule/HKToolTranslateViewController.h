//
//  HKToolTranslateViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKCityTravelsRespone.h"
@class GetMediaAdvAdvByIdRespone;
@interface HKToolTranslateViewController : HKBaseViewController
@property (nonatomic, strong)GetMediaAdvAdvByIdRespone *responde ;
@property (nonatomic, strong)HKCityTravelsRespone *cityResponse;
@end
