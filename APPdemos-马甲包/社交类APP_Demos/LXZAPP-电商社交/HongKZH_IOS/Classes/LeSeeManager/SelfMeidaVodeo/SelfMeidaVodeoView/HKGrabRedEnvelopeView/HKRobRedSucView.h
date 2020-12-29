//
//  HKRobRedSucView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKRobRedSucViewDelegate <NSObject>

@optional
-(void)shareToVc;
@end
@interface HKRobRedSucView : UIView
@property (nonatomic,weak) id<HKRobRedSucViewDelegate> delegate;

@property (nonatomic,assign) NSInteger num;
@end
