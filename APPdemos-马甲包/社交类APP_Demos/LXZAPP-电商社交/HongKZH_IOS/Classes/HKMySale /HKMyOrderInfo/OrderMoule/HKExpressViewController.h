//
//  HKExpressViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "HKExpresListRespone.h"
@protocol HKExpressViewControllerDelegate <NSObject>

@optional
-(void)selectExpresModel:(HKExpresModel*)model;
@end
@interface HKExpressViewController : HK_BaseView
@property (nonatomic,weak) id<HKExpressViewControllerDelegate> delegate;
@property (nonatomic, strong)NSMutableArray *questionArray;
@end
