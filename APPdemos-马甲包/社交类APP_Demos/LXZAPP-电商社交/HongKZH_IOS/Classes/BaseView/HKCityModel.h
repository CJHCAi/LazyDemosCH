//
//  HKCityModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKCityModel : NSObject
@property (nonatomic, strong)NSMutableArray *areas;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, copy) NSString *code;
@end
