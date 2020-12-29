//
//  ConfirmationOfOrderFootVIew.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ConfirmationOfOrderFootVIewDelegate <NSObject>

@optional
-(void)translateGoods;
-(void)selectCoin:(BOOL)isCoin;
@end
@interface ConfirmationOfOrderFootVIew : UIView
@property (nonatomic,assign) NSInteger couponCount;
@property(nonatomic, assign) double integral;;
@property (nonatomic,weak) id<ConfirmationOfOrderFootVIewDelegate> delegate;
-(void)setDeductible:(NSInteger)userIntegral countOffsetCoin:(NSInteger)countOffsetCoin;
@property (nonatomic,assign) BOOL isSelected;
@end
