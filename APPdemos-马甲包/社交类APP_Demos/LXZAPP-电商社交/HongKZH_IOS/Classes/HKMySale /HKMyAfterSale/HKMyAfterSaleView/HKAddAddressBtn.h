//
//  HKAddAddressBtn.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKAddAddressBtnDelegate <NSObject>

@optional
-(void)gotoAddAddress;
@end
@interface HKAddAddressBtn : UIView
@property (nonatomic,weak) id<HKAddAddressBtnDelegate> delegate;
@end
