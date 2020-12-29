//
//  HKSetMoneyViewController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKMoneyModel.h"
typedef void(^MoneyConfigieBlock)(HKMoneyModel *model);

@interface HKSetMoneyViewController : HKBaseViewController
@property (nonatomic, copy) MoneyConfigieBlock block;
@property (nonatomic, strong)HKMoneyModel * model;
@end
