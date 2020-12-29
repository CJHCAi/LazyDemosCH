//
//  HKOrderFormHeadView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKOrderFormHeadView.h"
@interface HKOrderFormHeadView()
@property (weak, nonatomic) IBOutlet UIButton *waitNum;
@property (weak, nonatomic) IBOutlet UIButton *waitText;
@property (weak, nonatomic) IBOutlet UIButton *waitPayNum;
@property (weak, nonatomic) IBOutlet UIButton *waitPayText;
@property (weak, nonatomic) IBOutlet UIButton *goedNum;
@property (weak, nonatomic) IBOutlet UIButton *goedText;
@property (weak, nonatomic) IBOutlet UIButton *afterSaleNum;
@property (weak, nonatomic) IBOutlet UIButton *afterSaleText;

@end

@implementation HKOrderFormHeadView
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKOrderFormHeadView" owner:self options:nil].firstObject;
        self.headType = OrderFormHeadType_wait;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
 
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKOrderFormHeadView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.headType = OrderFormHeadType_wait;
    }
    return self;
}
+(instancetype)orderFormHeadWithFrame:(CGRect)frame{
    HKOrderFormHeadView*view =  [[NSBundle mainBundle]loadNibNamed:@"HKOrderFormHeadView" owner:nil options:nil].firstObject;
    view.headType = OrderFormHeadType_wait;
    view.frame = frame;
    return view;
}
-(void)setHeadType:(OrderFormHeadType)headType{
    _headType = headType;
    switch (headType) {
        case OrderFormHeadType_wait:{
            self.waitNum.selected = self.waitText.selected = YES;
            self.waitPayNum.selected = self.waitPayText.selected = NO;
            self.goedNum.selected = self.goedText.selected = NO;
            self.afterSaleNum.selected = self.afterSaleText.selected = NO;
        }
            break;
        case OrderFormHeadType_waitPay:{
            self.waitNum.selected = self.waitText.selected = NO;
            self.waitPayNum.selected = self.waitPayText.selected = YES;
            self.goedNum.selected = self.goedText.selected = NO;
            self.afterSaleNum.selected = self.afterSaleText.selected = NO;
        }
            break;
        case OrderFormHeadType_goed:{
            self.waitNum.selected = self.waitText.selected = NO;
            self.waitPayNum.selected = self.waitPayText.selected = NO;
            self.goedNum.selected = self.goedText.selected = YES;
            self.afterSaleNum.selected = self.afterSaleText.selected = NO;
        }
            break;
        case OrderFormHeadType_afterSale:{
            self.waitNum.selected = self.waitText.selected = NO;
            self.waitPayNum.selected = self.waitPayText.selected = NO;
            self.goedNum.selected = self.goedText.selected = NO;
            self.afterSaleNum.selected = self.afterSaleText.selected = YES;
        }
            break;
        default:
            break;
    }
}

-(void)setModel:(SellerorderListHeadeModel *)model{
    _model = model;
    [self.waitNum setTitle:[NSString stringWithFormat:@"%ld",model.deliveryCount] forState:0];
    [self.waitNum setTitle:[NSString stringWithFormat:@"%ld",model.deliveryCount] forState:UIControlStateSelected];
    [self.waitPayNum setTitle:[NSString stringWithFormat:@"%ld",model.paymentfCount] forState:0];
    [self.waitPayNum setTitle:[NSString stringWithFormat:@"%ld",model.paymentfCount] forState:UIControlStateSelected];
    [self.goedNum setTitle:[NSString stringWithFormat:@"%ld",model.shippedCount] forState:0];
    [self.goedNum setTitle:[NSString stringWithFormat:@"%ld",model.shippedCount] forState:UIControlStateSelected];
    [self.afterSaleNum setTitle:[NSString stringWithFormat:@"%ld",model.salecCount] forState:0];
    [self.afterSaleNum setTitle:[NSString stringWithFormat:@"%ld",model.salecCount] forState:UIControlStateSelected];
}
- (IBAction)selectStaue:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(selectStaueWithType:)]) {
        [self.delegate selectStaueWithType:(OrderFormHeadType)sender.tag];
    }
}
@end
