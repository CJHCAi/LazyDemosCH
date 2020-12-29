//
//  HKShareFriendViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
@class HKShareBaseModel;
@protocol HKShareFriendViewControllerDelegate <NSObject>

@optional
-(void)backVc;

@end
@interface HKShareFriendViewController : HKBaseViewController
@property (nonatomic, strong)HKShareBaseModel *sharModel;
@property (nonatomic,weak) id<HKShareFriendViewControllerDelegate> delegate;
@end
