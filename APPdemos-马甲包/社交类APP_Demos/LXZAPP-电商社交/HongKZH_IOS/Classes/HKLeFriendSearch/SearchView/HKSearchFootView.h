//
//  HKSearchFootView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKSearchFootViewDelegate <NSObject>

@optional
-(void)footerClickWithType:(int)type;
@end
@interface HKSearchFootView : UIView

@property(nonatomic, assign) int type;

@property (nonatomic,weak) id<HKSearchFootViewDelegate> delegate;
@end
