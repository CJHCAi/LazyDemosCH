//
//  HKPlaceOrder.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKPlaceOrderDelegate <NSObject>

@optional
-(void)placeOrder;
@end
@interface HKPlaceOrder : UIView
@property (nonatomic,weak) id<HKPlaceOrderDelegate> delegate;
@property(nonatomic, assign) double numAll;
@end
