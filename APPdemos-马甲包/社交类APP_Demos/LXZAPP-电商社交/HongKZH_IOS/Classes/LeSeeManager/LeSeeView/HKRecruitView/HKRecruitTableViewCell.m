//
//  HKRecruitTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRecruitTableViewCell.h"
#import "UIImageView+HKWeb.h"
#import "UIButton+ZSYYWebImage.h"
@interface HKRecruitTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descView;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation HKRecruitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(RecruitDataModel *)model{
    _model = model;
    self.nameLabel.text  = model.title;
    self.descView.text = [NSString stringWithFormat:@"%@ | %@ | %@",model.areaName,model.experienceName,model.educationName];
    self.company.text = model.name;
    self.num.text = model.salaryName;
    [self.headView hk_setBackgroundImageWithURL:model.coverImgSrc forState:0 placeholder:kPlaceholderImage];
    [self.logo hk_sd_setImageWithURL:model.headImg placeholderImage:kPlaceholderImage];
}
@end
