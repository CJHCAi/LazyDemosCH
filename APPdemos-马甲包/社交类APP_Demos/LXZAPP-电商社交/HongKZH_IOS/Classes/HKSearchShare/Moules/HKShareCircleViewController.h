//
//  HKShareCircleViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
@class HKShareBaseModel;
@protocol HKShareCircleViewControllerDelegate <NSObject>

@optional
-(void)backVc;

@end
@interface HKShareCircleViewController : HKBaseViewController
@property (nonatomic, strong)HKShareBaseModel *sharModel;
@property (nonatomic,weak) id<HKShareCircleViewControllerDelegate> delegate;
@end
