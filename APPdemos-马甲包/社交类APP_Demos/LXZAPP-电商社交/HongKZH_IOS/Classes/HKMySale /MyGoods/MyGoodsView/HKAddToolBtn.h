//
//  HKAddToolBtn.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKAddToolBtnDelegate <NSObject>

@optional
-(void)addClick;

@end
@interface HKAddToolBtn : UIView
@property (nonatomic,weak) id<HKAddToolBtnDelegate> delegate;
@end
