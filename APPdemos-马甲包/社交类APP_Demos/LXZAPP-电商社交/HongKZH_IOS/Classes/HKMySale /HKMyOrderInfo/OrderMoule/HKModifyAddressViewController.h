//
//  HKModifyAddressViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRightSaveBaseViewController.h"
#import "HKOrderFromInfoRespone.h"
@protocol HKModifyAddressViewControllerDelegate <NSObject>

@optional
-(void)save:(HKOrderInfoData*)model indebpath:(NSIndexPath*)indexpath;
@end
@interface HKModifyAddressViewController : HKRightSaveBaseViewController
@property (nonatomic, strong)HKOrderInfoData *model;
@property (nonatomic,assign) BOOL isRefund;
@property (nonatomic,weak) id<HKModifyAddressViewControllerDelegate> delegate;
@property (nonatomic,weak) NSIndexPath *indexpath;
@end
