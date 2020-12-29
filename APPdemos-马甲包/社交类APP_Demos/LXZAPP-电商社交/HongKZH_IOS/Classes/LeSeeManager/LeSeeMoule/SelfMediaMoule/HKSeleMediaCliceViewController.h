//
//  HKSeleMediaCliceViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"

typedef void(^SendCicleNumberBlock)(NSInteger num);

@interface HKSeleMediaCliceViewController : HKBaseViewController
@property (nonatomic, copy)NSString *categoryId;
@property (nonatomic, copy) SendCicleNumberBlock block;
@end
