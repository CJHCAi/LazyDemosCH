//
//  HKPersonAuthVc.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

@interface HKPersonAuthVc : HK_BaseView

// 1. 审核中 2.不通过 3.通过了.
@property (nonatomic, assign)int state;

@end
