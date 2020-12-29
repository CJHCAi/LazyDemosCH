//
//  HKMoneyModel.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKMoneyModel : NSObject
@property (nonatomic, copy)NSString *money;
@property (nonatomic, copy)NSString *number;
@property (nonatomic, copy)NSString *type;

@property (nonatomic,assign) NSInteger totalMoney;//最终的总金额

@end
