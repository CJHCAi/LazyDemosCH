//
//  HKBurstingActivityInfoViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
@protocol HKBurstingActivityInfoViewControllerDelegate <NSObject>

@optional
-(void)burstEnd;
@end
@interface HKBurstingActivityInfoViewController : HKBaseViewController
@property (nonatomic, copy)NSString *orderNumber;
@property (nonatomic,weak) id<HKBurstingActivityInfoViewControllerDelegate> delegate;
@end
