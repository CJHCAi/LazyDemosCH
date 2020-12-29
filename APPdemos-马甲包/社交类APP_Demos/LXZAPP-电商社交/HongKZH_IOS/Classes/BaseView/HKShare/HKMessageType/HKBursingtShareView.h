//
//  HKBursingtShareView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKBursingtShareViewDelegate <NSObject>

@optional
-(void)gotoBurstingActivity;

@end
@class HKBurstingActivityShareModel;
@interface HKBursingtShareView : UIView
@property (nonatomic, strong)HKBurstingActivityShareModel *model;
@property (nonatomic,weak) id<HKBursingtShareViewDelegate> delegate;
@end
