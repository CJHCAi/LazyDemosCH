//
//  HKCityAdvParameter.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/22.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseParameter.h"

@interface HKCityAdvParameter : HKBaseParameter
@property (nonatomic, copy)NSString *urlString;
@property (nonatomic, copy)NSString *latitude;
@property (nonatomic, copy)NSString *longitude;

@property(nonatomic, assign) int type;
-(NSDictionary*)parameter;
@end
