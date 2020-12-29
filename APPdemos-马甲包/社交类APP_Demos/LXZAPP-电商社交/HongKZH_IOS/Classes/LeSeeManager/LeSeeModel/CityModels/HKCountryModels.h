//
//  HKCountryModels.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKCountryModels : NSObject
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *parentId;
@property (nonatomic, copy)NSString *code;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end
