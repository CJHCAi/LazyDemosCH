//
//  HKRevisePriceViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRightSaveBaseViewController.h"
#import "HKOrderFromInfoRespone.h"
@class HKRevisePiceParameter;
@protocol HKRevisePriceViewControllerDelegate <NSObject>

@optional
-(void)sellerupdateorderpriceWithModel:(HKRevisePiceParameter*)model;
@end
@interface HKRevisePriceViewController : HKRightSaveBaseViewController
@property (nonatomic, strong)HKOrderInfoData *model;
@property (nonatomic,weak) id<HKRevisePriceViewControllerDelegate> delegate;
@end
