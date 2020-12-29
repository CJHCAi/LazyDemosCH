//
//  HKMyApplyRecomandJobCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyApplyRecomandJobCell.h"

@interface HKMyApplyRecomandJobCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *jobName;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;

@end

@implementation HKMyApplyRecomandJobCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.coverImgView.layer.cornerRadius = 5.f;
    self.coverImgView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setInfoData:(HK_jobData *)infoData {
    if (infoData) {
        _infoData = infoData;
        [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:infoData.coverImgSrc]];
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:infoData.headImg]];
        self.jobName.text = infoData.title;
        self.infoLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",infoData.areaName,infoData.experienceName,infoData.educationName];
        self.salaryLabel.text = infoData.salaryName;
        self.companyLabel.text = infoData.name;
    }
}


@end
