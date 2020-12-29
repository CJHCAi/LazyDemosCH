//
//  HK_InfoTopCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_InfoTopCell.h"

@implementation HK_InfoTopCell

-(void)setConfigueWithModel:(HK_orderInfo *)model {
    self.messageLabel.text =@"您的订单已由本人签收";
    self.timeLabel.font =PingFangSCRegular12;
    self.timeLabel.textColor =[UIColor colorFromHexString:@"999999"];
    self.messageLabel.textColor =[UIColor colorFromHexString:@"333333"];
    self.timeLabel.text =model.data.deliverTime;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
- (IBAction)rowClick:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
