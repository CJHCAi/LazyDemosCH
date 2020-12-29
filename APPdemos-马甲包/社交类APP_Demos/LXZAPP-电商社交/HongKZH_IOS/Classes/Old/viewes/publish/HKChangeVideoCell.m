//
//  HKChangeVideoCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKChangeVideoCell.h"
#import "HKEditRecruitment.h"

@interface HKChangeVideoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@end

@implementation HKChangeVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.coverImgView.layer.cornerRadius = 4;
    self.coverImgView.layer.masksToBounds = YES;
}

- (IBAction)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(changeVideoBlock)]) {
        [self.delegate changeVideoBlock];
    }

}



- (void)setData:(id)data {
    if (data) {
        _data = data;
        if ([data isKindOfClass:[HKEditResumeData class]]) {
            HKEditResumeData *editResumeData = (HKEditResumeData *)data;
            [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:editResumeData.coverImgSrc]];
        } else if ([data isKindOfClass:[HKEditRecruitmentData class]]) {
            HKEditRecruitmentData *editRecruitmentData = (HKEditRecruitmentData *)data;
            [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:editRecruitmentData.coverImgSrc]];
        }
    }
}

@end
