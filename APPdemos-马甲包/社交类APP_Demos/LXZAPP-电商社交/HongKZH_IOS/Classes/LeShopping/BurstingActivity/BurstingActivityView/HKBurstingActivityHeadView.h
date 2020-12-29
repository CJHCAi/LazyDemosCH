//
//  HKBurstingActivityHeadView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKLuckyBurstRespone;
@protocol HKBurstingActivityHeadViewDelegate  <NSObject>

@optional
-(void)switchVc:(NSInteger)tag;
@end
@interface HKBurstingActivityHeadView : UIView
@property (nonatomic, strong)HKLuckyBurstRespone *respone;
@property (nonatomic,weak) id<HKBurstingActivityHeadViewDelegate> delegate;
@end
