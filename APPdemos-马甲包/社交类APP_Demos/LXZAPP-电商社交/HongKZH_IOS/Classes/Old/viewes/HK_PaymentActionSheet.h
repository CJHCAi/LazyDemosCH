//
//  HK_PaymentActionSheet.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HK_PaymentActionSheetDelegate <NSObject>

-(void)paymentCallback;

@end
@interface HK_PaymentActionSheet : UIView
@property (nonatomic,strong) IBOutlet UIView *view_holder;

@property (nonatomic,strong) IBOutlet UIButton *btnPay;
@property (nonatomic,strong) IBOutlet UIButton *btnAllPrice;
@property (nonatomic,strong) IBOutlet UIButton *btnAllPriceBottom;

@property (nonatomic,strong) IBOutlet UILabel *lbName;
@property (nonatomic,strong) IBOutlet UIImageView *avatar;

@property (nonatomic,weak) id<HK_PaymentActionSheetDelegate> delegate;

+ (id)showInView:(UIView *)view;
//订单详情页面 支付页面配置
-(void)configueCellWithTotalCount:(NSInteger)integal;

@end
