//
//  HKTAgreeableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTAgreeableViewCell.h"
#import "HKAfterSaleRespone.h"
#import "HKLineBtn.h"
@interface HKTAgreeableViewCell()
@property (weak, nonatomic) IBOutlet HKAfterNode *nodeView;
@property (weak, nonatomic) IBOutlet UILabel *refundsDate;
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downH;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet HKLineBtn *rightBtn;
@property (weak, nonatomic) IBOutlet HKLineBtn *leftBtn;
@property (weak, nonatomic) IBOutlet HKLineBtn *theLeftBtn;

@end

@implementation HKTAgreeableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftBtn.layer.cornerRadius =4;
    self.leftBtn.layer.masksToBounds =YES;
    self.rightBtn.layer.cornerRadius =4;
    self.rightBtn.layer.masksToBounds =YES;
    
}
-(void)setModel:(HKAfterSaleRespone *)model{
    [super setModel:model];
    self.refundsDate.text = model.data.refundsDate;
    if (model.data.afterState.intValue == self.staue) {
        self.nodeView.isSelect = YES;
    }else{
        self.nodeView.isSelect = NO;
    }
    if (model.data.afterState.intValue == AfterSaleViewStatue_RefuseReturn) {
        self.downH.constant = 48;
        self.downView.hidden = NO;
    }else{
        self.downH.constant = 0;
        self.downView.hidden = YES;
    }
    if (self.staue == AfterSaleViewStatue_Agree) {
        self.cellName.text = @"商家同意退款，系统退款中。";
        self.cellTitle.text = @"将原路退回至买家的付款账户";
        self.cellTitle.textColor =[UIColor colorFromHexString:@"999999"];
        self.refundsDate.textColor =[UIColor colorFromHexString:@"999999"];
        self.refundsDate.text =model.data.approvalRefundDate;
    }else if (self.staue == AfterSaleViewStatue_finish||self.staue == AfterSaleViewStatue_ReturnFinish){
        self.cellName.text = @"退款成功";
        self.cellTitle.text = [NSString stringWithFormat:@"退款金额共计%@乐币，已退款至买家账号",model.data.refundAmount];
        self.cellTitle.textColor =[UIColor colorFromHexString:@"999999"];
        self.refundsDate.textColor =[UIColor colorFromHexString:@"999999"];
        self.refundsDate.text = model.data.refundsDate;
    }else if (self.staue == AfterSaleViewStatue_RefuseReturn){
        self.cellName.text = @"商家拒绝退货，待买家处理";
        self.cellTitle.text = [NSString stringWithFormat:@"拒绝理由：%@",model.data.refusereGoodsReason];
    }else if (self.staue == AfterSaleViewStatue_Refuse){
        self.cellName.text = @"商家拒绝退款，待买家处理";
        self.cellTitle.text = [NSString stringWithFormat:@"拒绝理由：%@",model.data.refusereGoodsReason];
    }else if (self.staue == AfterSaleViewStatue_cancelApplicationReturn){
        self.cellName.text = @"商家拒绝退货，待买家处理";
        self.cellTitle.text = [NSString stringWithFormat:@"拒绝理由：%@",model.data.refusereGoodsReason];
    }
}
-(void)setStaue:(AfterSaleViewStatue)staue{
    [super setStaue:staue];
}
- (IBAction)rightBtnClick:(HKLineBtn *)sender {
    
    if (self.staue == AfterSaleViewStatue_RefuseReturn) {
        
        [self baseApprovalArefund];
        
    }else if (self.staue ==AfterSaleViewStatue_Refuse){
        
        [self baseRefusingGoods];
    }
}
- (IBAction)leftBtnClick:(HKLineBtn *)sender {
    
    if (self.staue == AfterSaleViewStatue_RefuseReturn) {
        
        [self baseTrackingLogistics];
        
    }else if (self.staue ==AfterSaleViewStatue_Refuse){
        
        [self baseApprovalArefund];
    }
}
//投诉
- (IBAction)complainsSeller:(id)sender {
    
    if (self.staue ==AfterSaleViewStatue_Refuse ||self.staue==AfterSaleViewStatue_RefuseReturn) {
        [self baseDirectRefund];
    }
}
//商家拒绝退款退货
-(void)sellerRefuseRefundShowing {
    self.nodeView.isSelect = YES;
    self.downH.constant = 48;
    self.downView.hidden = NO;
    self.theLeftBtn.hidden =NO;
    self.theLeftBtn.layer.cornerRadius=4;
    self.theLeftBtn.layer.masksToBounds=YES;
    [self.theLeftBtn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
    self.cellTitle.text =[NSString stringWithFormat:@"拒绝原因: %@ ",self.model.data.refuserefundReason];
    self.cellTitle.textColor =[UIColor colorFromHexString:@"999999"];
    self.refundsDate.textColor =[UIColor colorFromHexString:@"999999"];
    self.refundsDate.text =self.model.data.approvalRefundDate;
   //拒绝退款
    if (self.staue==AfterSaleViewStatue_Refuse) {
        self.cellName.text = @"商家拒绝退款，待买家处理。";
        [self.rightBtn setTitle:@"取消退款" forState:UIControlStateNormal];
        [self.leftBtn setTitle:@"修改退款" forState:UIControlStateNormal];
    }else {
    //拒绝退货
        self.cellName.text = @"商家拒绝退货，待买家处理。";
        [self.rightBtn setTitle:@"取消退货" forState:UIControlStateNormal];
        [self.leftBtn setTitle:@"修改退货" forState:UIControlStateNormal];
    }
}
-(void)buyComplain {
    self.downH.constant = 0;
    self.downView.hidden = YES;
}

@end
