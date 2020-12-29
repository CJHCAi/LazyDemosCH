//
//  HKDetailsNavView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKDetailsNavViewDelagate <NSObject>

@optional
-(void)backToVc;
-(void)toCart;
-(void)toMore;
@end
@interface HKDetailsNavView : UIView
@property (nonatomic,weak) id<HKDetailsNavViewDelagate> delegate;
@property(nonatomic, assign) BOOL isHideCart;
@end
