//
//  HK_orderInfoCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_orderInfoCell.h"

@implementation HK_orderInfoCell



- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //配置初始化的控件
    [self configueInitUI];
}
-(void)setOrderInfoCellWithModel:(HK_orderInfo *)model {
    
    self.orderNumberLabel.text =model.data.orderNumber;
    self.orderTimeLabel.text = model.data.createDate;
    
    self.payTool.text= model.data.payType;
    if (model.data.payTime.length) {
         self.payTimeLabel.text =model.data.payTime;
    }else {
        self.payTimeLabel.text =@"您还未进行支付";
    }
    if (model.data.confirmDate.length) {
         self.tranferTimeLabell.text =model.data.confirmDate;
    }else {
        self.tranferTimeLabell.text =@"您还未确定订单";
    }
//    self.goodCountLabel.attributedText =[AppUtils configueLabelAtLeft:YES andCount:model.data.productIntegral];
//    self.transFeeLabel.attributedText =[AppUtils configueLabelAtLeft:YES andCount:model.data.freightIntegral];
//    self.payTotalLabel.attributedText =[AppUtils configueLabelAtLeft:YES andCount:model.data.integral];
    self.goodCountLabel.text =[NSString stringWithFormat:@"￥%zd",model.data.productIntegral];
    self.transFeeLabel.text =[NSString stringWithFormat:@"￥%zd",model.data.freightIntegral];
    self.payTotalLabel.text =[NSString stringWithFormat:@"￥%.2f",model.data.integral];
}
-(void)configueInitUI {
    
    self.TopInfoView.backgroundColor  =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    self.orderInfoView.backgroundColor =[UIColor whiteColor];
    self.payInfoView.backgroundColor =[UIColor whiteColor];
    self.TopLineView.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    self.SecondLineView.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    self.payTotalInfoView.backgroundColor =[UIColor whiteColor];
    self.goodCountLabel.textColor = keyColor;
    self.transFeeLabel.textColor = keyColor;
    self.payTotalLabel.textColor = keyColor;
    self.orderNumberLabel.font = PingFangSCRegular13;
    self.orderTimeLabel.font = PingFangSCRegular13;
    self.payTool.font =PingFangSCRegular13;
    self.payTimeLabel.font =PingFangSCRegular13;
    self.goodCountLabel.font =PingFangSCRegular13;
    self.transFeeLabel.font =PingFangSCRegular13;
    self.payTotalInfoView.hidden =YES;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
