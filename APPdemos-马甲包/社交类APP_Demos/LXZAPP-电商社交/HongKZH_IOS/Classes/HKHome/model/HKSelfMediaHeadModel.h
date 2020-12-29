//
//  HKSelfMediaHeadModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryTop10ListRespone.h"
#import "HKSowingModel.h"

@interface HKSelfMediaHeadModel : NSObject
@property (nonatomic, strong)NSMutableArray<CategoryTop10ListModel*> *top;
@property (nonatomic, strong)NSMutableArray<HKSowingModel*> *carousels;
@end
