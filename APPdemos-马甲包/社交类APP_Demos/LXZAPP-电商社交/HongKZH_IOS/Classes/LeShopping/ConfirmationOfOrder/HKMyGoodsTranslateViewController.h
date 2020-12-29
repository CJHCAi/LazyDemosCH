//
//  HKMyGoodsTranslateViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "getCartList.h"
@protocol HKMyGoodsTranslateViewControllerDelegate <NSObject>

@optional
-(void)selected:(NSString*)couponId getCartListDataProducts:(getCartListDataProducts*)product;
@end
@interface HKMyGoodsTranslateViewController : HKBaseViewController
@property (nonatomic, strong)getCartListDataProducts *productId;
@property (nonatomic,weak) id<HKMyGoodsTranslateViewControllerDelegate> delegate;
+(void)showMyGoodsTranslateViewControllerWithSuperVc:(HKBaseViewController*)superVc productId:(getCartListDataProducts*)productId;
@end
