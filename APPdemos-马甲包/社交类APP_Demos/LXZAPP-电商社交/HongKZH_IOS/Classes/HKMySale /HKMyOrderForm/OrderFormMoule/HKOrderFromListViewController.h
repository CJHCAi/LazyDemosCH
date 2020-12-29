//
//  HKOrderFromListViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
typedef enum{
    OrderFormType_Ing = 0,
    OrderFormType_Finish = 1,
    OrderFormType_Close = 2
}OrderFormType;
@interface HKOrderFromListViewController : HKBaseViewController
@property(nonatomic, assign) OrderFormType orderType;
@end
