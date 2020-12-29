//
//  HKPositionOfflineCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPositionOfflineCell.h"

@interface HKPositionOfflineCell ()
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;

@end

@implementation HKPositionOfflineCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
}

- (void)setData:(HKRecruitOffLineData *)data {
    if (data) {
        _data = data;
        self.positionLabel.text = data.title;
        self.tipLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",data.areaName,data.experienceName,data.educationName];
        self.salaryLabel.text = data.salaryName;
    }
}

@end
