//
//  HKCategoryClicleRespone.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKCategoryClicleModel;
@interface HKCategoryClicleRespone : NSObject
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, copy)NSString *code;
@property (nonatomic, strong)NSArray<HKCategoryClicleModel*> *data;
@property (nonatomic,assign) BOOL responeSuc;
@end
