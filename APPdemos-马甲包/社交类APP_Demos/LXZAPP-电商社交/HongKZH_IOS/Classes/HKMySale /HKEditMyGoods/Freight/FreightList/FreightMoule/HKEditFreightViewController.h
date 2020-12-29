//
//  HKEditFreightViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKFreightListRespone.h"
@protocol HKEditFreightViewControllerDelegate <NSObject>

@optional
-(void)upLoadNewdata;

@end
@interface HKEditFreightViewController : HKBaseViewController
@property (nonatomic, strong)HKFreightListData *model;
@end
