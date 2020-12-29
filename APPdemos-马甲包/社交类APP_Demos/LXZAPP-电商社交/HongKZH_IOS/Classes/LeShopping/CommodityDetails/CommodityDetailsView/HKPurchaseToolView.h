//
//  HKPurchaseToolView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKPurchaseToolViewDelegate <NSObject>
@optional
-(void)gotoSelectParameWithTag:(NSInteger)tag;
-(void)gotoToolClick:(NSInteger)tag;
@end
@interface HKPurchaseToolView : UIView
@property (nonatomic,weak) id<HKPurchaseToolViewDelegate> delegate;
@end
