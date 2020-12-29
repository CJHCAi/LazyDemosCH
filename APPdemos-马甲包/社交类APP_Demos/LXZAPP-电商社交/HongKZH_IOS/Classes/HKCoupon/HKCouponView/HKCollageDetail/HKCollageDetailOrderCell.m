//
//  HKCollageDetailOrderCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCollageDetailOrderCell.h"

@interface HKCollageDetailOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderPay;
@property (weak, nonatomic) IBOutlet UIButton *pasteBtn;


@end



@implementation HKCollageDetailOrderCell


- (IBAction)pasteClick:(id)sender {
    if (self.block) {
        self.block();
    }
   //复制内容到剪切板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *pasteStr =[NSString stringWithFormat:@"%@\n%@",self.orderNumberLabel.text,self.orderTimeLabel.text];
    [pasteboard setString:pasteStr];
    [EasyShowTextView showText:@"复制成功"];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.pasteBtn setTitleColor:keyColor forState:UIControlStateNormal];
    self.pasteBtn.borderColor = keyColor;
    self.pasteBtn.borderWidth = 1;
    self.pasteBtn.layer.masksToBounds =YES;
    self.pasteBtn.layer.cornerRadius =5;
}

-(void)setResponse:(HKCollageOrderResponse *)response {
    _response = response;
    self.orderNumberLabel.text =[NSString stringWithFormat:@"订单编号: %@",response.data.orderNumber];
    self.orderTimeLabel.text =[NSString stringWithFormat:@"订单时间: %@",response.data.createDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
