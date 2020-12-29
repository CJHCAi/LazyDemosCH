//
//  HKProductsModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKProductsModel : NSObject
@property (nonatomic, copy)NSString *imgSrc;
@property(nonatomic, assign) int price;
@property (nonatomic, copy)NSString *productId;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)BOOL isShow;
@end
