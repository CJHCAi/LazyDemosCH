//
//  HKMyOrderFormStaueTabView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyOrderFormStaueTabView.h"
#import "UIView+BorderLine.h"
@interface HKMyOrderFormStaueTabView()
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;

@end

@implementation HKMyOrderFormStaueTabView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKMyOrderFormStaueTabView" owner:self options:nil].lastObject;
        [self.nextBtn borderForColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] borderWidth:1 borderType:UIBorderSideTypeAll];
        [self.nextBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.lastBtn borderForColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] borderWidth:1 borderType:UIBorderSideTypeAll];
        [self.lastBtn addTarget:self action:@selector(lastClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)lastClick:(UIButton*)sender{
    switch ((OrderFormStatue)sender.tag) {
        case OrderFormStatue_waitPay:{
            //关闭交易
            if([self.delegate respondsToSelector:@selector(lastStepClose)]){
                [self.delegate lastStepClose];
            }
        }
            break;
            
        default:
            break;
    }
}
-(void)nextClick:(UIButton*)sender{
    switch ((OrderFormStatue)sender.tag) {
        case OrderFormStatue_payed:{
            //付款
            if ([self.delegate respondsToSelector:@selector(nextStepPay)]) {
                [self.delegate nextStepPay];
            }
        }
            break;
        case OrderFormStatue_waitPay:{
          //修改价格
            if([self.delegate respondsToSelector:@selector(nextStepReviserice)]){
                [self.delegate nextStepReviserice];
            }
        }
            break;
            
        default:
            break;
    }
   
}
-(void)awakeFromNib{
    [super awakeFromNib];
}
-(void)setStatue:(OrderFormStatue)statue{
    _statue = statue;
    switch (statue) {
        case OrderFormStatue_payed:{
            self.lastBtn.hidden = YES;
            [self.nextBtn setTitle:@"发货" forState:0];
            self.nextBtn.tag = OrderFormStatue_payed;
        }
            break;
        case OrderFormStatue_waitPay:{
            self.lastBtn.hidden = NO;
            [self.lastBtn setTitle:@"关闭订单" forState:0];
            [self.nextBtn setTitle:@"修改价格" forState:0];
            self.lastBtn.tag = OrderFormStatue_waitPay;
            self.nextBtn.tag = OrderFormStatue_waitPay;
        }
            break;
        default:
            break;
    }
}
@end
