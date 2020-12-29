//
//  HKBurstingActivityListViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKLuckyBurstRespone.h"
@protocol HKBurstingActivityListViewControllerDelegate <NSObject>

@optional
-(void)updateStaue:(NSInteger)staueDate index:(NSInteger)index;
@end
@interface HKBurstingActivityListViewController : HKBaseViewController
@property (nonatomic, strong)LuckyBurstTypes *model;

@property(nonatomic, assign) NSInteger indexVc;
@property (nonatomic,weak) id<HKBurstingActivityListViewControllerDelegate> delegate;
@end
