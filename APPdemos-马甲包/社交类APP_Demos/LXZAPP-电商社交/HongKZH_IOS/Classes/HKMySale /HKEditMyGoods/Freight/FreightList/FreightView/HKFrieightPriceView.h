//
//  HKFrieightPriceView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKFreightListRespone.h"
@interface HKFrieightPriceView : UIView
@property (nonatomic, strong)HKFreightListData *model;
@property (nonatomic, strong)HKFreightListSublist *subListM;
@end
