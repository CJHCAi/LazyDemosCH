//
//  HK_orderShopHeaderView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_orderShopHeaderView.h"

@interface HK_orderShopHeaderView ()
@property (nonatomic, strong)HK_shopOrderList *list;
@end

@implementation HK_orderShopHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self layoutSubviews];
        
       //点击头部 进入店铺....
        UITapGestureRecognizer * tapH =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tapH];
    }
    return  self;
    
}
-(void)layoutSubviews {
    [self addSubview:self.headerBackV];
    [self addSubview:self.typeImageView];
    [self addSubview:self.shopNameLabel];
    [self addSubview:self.stateLabel];
    [self addSubview:self.lineV];
    
}

-(void)headClick:(UITapGestureRecognizer *)tap {
    if (self.block) {
        self.block(self.list.shopId);
    }
}
-(UIView *)headerBackV {
    if (!_headerBackV) {
        _headerBackV =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
        _headerBackV.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    }
    return _headerBackV;
}

-(UIImageView *)typeImageView {
    if (!_typeImageView) {
        _typeImageView =[[UIImageView alloc] initWithFrame:CGRectMake(14,CGRectGetMaxY(self.headerBackV.frame)+11,18,18)];
        _typeImageView.layer.cornerRadius =9;
        _typeImageView.layer.masksToBounds = YES;
    }
    return _typeImageView;
}
-(UILabel *)shopNameLabel {
    if (!_shopNameLabel) {
        _shopNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.typeImageView.frame)+5,CGRectGetMaxY(self.headerBackV.frame),100,40)];
        [AppUtils getConfigueLabel:_shopNameLabel font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"乐购商城"];
            
    }
    return _shopNameLabel;
}
-(UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-200,CGRectGetMinY(self.shopNameLabel.frame),200,CGRectGetHeight(self.shopNameLabel.frame))];
        [AppUtils getConfigueLabel:_stateLabel font:PingFangSCRegular13 aliment:NSTextAlignmentRight textcolor:[UIColor colorFromHexString:@"333333"] text:@"待收货"];
    }
    return _stateLabel;
}
-(UIView *)lineV {
    if (!_lineV) {
        _lineV =[[UIView alloc] initWithFrame:CGRectMake(0,49,kScreenWidth,1)];
        _lineV.backgroundColor =RGB(242,242,242);
    }
    return _lineV;
    
}
/**
 * 我的订单列表
 */
-(void)configueListOrderHeaderWithModel:(HK_shopOrderList *)listOrder {
    _list = listOrder;
   [self.typeImageView sd_setImageWithURL:[NSURL URLWithString:listOrder.headImg] placeholderImage:[UIImage imageNamed:@"legoushangcheng"]];
    self.shopNameLabel.text =listOrder.name;
     OrderFormStatue status =listOrder.state.intValue;
    switch (status) {
        case OrderFormStatue_waitPay:
            self.stateLabel.text =@"等待付款";
            self.stateLabel.textColor =keyColor;
            self.lineV.hidden =NO;
            self.backgroundColor = [UIColor whiteColor];
            break;
        case OrderFormStatue_verify:
            self.stateLabel.text =@"确定订单";
            self.lineV.hidden =NO;
            self.backgroundColor = [UIColor whiteColor];
            break;
        case OrderFormStatue_payed:
            self.stateLabel.text =@"已支付";
            self.lineV.hidden =NO;
            self.backgroundColor = [UIColor whiteColor];
            break;
        case OrderFormStatue_cnsignment:
            self.stateLabel.text =@"暂存储";
            self.lineV.hidden =NO;
            self.backgroundColor = [UIColor whiteColor];
            break;
         case OrderFormStatue_consignee:
            self.stateLabel.text =@"已收货";
            self.lineV.hidden =NO;
            self.backgroundColor = [UIColor whiteColor];
            break;
         case OrderFormStatue_store:
            self.stateLabel.text =@"暂存储";
            self.lineV.hidden =NO;
            self.backgroundColor = [UIColor whiteColor];
            break;
         case OrderFormStatue_finish:
            self.stateLabel.text =@"已完成";
            self.lineV.hidden =NO;
            self.backgroundColor = [UIColor whiteColor];
            break;
          case OrderFormStatue_cancel:
            self.stateLabel.text =@"已取消";
            self.lineV.hidden =NO;
            self.backgroundColor = [UIColor whiteColor];
            break;
          case OrderFormStatue_resale:
            self.stateLabel.text =@"已转售";
            self.lineV.hidden =NO;
            self.backgroundColor = [UIColor whiteColor];
            break;
          case OrderFormStatue_close:
            self.stateLabel.text =@"已关闭";
            self.lineV.hidden =NO;
            self.backgroundColor = [UIColor whiteColor];
            break;
        default:
            self.stateLabel.text =@"待分享";
            self.lineV.hidden =YES;
            self.stateLabel.textColor =keyColor;
            self.backgroundColor = MainColor;
            break;
    }
}
/**
 * 我的订单详情
 */
