//
//  HKChinaModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKProvinceModel;
@interface HKChinaModel : NSObject
@property (nonatomic, strong)NSMutableArray<HKProvinceModel*> *provinces;
@end
