//
//  HK_orderShopFooterView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_orderShopFooterView.h"

@implementation HK_orderShopFooterView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
         self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.rightBtn];
        [self addSubview:self.leftBtn];
        [self addSubview:self.justLeftBtn];
        [self addSubview:self.priceLabel];
    }
    return self;
}

-(UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(kScreenWidth-10-88,10,88,28);
        _rightBtn.borderColor=[UIColor colorFromHexString:@"cccccc"];
        _rightBtn.borderWidth =1;
        _rightBtn.layer.masksToBounds =YES;
        _rightBtn.layer.cornerRadius =4;
        [_rightBtn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font =PingFangSCRegular13;
        [_rightBtn addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.tag =200;
    }
    return _rightBtn;
}

-(UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
       _leftBtn.frame = CGRectMake(CGRectGetMinX(self.rightBtn.frame)-88-10,10,88,28);
        _leftBtn.borderColor=[UIColor colorFromHexString:@"cccccc"];
        _leftBtn.borderWidth =1;
        _leftBtn.layer.masksToBounds =YES;
        _leftBtn.layer.cornerRadius =4;
        [_leftBtn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
        _leftBtn.titleLabel.font =PingFangSCRegular13;
        _leftBtn.hidden = YES;
         [_leftBtn addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.tag =100;
    }
    return _leftBtn;
}

-(UIButton *)justLeftBtn {
    if (!_justLeftBtn) {
        _justLeftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _justLeftBtn.frame = CGRectMake(CGRectGetMinX(self.leftBtn.frame)-88-10,10,88,28);
        _justLeftBtn.borderColor=[UIColor colorFromHexString:@"cccccc"];
        _justLeftBtn.borderWidth =1;
        _justLeftBtn.layer.masksToBounds =YES;
        _justLeftBtn.layer.cornerRadius =4;
        [_justLeftBtn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
        _justLeftBtn.titleLabel.font =PingFangSCRegular13;
       _justLeftBtn.hidden = YES;
        [_justLeftBtn addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _justLeftBtn.tag =50;
        
    }
    return _justLeftBtn;
    
}
-(UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,0,200,self.frame.size.height)];
        [AppUtils getConfigueLabel:_priceLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        _priceLabel.hidden =YES;
    }
    return _priceLabel;
}

/**
 *  我的售后. 根据状态显示不同工具栏
 */

-(void)ShowToolBarStatusWith:(HK_SaleLIstData *)saleModel {
    self.leftBtn.hidden = YES;
    [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
}
/**
 * 详情页 根据状态显示不同工具栏
 */
-(void)changeBarButtonStateWithStatus:(HK_orderInfo *)model {

    OrderFormStatue status =model.data.state.intValue;
    switch (status) {
        case OrderFormStatue_payed:
        {
         //判断有无出现申请售后
            [self.rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            if (model.data.afterList.count) {
                self.leftBtn.hidden =YES;
            }else {
                self.leftBtn.hidden =NO;
                [self.leftBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            }
        }
            break;
        case OrderFormStatue_finish:
        {
            self.leftBtn.hidden =NO;
             [self.leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
              [self.rightBtn setTitle:@"申请售后" forState:UIControlStateNormal];
            
            if (model.data.afterList.count) {
                self.rightBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
                 [self.rightBtn setTitle:@"已申请售后" forState:UIControlStateNormal];
                 self.rightBtn.enabled =NO;
            }
        }
            break;
        case OrderFormStatue_cancel:
        case OrderFormStatue_resale:
        {
            [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            self.leftBtn.hidden =YES;
        }
            break;
        case OrderFormStatue_cnsignment:
        {   self.leftBtn.hidden =NO;
            [self.rightBtn setTitle:@"收货" forState:UIControlStateNormal];
            [self.leftBtn setTitle:@"去转售" forState:UIControlStateNormal];
            if (model.data.afterList.count) {
                self.justLeftBtn.hidden =YES;
            }else {
                self.justLeftBtn.hidden = NO;
                [self.justLeftBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            }
        }
            break;
        case  OrderFormStatue_close:
        {
            self.leftBtn.hidden =YES;
            self.justLeftBtn.hidden =YES;
            [self.rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
            break;
        case OrderFormStatue_waitPay:
        {
            self.priceLabel.hidden = NO;
            NSMutableAttributedString  *attbuteOne =[[NSMutableAttributedString alloc] initWithString:@"应付: "];
            NSMutableAttributedString *attbuteTwo=[AppUtils configueLabelAtLeft:YES andCount:model.data.productIntegral];
            [attbuteTwo addAttribute:NSForegroundColorAttributeName value:keyColor range:NSMakeRange(0,attbuteTwo.length)];
            [attbuteOne appendAttributedString:attbuteTwo];
            self.priceLabel.attributedText = attbuteOne;
            
            [self.rightBtn setTitle:@"支付" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:[UIColor colorFromHexString:@"ffffff"] forState:UIControlStateNormal];
            self.rightBtn.backgroundColor =keyColor;
            self.leftBtn.hidden =NO;
            [self.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
-(void)footerBtnClick:(UIButton *)sender {

    if (self.delegete && [self.delegete respondsToSelector:@selector(clickFooterBtnClick:withSenderTag: sections:)]) {
        [self.delegete clickFooterBtnClick:self.model withSenderTag:sender.tag sections:self.section];
    }
}
@end
