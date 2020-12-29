//
//  HKCloseOrderViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
@protocol HKCloseOrderViewControllerDelegate <NSObject>


@optional
-(void)closeWithStr:(NSString*)str;
@end

@interface HKCloseOrderViewController : HK_BaseView
@property (nonatomic,weak) id<HKCloseOrderViewControllerDelegate> delegate;
@end
