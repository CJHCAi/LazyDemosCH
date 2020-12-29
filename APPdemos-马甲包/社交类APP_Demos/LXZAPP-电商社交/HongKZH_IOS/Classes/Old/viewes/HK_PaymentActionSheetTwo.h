//
//  HK_PaymentActionSheetTwo.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_SaveOrderBaseModel.h"
@protocol HK_PaymentActionSheetTwoDelegate <NSObject>

@optional
-(void)rechargeCallback;

@end
@interface HK_PaymentActionSheetTwo : UIView
@property (nonatomic,strong) IBOutlet UIView *view_holder;

@property (nonatomic,strong) IBOutlet UIButton *btnPay;
@property (nonatomic,strong) IBOutlet UIButton *btnAllPrice;
@property (nonatomic,strong) IBOutlet UIButton *btnAllPriceBottom;
@property (nonatomic, strong)HK_SaveOrderBaseModel *baseM;
@property (nonatomic,strong) IBOutlet UILabel *lbName;
@property (nonatomic,strong) IBOutlet UIImageView *avatar;
@property (nonatomic,weak) id<HK_PaymentActionSheetTwoDelegate> delegate;

+ (id)showInView:(UIView *)view;
//充值界面 配置数据
-(void)configueCellWithTotalCount:(NSInteger)integal;

@end
