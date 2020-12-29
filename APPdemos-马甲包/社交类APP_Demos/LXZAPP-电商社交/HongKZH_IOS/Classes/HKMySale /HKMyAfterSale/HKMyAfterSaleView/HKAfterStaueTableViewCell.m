//
//  HKAfterStaueTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAfterStaueTableViewCell.h"
#import "HKAfterSaleRespone.h"
@interface HKAfterStaueTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *plan;

@end

@implementation HKAfterStaueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(HKAfterSaleRespone *)model{
    [super setModel:model];
    switch (model.data.afterState.intValue) {
        case AfterSaleViewStatue_Application:
        case AfterSaleViewStatue_Agree:
        case AfterSaleViewStatue_ApplicationReturn:
        case AfterSaleViewStatue_AgreeReturn:
        case AfterSaleViewStatue_SendReturnDelivery:
        case AfterSaleViewStatue_Refuse:
        case AfterSaleViewStatue_RefuseReturn:
        {
            self.plan.text = @"退款中";
        }
            break;
        case AfterSaleViewStatue_cancel:
        case AfterSaleViewStatue_cancelApplicationReturn:
        case AfterSaleViewStatue_cancelComplaint:
        {
            self.plan.text = @"已完成";
        }
            break;
        case AfterSaleViewStatue_finish:
        case AfterSaleViewStatue_ReturnFinish:
        {
            self.plan.text = @"退款完成";
            
        }
            break;
        case AfterSaleViewStatue_Complaint:
        case AfterSaleViewStatue_ProofOfBuyer:
        case AfterSaleViewStatue_ProofOfBuyerseller:
        {
            self.plan.text = @"投诉";
        }
            break;
        default:
            break;
    }
    
   
}
-(void)setOrderNumber:(NSString *)orderNumber{
    _orderNumber = orderNumber;
    self.orderNum.text = orderNumber;
}
@end
