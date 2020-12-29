//
//  ConfirmationOfOrderFootVIew.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "ConfirmationOfOrderFootVIew.h"
#import "UIView+Xib.h"
@interface ConfirmationOfOrderFootVIew()
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@end
@implementation ConfirmationOfOrderFootVIew

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoInfo)];
    [self addGestureRecognizer:tap];
}
-(void)gotoInfo{
    if (self.couponCount>0) {
        if ([self.delegate respondsToSelector:@selector(translateGoods)]) {
            [self.delegate translateGoods];
        }
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // TODO:init
        [self setupSelfNameXibOnSelf];
    }
    return self;
}
-(void)setCouponCount:(NSInteger)couponCount{
    _couponCount = couponCount;
    self.num.hidden = NO;
    self.integralLabel.hidden = YES;
    self.titleLabel.text = @"优惠券";
    if (self.couponCount>0) {
        self.userInteractionEnabled = YES;
        self.rightIcon.hidden = NO;
    }else{
        self.userInteractionEnabled = NO;
        self.rightIcon.hidden = YES;
    }
    
    self.num.text = [NSString stringWithFormat:@"可用折扣卷%ld张",couponCount];
}
-(void)setDeductible:(NSInteger)userIntegral countOffsetCoin:(NSInteger)countOffsetCoin{
    self.num.hidden = YES;
    self.rightIcon.hidden = YES;
    self.titleLabel.text = @"乐币";
    self.integralLabel.hidden = NO;
    self.integralLabel.textColor =[UIColor colorFromHexString:@"333333"];
    NSString * attStr =[NSString stringWithFormat:@"%zd乐币,可抵%zd个乐币",userIntegral,countOffsetCoin];
    NSString *textStr =[NSString stringWithFormat:@"你当前共有%@",attStr];
    NSMutableAttributedString*string = [[NSMutableAttributedString alloc]initWithString:textStr];
       [string addAttribute:NSForegroundColorAttributeName value:keyColor range:NSMakeRange(5,attStr.length)];
    self.integralLabel.attributedText =string;
//    NSMutableAttributedString*integralNum = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",userIntegral]];
//    [integralNum addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"EF593C"] range:NSMakeRange(0, integralNum.length)];
//    [string appendAttributedString:integralNum];
//    NSMutableAttributedString*string2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"，%ld可抵%.2lf元",countOffsetCoin,countOffsetCoin*0.01] ];
//    [string2 addAttribute:NSForegroundColorAttributeName value:RGB(51,51,51) range:NSMakeRange(0, string2.length)];
//    [string appendAttributedString:string2];
//    [string addAttribute:NSFontAttributeName value:PingFangSCMedium12 range:NSMakeRange(0, string.length)];
}
-(void)setIntegral:(NSInteger)integral{
    _integral = integral;
    self.num.hidden = YES;
    self.rightIcon.hidden = YES;
    self.titleLabel.text = @"乐币";
    self.integralLabel.hidden = NO;
    NSMutableAttributedString*string = [[NSMutableAttributedString alloc]initWithString:@"您当前共有"];
    [string addAttribute:NSForegroundColorAttributeName value:RGB(51,51,51) range:NSMakeRange(0, string.length)];
    NSMutableAttributedString*integralNum = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",integral]];
    [integralNum addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"EF593C"] range:NSMakeRange(0, integralNum.length)];
    [string appendAttributedString:integralNum];
    NSInteger all ;
    double p;
   NSInteger a = [[NSString stringWithFormat:@"%ld",integral]length]-1;
    if (a>3) {
       all =  (integral/a*10)*a*10;
    }else{
        all = integral;
    }
   
     p = all/100;
    NSMutableAttributedString*string2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"，%ld可抵%.2lf元",all,p] ];
    [string2 addAttribute:NSForegroundColorAttributeName value:RGB(51,51,51) range:NSMakeRange(0, string2.length)];
    [string appendAttributedString:string2];
    [string addAttribute:NSFontAttributeName value:PingFangSCMedium12 range:NSMakeRange(0, string.length)];
    self.integralLabel.attributedText = string;
}
- (IBAction)clickBtn:(id)sender {
    if (self.couponCount>0) {
        [self gotoInfo];
    }else{
    self.selectBtn.selected = !self.selectBtn.selected;
        if ([self.delegate respondsToSelector:@selector(selectCoin:)]) {
            [self.delegate selectCoin:self.selectBtn];
        }
    }
}
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.selectBtn.selected = isSelected;
}
@end
