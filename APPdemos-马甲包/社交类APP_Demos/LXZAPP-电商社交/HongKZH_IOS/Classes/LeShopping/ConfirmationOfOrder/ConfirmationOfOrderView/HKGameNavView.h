//
//  HKGameNavView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKGameNavViewDelegate <NSObject>

@optional
-(void)backVc;

@end
@interface HKGameNavView : UIView
@property (nonatomic, copy)NSString *title;
@property (nonatomic,weak) id<HKGameNavViewDelegate> delegate;
@end
