//
//  HKMyGoodsOrderView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyGoodsViewModel.h"
@protocol HKMyGoodsOrderViewDelegate <NSObject>

@optional
-(void)goodsOrderType:(MYUpperProductOrder)orderType;
@end
@interface HKMyGoodsOrderView : UIView
@property(nonatomic, assign) MYUpperProductOrder orderType;
@property(nonatomic, assign) BOOL isSelect;
@property (nonatomic,weak) id<HKMyGoodsOrderViewDelegate> delegate;
@end
