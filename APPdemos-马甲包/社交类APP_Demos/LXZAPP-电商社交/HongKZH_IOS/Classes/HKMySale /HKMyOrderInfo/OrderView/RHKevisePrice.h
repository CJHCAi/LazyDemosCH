//
//  RHKevisePrice.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKOrderFromInfoRespone.h"
@class HKRevisePiceParameter;
@interface RHKevisePrice : UIView
@property (nonatomic, strong)HKOrderInfoData *model;
@property (nonatomic, strong)HKRevisePiceParameter *parameter;
@end
