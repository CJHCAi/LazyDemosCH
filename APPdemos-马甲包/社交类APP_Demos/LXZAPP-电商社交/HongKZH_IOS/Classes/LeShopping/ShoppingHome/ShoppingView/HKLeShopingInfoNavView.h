//
//  HKLeShopingInfoNavView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKLeShopingInfoNavViewDelegate <NSObject>

@optional
-(void)gotoVc:(NSInteger)tag;
@end
@interface HKLeShopingInfoNavView : UIView
@property (nonatomic,weak) id<HKLeShopingInfoNavViewDelegate> delegate;
@property(nonatomic, assign) BOOL isHideCart;
@end
