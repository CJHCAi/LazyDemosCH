//
//  HKLeSeeNavigation.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKLeSeeNavigationDelegate <NSObject>

@optional
-(void)selectedWithIndex:(int)index;
-(void)gotoNavigation;
-(void)gotoVcRelease;
-(void)gotoWatchingHistory;
@end
@interface HKLeSeeNavigation : UIView
@property (nonatomic, strong)NSMutableArray *category;
@property (nonatomic,weak) id<HKLeSeeNavigationDelegate> delegate;
@property (nonatomic,assign) NSInteger index;
@end
