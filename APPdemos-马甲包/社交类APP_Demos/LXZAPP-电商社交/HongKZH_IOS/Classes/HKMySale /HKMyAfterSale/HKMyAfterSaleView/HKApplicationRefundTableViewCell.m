//
//  HKApplicationRefundTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKApplicationRefundTableViewCell.h"
#import "HKAfterSaleRespone.h"

@interface HKApplicationRefundTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *refundReason;
@property (weak, nonatomic) IBOutlet UILabel *refundcontact;
@property (weak, nonatomic) IBOutlet UILabel *refundTelephone;
@property (weak, nonatomic) IBOutlet UILabel *applyDate;
@property (weak, nonatomic) IBOutlet HKAfterNode *nodeView;
@property (weak, nonatomic) IBOutlet UILabel *row1Title;
@property (weak, nonatomic) IBOutlet UILabel *row2Title;
@property (weak, nonatomic) IBOutlet UILabel *row3Title;
@property (weak, nonatomic) IBOutlet UILabel *row4Title;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rights;

@end

@implementation HKApplicationRefundTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftBtn.layer.cornerRadius =4;
    self.leftBtn.layer.masksToBounds =YES;
    self.agree.layer.cornerRadius =4;
    self.agree.layer.masksToBounds =YES;
    self.rightBtn.layer.cornerRadius =4;
    self.rightBtn.layer.masksToBounds =YES;
}

-(void)setModel:(HKAfterSaleRespone *)model{
    [super setModel:model];
    if (self.staue == model.data.afterState.intValue) {
        self.nodeView.isSelect = YES;
        self.downView.hidden = NO;
        self.downH.constant = 48;
    }else{
        self.nodeView.isSelect = NO;
        self.downView.hidden = YES;
        self.downH.constant = 0;
    }
  
    self.applyDate.text = model.data.applyDate;
    if (model.data.type.intValue == 1) {
        self.type.text = @"仅退款";
        self.agree.hidden = YES;
        self.rights.constant = 10;
        self.leftBtn.hidden = YES;
        [self.agree setTitle:@"同意退款" forState:0 ];
        [self.rightBtn setTitle:@"拒绝退款" forState:0 ];
    }else{
        self.leftBtn.hidden = NO;
        self.agree.hidden = NO;
        self.type.text = @"退款退货";
        [self.agree setTitle:@"同意退货" forState:0 ];
        [self.rightBtn setTitle:@"拒绝退货" forState:0 ];
        self.rights.constant = 108;
    }
    self.refundReason.text = model.data.refundReason;
    self.refundcontact.text = model.data.refundcontact;
    self.refundTelephone.text = model.data.refundTelephone;
        
}

//买家 取消退款.
-(void)cancelRefund {
    if (self.staue == self.model.data.afterState.intValue) {
        self.nodeView.isSelect = YES;
        self.downView.hidden = YES;
        self.downH.constant = 0;
        self.applyDate.text =self.model.data.cancelDate;
        self.TitleMessageLabel.text =@"买家取消退款申请,系统处理中。";
    }else{
        self.nodeView.isSelect = NO;
        self.downView.hidden = YES;
        self.downH.constant = 0;
        self.applyDate.text =self.model.data.applyDate;
    }
}
#pragma mark 退货退款..
//买家 修改底部按钮标题和显示
-(void)changeBarStatus {
     self.leftBtn.hidden =YES;
     self.agree.hidden =NO;
    if (self.model.data.afterState.intValue ==AfterSaleViewStatue_Application) {
        
        [self.agree setTitle:@"修改退款" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"取消退款" forState:UIControlStateNormal];
        
    }else if (self.model.data.afterState.intValue ==AfterSaleViewStatue_ApplicationReturn ){
        self.nodeView.isSelect = YES;
        self.downView.hidden = NO;
        self.downH.constant = 48;
        self.TitleMessageLabel.text =@"买家申请退货,待商家处理。";
        [self.agree setTitle:@"修改退货" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"取消退货" forState:UIControlStateNormal];
    }
}
- (IBAction)leftBtnlick:(HKLineBtn *)sender {
    
    [self baseDirectRefund];
}
- (IBAction)centerBtnClick:(HKLineBtn *)sender {
    
    if (self.model.data.type.intValue == 1) {
        //同意退款
       [self baseApprovalArefund];
    }else{
        //同意退货
       [self baseApprovalArefund];
    }
}
- (IBAction)rigthClick:(HKLineBtn *)sender {
    
    if (self.model.data.type.intValue == 1) {
        //拒绝退款
        [self baseRefusingArefund];
    }else{
         //拒绝退货
        [self baseRefusingArefund];
    }
}
@end
