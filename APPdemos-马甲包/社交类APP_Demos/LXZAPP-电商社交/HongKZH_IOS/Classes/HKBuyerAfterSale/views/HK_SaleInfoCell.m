//
//  HK_SaleInfoCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_SaleInfoCell.h"
#import "HK_BuyAfterTool.h"
@implementation HK_SaleInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle =UITableViewCellSelectionStyleNone;
    //设置颜色..
    self.orderNumberLabel.textColor =[UIColor colorFromHexString:@"333333"];
    self.orderAfterLabel.textColor =[UIColor colorFromHexString:@"333333"];
    self.orderCount.textColor =[UIColor colorFromHexString:@"333333"];
    self.processLabel.textColor =[UIColor colorFromHexString:@"999999"];
    self.orderNumberLabel.font =PingFangSCMedium13;
    self.orderAfterLabel.font = PingFangSCMedium13;
    self.orderCount.font =PingFangSCRegular13;
    self.processLabel.font =PingFangSCRegular13;

    
}
-(void)ConfigueCellWithOrderString:(NSString *)orderString andResponse:(HKAfterSaleRespone *)response {
     self.orderCount.text = orderString;
    //根据状态来写退款进度
    AfterSaleViewStatue status =response.data.afterState.intValue;
    switch (status) {
        case AfterSaleViewStatue_Application:
        case AfterSaleViewStatue_ApplicationReturn:
        {
            NSString *dates=[HK_BuyAfterTool calculateRefundWithLimiteTime:response.data.limitDate andApplyTime:response.data.applyDate];
            NSString * text;
            //申请退款
            if (status==AfterSaleViewStatue_ApplicationReturn) {
                text =[NSString stringWithFormat:@"%@ 后退货时间截止",dates];
            }else {
                text =[NSString stringWithFormat:@"%@ 后系统自动退款",dates];
            }
            NSMutableAttributedString *attS =[[NSMutableAttributedString alloc] initWithString:text];
            [attS addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"d45048"] range:NSMakeRange(0,dates.length)];
            self.processLabel.attributedText = attS;
        }
            break;
            //取消退款
        case AfterSaleViewStatue_cancel:
        case AfterSaleViewStatue_cancelApplicationReturn:
            self.processLabel.text =@"已取消";
            self.processLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            break;
        case  AfterSaleViewStatue_Agree:
            //同意退款
            self.processLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            self.processLabel.text =@"退款中";
            break;
            //拒绝退款
        case  AfterSaleViewStatue_Refuse:
            self.processLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            self.processLabel.text =@"商家拒绝退款, 待买家处理";
            break;
       case AfterSaleViewStatue_RefuseReturn:
            self.processLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            self.processLabel.text =@"商家拒绝退货, 待买家处理";
            break;
            // 退款完成
        case AfterSaleViewStatue_finish:
            self.processLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            self.processLabel.text =@"退款成功";
            break;
            //同意退货
        case AfterSaleViewStatue_SendReturnDelivery:
        case AfterSaleViewStatue_AgreeReturn:
            self.processLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            self.processLabel.text =@"退货中";
            break;
        case AfterSaleViewStatue_Complaint:
        case AfterSaleViewStatue_ProofOfBuyer:
        case AfterSaleViewStatue_ProofOfBuyerseller:
          //举证
        {
           NSString *text =@"请买卖双方在3日内提交举证";
            NSMutableAttributedString *att =[[NSMutableAttributedString alloc] initWithString:text];
           
            [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"d45048"] range:NSMakeRange(6,3)];
            self.processLabel.attributedText =att;
        }
            break;
       case AfterSaleViewStatue_cancelComplaint:
            self.processLabel.textColor =[UIColor colorFromHexString:@"d45048"];
            self.processLabel.text =@"已取消投诉";
            break;
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
