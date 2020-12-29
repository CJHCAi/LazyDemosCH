//
//  HKAddHeadVIew.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKAddHeadVIewDelegate <NSObject>

@optional
-(void)gotoAddress;
@end
@interface HKAddHeadVIew : UIView
@property (nonatomic,weak) id<HKAddHeadVIewDelegate> delegate;
@end
