//
//  HKPositionManagerCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPositionManagerCell.h"

@interface HKPositionManagerCell ()

@property (weak, nonatomic) IBOutlet UILabel *myCandidateLabel; //候选人
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HKPositionManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
}

- (void)setData:(HKRecruitOnlineData *)data {
    if (data) {
        _data = data;
        self.myCandidateLabel.text = [NSString stringWithFormat:@"%ld",data.candidate];
        self.positionLabel.text = data.title;
        self.tipLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",data.areaName,data.experienceName,data.educationName];
        self.salaryLabel.text = data.salaryName;
        if (data.updateTime == nil || [data.updateTime isEqualToString:@""]) {
            self.timeLabel.hidden = YES;
        } else {
            self.timeLabel.hidden = NO;
            self.timeLabel.text = data.updateTime;
        }
    }
}

@end
