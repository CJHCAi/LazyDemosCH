//
//  HKMyOrderFormStaueTabView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKMyOrderFormStaueTabViewDelegate <NSObject>

@optional
-(void)nextStepPay;
-(void)nextStepReviserice;
-(void)lastStepClose;
@end
@interface HKMyOrderFormStaueTabView : UIView
@property (nonatomic,weak) id<HKMyOrderFormStaueTabViewDelegate> delegate;
@property (nonatomic,assign) OrderFormStatue statue;
@end
