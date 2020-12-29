//
//  HKRobRedFailView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKRobRedFailViewDelegate <NSObject>

@optional
-(void)shareToVc;

@end
@interface HKRobRedFailView : UIView
@property (nonatomic,weak) id<HKRobRedFailViewDelegate> delegate;
@end
