//
//  HKTypeAdvertising.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CorporateCategoryResponse;
@protocol HKTypeAdvertisingDelegate <NSObject>
@optional
-(void)clickCategory:(NSInteger)tag;

@end
@interface HKTypeAdvertising : UIView
@property (nonatomic, strong)CorporateCategoryResponse *respone;
@property(nonatomic, assign) NSInteger currentIndex;;
-(void)setOpenBtnWithIsOpen:(BOOL)isOpen;
@property (nonatomic,weak) id<HKTypeAdvertisingDelegate> delegate;
@end
