//
//  HKFreightViewListController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKFreightListRespone.h"
@protocol HKFreightViewListControllerDelegate <NSObject>

@optional
-(void)selectFreightModel:(HKFreightListData*)model;

@end
@interface HKFreightViewListController : HKBaseViewController
@property (nonatomic,assign) NSInteger selectRow;
@property (nonatomic,weak) id<HKFreightViewListControllerDelegate> delegate;
@end