-(void)setConfigueViewWithModel:(HK_orderInfo *)model {
    [self.typeImageView sd_setImageWithURL:[NSURL URLWithString:model.data.headImg] placeholderImage:[UIImage imageNamed:@"Man"]];
    self.shopNameLabel.text = model.data.name;
    OrderFormStatue status =model.data.state.intValue;
    switch (status) {
        case OrderFormStatue_waitPay:
            self.stateLabel.text =@"等待付款";
            self.stateLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            break;
        case OrderFormStatue_verify:
            self.stateLabel.text =@"确定订单";
            break;
        case OrderFormStatue_payed:
            self.stateLabel.text =@"已支付";
            break;
        case OrderFormStatue_cnsignment:
            self.stateLabel.text =@"暂存储";
            break;
        case OrderFormStatue_consignee:
            self.stateLabel.text =@"已收货";
            break;
        case OrderFormStatue_store:
            self.stateLabel.text =@"暂存储";
            break;
        case OrderFormStatue_finish:
            self.stateLabel.text =@"已完成";
            break;
        case OrderFormStatue_cancel:
            self.stateLabel.text =@"已取消";
            break;
        case OrderFormStatue_resale:
            self.stateLabel.text =@"已转售";
            break;
        case OrderFormStatue_close:
            self.stateLabel.text =@"已关闭";
            break;
        default:
            break;
    }
}
/**
 * 我的售后
 */
-(void)saleHeaderWithSaleModel:(HK_SaleLIstData *)saleModel {
    [self.typeImageView sd_setImageWithURL:[NSURL URLWithString:saleModel.headImg] placeholderImage:[UIImage imageNamed:@"legoushangcheng"]];
    self.shopNameLabel.text =saleModel.name;
    switch (saleModel.afterState.intValue) {
        case AfterSaleViewStatue_Application:
            self.stateLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            self.stateLabel.text =@"待商家处理退款";
            break;
        case AfterSaleViewStatue_cancel:
              self.stateLabel.text =@"取消退款";
            break;
        case  AfterSaleViewStatue_Agree:
             self.stateLabel.text =@"退款中";
            break;
        case AfterSaleViewStatue_Refuse:
            self.stateLabel.text =@"拒绝退款";
            break;
        case AfterSaleViewStatue_finish:
            self.stateLabel.text =@"退款完成";
            break;
        case  AfterSaleViewStatue_Complaint:
            self.stateLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            self.stateLabel.text =@"待商家处理投诉";
            break;
        case AfterSaleViewStatue_cancelComplaint:
            self.stateLabel.text =@"取消投诉";
            break;
        case AfterSaleViewStatue_ApplicationReturn:
            self.stateLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            self.stateLabel.text =@"待商家处理退货退款";
            break;
        case AfterSaleViewStatue_cancelApplicationReturn:
            self.stateLabel.text =@"取消退货退款";
            break;
         case AfterSaleViewStatue_SendReturnDelivery:
            self.stateLabel.text =@"已发退货快递";
            break;
         case AfterSaleViewStatue_AgreeReturn:
             self.stateLabel.text =@"同意退货退款";
            break;
         case AfterSaleViewStatue_RefuseReturn:
             self.stateLabel.text =@"拒绝退货退款";
            break;
         case AfterSaleViewStatue_ReturnFinish:
            self.stateLabel.text =@"退货退款完成";
            break;
          case AfterSaleViewStatue_ProofOfBuyer:
            self.stateLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            self.stateLabel.text =@"待商家处理举证";
            break;
          case AfterSaleViewStatue_ProofOfBuyerseller:
            self.stateLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            self.stateLabel.text =@"商家举证";
            break;
        default:
            break;
    }
}

@end
