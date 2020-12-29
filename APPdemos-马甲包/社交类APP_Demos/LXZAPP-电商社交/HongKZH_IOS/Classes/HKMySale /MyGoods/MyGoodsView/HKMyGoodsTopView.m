//
//  HKMyGoodsTopView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyGoodsTopView.h"
#import "HKMyGoodsOrderView.h"
@interface HKMyGoodsTopView()<HKMyGoodsOrderViewDelegate>
@property (weak, nonatomic) IBOutlet HKMyGoodsOrderView *timeOeder;
@property (weak, nonatomic) IBOutlet HKMyGoodsOrderView *salesVolume;
@property (weak, nonatomic) IBOutlet HKMyGoodsOrderView *turnover;
@property (weak, nonatomic) IBOutlet HKMyGoodsOrderView *stock;
@property (weak, nonatomic) IBOutlet UIButton *upLabel;
@property (weak, nonatomic) IBOutlet UIButton *downlabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueLineLeft;

@end

@implementation HKMyGoodsTopView
- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKMyGoodsTopView" owner:self options:nil].lastObject;
    if (self) {
        self.timeOeder.orderType = MYUpperProductOrder_time;
        self.salesVolume.orderType = MYUpperProductOrder_SalesVolume;
        self.turnover.orderType = MYUpperProductOrder_AAturnover;
        self.stock.orderType = MYUpperProductOrder_Stock;
        self.timeOeder.delegate = self;
        self.salesVolume.delegate = self;
        self.turnover.delegate = self;
        self.stock.delegate = self;
        self.selectOrder = MYUpperProductOrder_time;
    }
    return self;
}
-(void)goodsOrderType:(MYUpperProductOrder)orderType{
    self.selectOrder = orderType;
    if ([self.delegate respondsToSelector:@selector(selectOrderWithType:)]) {
        [self.delegate selectOrderWithType:self.selectOrder];
    }
}
-(void)setSelectOrder:(MYUpperProductOrder)selectOrder{
    _selectOrder = selectOrder;
    switch (selectOrder) {
        case MYUpperProductOrder_time:{
            self.timeOeder.isSelect = YES;
            self.salesVolume.isSelect = NO;
            self.turnover.isSelect = NO;
            self.stock.isSelect = NO;
            
        }
            break;
        case MYUpperProductOrder_SalesVolume:{
            self.salesVolume.isSelect = YES;
            self.timeOeder.isSelect = NO;
            self.turnover.isSelect = NO;
            self.stock.isSelect = NO;
        }
            break;
        case MYUpperProductOrder_AAturnover:{
            self.salesVolume.isSelect = NO;
            self.timeOeder.isSelect = NO;
            self.turnover.isSelect = YES;
            self.stock.isSelect = NO;
            
        }
            break;
        case MYUpperProductOrder_Stock:{
            self.salesVolume.isSelect = NO;
            self.timeOeder.isSelect = NO;
            self.turnover.isSelect = NO;
            self.stock.isSelect = YES;
            
        }
            break;
            
        default:
            break;
    }
}
- (IBAction)switchBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(switchUpDownWithType:)]) {
        [self.delegate switchUpDownWithType:(UpDownType)sender.tag];
    }
    if (sender.tag == 0) {
        [self.upLabel setTitleColor:[UIColor blackColor] forState:0];
        [self.downlabel setTitleColor:[UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:124.0/255.0 alpha:1] forState:0];
        [UIView animateWithDuration:0.1 animations:^{
           self.blueLineLeft.constant = 0;
        }];
        
    }else{
        [self.downlabel setTitleColor:[UIColor blackColor] forState:0];
        [self.upLabel setTitleColor:[UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:124.0/255.0 alpha:1] forState:0];
        [UIView animateWithDuration:0.1 animations:^{
            self.blueLineLeft.constant = kScreenWidth*0.5;
        }];
       
    }
}
@end
