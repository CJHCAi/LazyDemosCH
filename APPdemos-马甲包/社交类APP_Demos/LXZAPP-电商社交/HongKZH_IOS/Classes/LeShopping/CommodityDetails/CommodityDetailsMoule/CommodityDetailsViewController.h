//
//  CommodityDetailsViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKSelectCommodityParametersViewController.h"
@class CommodityDetailsRespone;
@protocol CommodityDetailsViewControllerDelegate <NSObject>

@optional
-(void)vcScrollViewDidScroll:(CGFloat)y  isDown:(BOOL)isDown;

@end
@interface CommodityDetailsViewController : HKBaseViewController<HKSelectCommodityParametersViewControllerDelegate>
@property (nonatomic, copy)NSString *productId;
@property (nonatomic, copy)NSString *provinceId;
@property (nonatomic, strong)CommodityDetailsRespone *responde ;
@property (nonatomic,weak) id<CommodityDetailsViewControllerDelegate> delegate;
@end
