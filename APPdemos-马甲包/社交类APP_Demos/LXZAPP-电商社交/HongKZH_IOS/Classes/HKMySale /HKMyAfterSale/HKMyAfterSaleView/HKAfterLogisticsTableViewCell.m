//
//  HKAfterLogisticsTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAfterLogisticsTableViewCell.h"
#import "HKAfterSaleRespone.h"
#import "HKLineBtn.h"
@interface HKAfterLogisticsTableViewCell()
@property (weak, nonatomic) IBOutlet HKAfterNode *nodeVIew;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numText;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downH;
@property (weak, nonatomic) IBOutlet UILabel *row1;
@property (weak, nonatomic) IBOutlet UILabel *row2;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet HKLineBtn *rightBtn;
@property (weak, nonatomic) IBOutlet HKLineBtn *centerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtnRight;
@property (weak, nonatomic) IBOutlet HKLineBtn *leftBtn;

@end

@implementation HKAfterLogisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rightBtn.layer.cornerRadius =4;
    self.rightBtn.layer.masksToBounds =YES;
    self.centerBtn.layer.cornerRadius =4;
    self.centerBtn.layer.masksToBounds =YES;
    self.leftBtn.layer.cornerRadius =4;
    self.leftBtn.layer.masksToBounds =YES;
}
-(void)setModel:(HKAfterSaleRespone *)model{
    [super setModel:model];
    if (self.model.data.afterState.intValue == self.staue) {
        self.nodeVIew.isSelect = YES;
        self.downView.hidden = NO;
        self.downH.constant = 48;
    }else{
        self.nodeVIew.isSelect = NO;
        self.downView.hidden = YES;
        self.downH.constant = 0;
    }
    if (self.staue == AfterSaleViewStatue_SendReturnDelivery) {
    self.titleText.text = @"买家提交退款物流，待商家处理";
    self.row1.text = @"退货物流单号：";
    self.row1.text = @"快递公司：";
    self.timeLabel.text = self.model.data.courierDate;
    self.nameLabel.text = self.model.data.courier;
    self.numText.text = self.model.data.courierNumber;

        self.centerBtn.hidden = YES;
        self.rightBtn.hidden = YES;
       // self.leftBtnRight.constant = 15;
    }else if (self.staue == AfterSaleViewStatue_Complaint){
        self.titleText.text = @"买家发起投诉，待双方举证";
        self.row1.text = @"投诉原因：";
        self.row2.text = @"投诉描述：";
        self.timeLabel.text = model.data.complaintDate;
        self.numText.text = model.data.complaintReason;
        self.nameLabel.text = model.data.complaintDesc;
        self.leftBtn.hidden = YES;
        [self.centerBtn setTitle:@"同意退款" forState:0];
        [self.rightBtn setTitle:@"举证" forState:0];
    }
}
//right
- (IBAction)agree:(id)sender {
    if (self.staue == AfterSaleViewStatue_Complaint) {
        //举证
        [self baseProof];
    }else{
        
     [self baseApprovalArefund];
   
    }
}
//center
- (IBAction)Reasons:(id)sender {
    if (self.staue == AfterSaleViewStatue_Complaint) {
       [self baseApprovalArefund];
    }else{
    [self baseRefusingArefund];
    }
}
//left
- (IBAction)tracking:(id)sender {
    
    [self baseTrackingLogistics];
}

-(void)changeBtnStatus {
    if (self.staue==AfterSaleViewStatue_Complaint) {
        self.leftBtn.hidden =YES;
        [self.centerBtn setTitle:@"取消投诉" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"举证" forState:UIControlStateNormal];
    }else {
        self.centerBtn.hidden = NO;
        self.rightBtn.hidden = NO;
        [self.leftBtn setTitle:@"修改物流" forState:UIControlStateNormal];
        [self.centerBtn setTitle:@"取消退货" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"跟踪物流" forState:UIControlStateNormal];
    }
}

@end
