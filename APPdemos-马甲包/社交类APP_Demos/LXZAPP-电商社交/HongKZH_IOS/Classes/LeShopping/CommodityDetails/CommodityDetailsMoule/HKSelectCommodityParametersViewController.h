//
//  HKSelectCommodityParametersViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
@class CommodityDetailsRespone;
@protocol HKSelectCommodityParametersViewControllerDelegate <NSObject>

@optional
-(void)gotoCat:(NSArray*)cartArray;
-(void)gotoToolClick:(NSInteger)tag;
@end
@interface HKSelectCommodityParametersViewController : HKBaseViewController
@property (nonatomic, strong)CommodityDetailsRespone *respone;
+(void)showVc:(UIViewController*)subvc respone:(CommodityDetailsRespone *)respone;
@property (nonatomic,weak) id<HKSelectCommodityParametersViewControllerDelegate> delegate;
@end
