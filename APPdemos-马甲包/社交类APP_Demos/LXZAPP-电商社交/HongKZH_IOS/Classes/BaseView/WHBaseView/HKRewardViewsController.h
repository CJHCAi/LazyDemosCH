//
//  HKRewardViewsController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"

@interface HKRewardViewsController : HKBaseViewController
+(void)showReward:(UIViewController*)subVc andType:(int)type andId:(NSString*)ID;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *cityAdvId;
@end
