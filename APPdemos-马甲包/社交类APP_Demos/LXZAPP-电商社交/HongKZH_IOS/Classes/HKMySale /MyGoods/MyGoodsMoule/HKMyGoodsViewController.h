//
//  HKMyGoodsViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseSearchViewController.h"
typedef void(^BackRefresh)(BOOL isRefresh);
@interface HKMyGoodsViewController : HKBaseSearchViewController
@property (nonatomic, copy)BackRefresh bakcRefresh;
@end
