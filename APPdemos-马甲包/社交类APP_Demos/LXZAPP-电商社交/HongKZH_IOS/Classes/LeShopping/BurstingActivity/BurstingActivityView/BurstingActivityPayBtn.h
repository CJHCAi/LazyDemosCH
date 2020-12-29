//
//  BurstingActivityPayBtn.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BurstingActivityPayBtnDelegate <NSObject>

@optional
-(void)burstingActivityPay;

@end
@interface BurstingActivityPayBtn : UIView
@property (nonatomic, assign)NSInteger num;
@property (nonatomic,weak) id<BurstingActivityPayBtnDelegate> delegate;
@end
