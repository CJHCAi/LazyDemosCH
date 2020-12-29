//
//  HKMySaleTableHeadViw.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMySaleTableHeadViw.h"
#import "HKMySaleRespone.h"
@interface HKMySaleTableHeadViw()
@property (weak, nonatomic) IBOutlet UILabel *payNum;
@property (weak, nonatomic) IBOutlet UILabel *visitorL;
@property (weak, nonatomic) IBOutlet UILabel *paymentOrder;
@property (weak, nonatomic) IBOutlet UILabel *completeCount;
@property (weak, nonatomic) IBOutlet UIButton *deliveryCount;
@property (weak, nonatomic) IBOutlet UIImageView *backIconView;
@property (weak, nonatomic) IBOutlet UIButton *refundsCount;

@end

@implementation HKMySaleTableHeadViw

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat h = kScreenWidth*165/375;
        self = [[NSBundle mainBundle]loadNibNamed:@"HKMySaleTableHeadViw" owner:self options:nil].lastObject;
        self.frame = CGRectMake(0, 0, kScreenWidth, h+kScreenWidth*0.25+10+60+10+34);
        CAGradientLayer*layer = [UIColor setGradualChangingColor:self.backIconView fromColor:@"4090F7" toColor:@"2EDAFF"];
        layer.frame = CGRectMake(0, 0, kScreenWidth, h);
        [self.backIconView.layer addSublayer:layer];
        
    }
    return self;
}
-(void)setModel:(HKMySaleModel *)model{
    _model = model;
    self.payNum.text = [NSString stringWithFormat:@"%@",model.integral.length>0?model.integral:@"0.00"] ;
    self.completeCount.text = [NSString stringWithFormat:@"%ld",model.completeCount];
    self.paymentOrder.text = [NSString stringWithFormat:@"%ld",model.payCount] ;
    self.visitorL.text =[NSString stringWithFormat:@"%ld",model.visitors] ;
    NSMutableAttributedString*string = [[NSMutableAttributedString alloc]initWithString:@"待发货："];
   
    NSMutableAttributedString*deliveryCount = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",model.deliveryCount]];
    [deliveryCount addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"EF593C"] range:NSMakeRange(0, deliveryCount.length)];
    [string appendAttributedString:deliveryCount];
    [string addAttribute:NSFontAttributeName value:PingFangSCMedium15 range:NSMakeRange(0, string.length)];
    [self.deliveryCount setAttributedTitle:string forState:0];
    NSMutableAttributedString*string2 = [[NSMutableAttributedString alloc]initWithString:@"待退款："];
    NSMutableAttributedString*refundsCount = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",model.refundsCount]];
    [refundsCount addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"EF593C"] range:NSMakeRange(0, refundsCount.length)];
    [string2 appendAttributedString:refundsCount];
    [string2 addAttribute:NSFontAttributeName value:PingFangSCMedium15 range:NSMakeRange(0, string2.length)];
    [self.refundsCount setAttributedTitle:string2 forState:0];
    
}
- (IBAction)myGoods:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(myGoods)]) {
        [self.delegate myGoods];
    }
}
- (IBAction)myOrderFrom:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gotoMyOrderFrom)]) {
        [self.delegate gotoMyOrderFrom];
    }
}
@end
