//
//  HKCancleTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/6.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCancleTableViewCell.h"
#import "HKAfterSaleRespone.h"
@interface HKCancleTableViewCell()
@property (weak, nonatomic) IBOutlet HKAfterNode *nodeView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HKCancleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(HKAfterSaleRespone *)model{
    [super setModel:model];
    if (model.data.afterState.intValue == self.staue) {
        self.nodeView.isSelect = YES;
    }else{
        self.nodeView.isSelect = NO;
    }
    if (self.staue == AfterSaleViewStatue_cancel) {
        self.titleView.text = @"买家取消退款";
        self.timeLabel.text  = model.data.cancelDate;
    }else if (self.staue == AfterSaleViewStatue_cancelApplicationReturn){
        self.titleView.text = @"买家取消退货，交易恢复正常";
        self.timeLabel.text = model.data.cancelRefundDate;
    }else if (self.staue == AfterSaleViewStatue_cancelComplaint){
         self.titleView.text = @"买家取消投诉，交易恢复正常";
         self.timeLabel.text = model.data.complaintDate;
    }
}
@end
