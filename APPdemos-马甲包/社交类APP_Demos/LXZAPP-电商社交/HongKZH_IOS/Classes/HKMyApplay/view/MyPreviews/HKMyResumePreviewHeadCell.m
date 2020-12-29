//
//  HKMyResumePreviewHeadCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyResumePreviewHeadCell.h"

@interface HKMyResumePreviewHeadCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *locatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *workingLifeLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *corporateNameLabel;

@end

@implementation HKMyResumePreviewHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle  =UITableViewCellSelectionStyleNone;
    self.headImgView.layer.cornerRadius = 35;
    self.headImgView.layer.masksToBounds = YES;
}

- (void)setMyResumePreviewData:(HKMyResumePreviewData *)myResumePreviewData {
    if (myResumePreviewData) {
        _myResumePreviewData = myResumePreviewData;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:myResumePreviewData.portrait]];
        self.nameLabel.text = myResumePreviewData.name;
        if ([myResumePreviewData.sex integerValue] == 1) {
            self.sexView.image = [UIImage imageNamed:@"friend_boy"];
        } else if ([myResumePreviewData.sex integerValue] == 2) {
            self.sexView.image = [UIImage imageNamed:@"friend_girl"];
        }
        self.locatedLabel.text = myResumePreviewData.locatedName;
        self.workingLifeLabel.text = myResumePreviewData.workingLifeName;
        self.educationLabel.text = myResumePreviewData.educationName;
        self.corporateNameLabel.text = myResumePreviewData.corporateName;
    }
}

//观看视频
- (IBAction)watchVideo:(UIButton *)sender {
    if (self.watchVideoBlock) {
        self.watchVideoBlock();
    }
}

//图片附件
- (IBAction)watchImageAnnex:(id)sender {
    if (self.watchAnnexBlcok) {
        self.watchAnnexBlcok();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
