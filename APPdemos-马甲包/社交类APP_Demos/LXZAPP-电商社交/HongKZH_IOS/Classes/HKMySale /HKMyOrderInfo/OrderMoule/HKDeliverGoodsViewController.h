//
//  HKDeliverGoodsViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKOrderFromInfoRespone.h"
@protocol HKDeliverGoodsViewControllerDelegate <NSObject>

@optional
-(void)noticeVcRefreshWithType:(OrderFormStatue)statue model:(NSObject*)model;

@end
@interface HKDeliverGoodsViewController : HKBaseViewController
@property (nonatomic, strong)HKOrderInfoData *model;
@property (nonatomic,weak) id<HKDeliverGoodsViewControllerDelegate> delegate;
@end
