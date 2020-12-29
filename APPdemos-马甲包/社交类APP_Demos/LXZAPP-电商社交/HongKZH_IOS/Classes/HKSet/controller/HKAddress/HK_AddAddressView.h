//
//  HK_AddAddressView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
@protocol HK_AddAddressViewDelegate <NSObject>

@optional
-(void)refreshLastVc;
@end
@interface HK_AddAddressView : HK_BaseView
@property(nonatomic, assign) BOOL isRefund;
@property (nonatomic,weak) id<HK_AddAddressViewDelegate> delegate;
@end
