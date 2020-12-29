//
//  HKPleaseReturnTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPleaseReturnTableViewCell.h"
#import "HKAfterSaleRespone.h"
@interface HKPleaseReturnTableViewCell()
@property (weak, nonatomic) IBOutlet HKAfterNode *nodeView;
@property (weak, nonatomic) IBOutlet UILabel *consignee;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downH;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtns;

@property (weak, nonatomic) IBOutlet UIButton *leftBtns;

@end

@implementation HKPleaseReturnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftBtns.layer.cornerRadius =4;
    self.leftBtns.layer.masksToBounds =YES;
    self.rightBtns.layer.cornerRadius =4;
    self.rightBtns.layer.masksToBounds =YES;

}
-(void)setModel:(HKAfterSaleRespone *)model{
    [super setModel:model];
    if (self.staue == model.data.afterState.intValue) {
        self.nodeView.isSelect = YES;
        self.downH.constant = 48;
        self.downView.hidden = NO;
    }else{
        self.nodeView.isSelect = NO;
        self.downH.constant = 0;
        self.downView.hidden = YES;
    }
    self.consignee.text = model.data.consignee;
    self.phone.text = model.data.phone;
    self.timeLabel.text = model.data.agreeRefundDate;
    self.address.text = model.data.address;
}
- (IBAction)rigjtBtnCLick:(id)sender {
    
     [self baseRefusingArefund];
    
}
- (IBAction)leftBtnClick:(id)sender {
  
     [self baseApprovalArefund];
}

-(void)changeBarStatus {
    
    [self.rightBtns setTitle:@"取消退货" forState:UIControlStateNormal];
    [self.leftBtns setTitle:@"填写物流" forState:UIControlStateNormal];

}
@end
