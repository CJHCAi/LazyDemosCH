//
//  HKCategoryClicleModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKCategoryClicleModel : NSObject
@property (nonatomic, copy)NSString * categoryId;
@property (nonatomic, copy)NSString * categoryName;
@property (nonatomic, strong)NSMutableArray *questionArray;
@end
