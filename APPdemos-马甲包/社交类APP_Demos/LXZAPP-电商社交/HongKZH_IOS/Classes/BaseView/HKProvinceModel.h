//
//  HKProvinceModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKCityModel;
@interface HKProvinceModel : NSObject
@property (nonatomic, strong)NSMutableArray<HKCityModel*> *citys;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;
@end
