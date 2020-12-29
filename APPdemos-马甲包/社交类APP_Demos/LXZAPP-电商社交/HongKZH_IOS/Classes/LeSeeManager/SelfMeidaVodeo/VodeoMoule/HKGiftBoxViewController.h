//
//  HKGiftBoxViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"

@interface HKGiftBoxViewController : HKBaseViewController
+(void)showGiftBoxwithSuperVc:(HKBaseViewController*)superVc money:(NSInteger)money;
@property (nonatomic,assign) NSInteger monery;
@end
