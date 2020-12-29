//
//  HKMyApplyResumeInfoCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyApplyResumeInfoCell.h"
@interface HKMyApplyResumeInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *resumeOpenLabel;
@property (weak, nonatomic) IBOutlet UIImageView *resumeOpenView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;

@end

@implementation HKMyApplyResumeInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImgView.layer.cornerRadius = 30;
    self.headImgView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setData:(HKMyApplyData *)data {
    if (data) {
        _data = data;
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:data.portrait]];
        self.nameLabel.text = data.name;
        if ([data.sex integerValue] == 1) {
            self.sexView.image = [UIImage imageNamed:@"friend_boy"];
        } else {
            self.sexView.image = [UIImage imageNamed:@"friend_girl"];
        }
        self.jobLabel.text = data.functionsName;
        self.companyLabel.text = data.corporateName;
        if (data.isOpen && [data.isOpen integerValue] == 1) {
            self.resumeOpenView.image = [UIImage imageNamed:@"jlykf_56"];
            self.resumeOpenLabel.text = @"简历已开放";
        } else {
            self.resumeOpenView.image = [UIImage imageNamed:@"jlwkf_56"];
            self.resumeOpenLabel.text = @"未开放简历";
        }
        
    }
}

@end
