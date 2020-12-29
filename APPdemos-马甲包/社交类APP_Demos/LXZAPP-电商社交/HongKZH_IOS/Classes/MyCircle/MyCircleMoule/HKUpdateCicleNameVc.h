//
//  HKUpdateCicleNameVc.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"

typedef void(^UpdateNameBlock)(NSString *name);

@interface HKUpdateCicleNameVc : HKBaseViewController

@property (nonatomic, assign)BOOL updateName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) UpdateNameBlock block;

@end
