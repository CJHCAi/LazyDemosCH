//
//  HKPositionManageTableViewCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPositionManageTableViewCell.h"

@interface HKPositionManageTableViewCell()
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *detailLabel;
@property (nonatomic, weak) UILabel *salaryLabel;
@end

@implementation HKPositionManageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    UILabel *nameLabel = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(51,51,51) textAlignment:NSTextAlignmentLeft font:[UIFont fontWithName:PingFangSCMedium size:15.f] text:@"" supperView:self.contentView];
    self.nameLabel = nameLabel;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *detailLabel = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(102,102,102) textAlignment:NSTextAlignmentLeft font:[UIFont fontWithName:PingFangSCRegular size:11.f] text:@"" supperView:self.contentView];
    self.detailLabel = detailLabel;
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(11);
    }];
    
    UILabel *salaryLabel = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(225,86,64) textAlignment:NSTextAlignmentRight font:[UIFont fontWithName:PingFangSCRegular size:15.f] text:@"" supperView:self.contentView];
    self.salaryLabel = salaryLabel;
    
    [self.salaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(17);
        make.height.mas_equalTo(15);
    }];
}

//设置数据
- (void)setPostionData:(HK_RecruitPositionData *)postionData {
    if (postionData) {
        self.nameLabel.text = postionData.title;
        self.detailLabel.text = [NSString stringWithFormat:@"%@ 丨 %@ 丨 %@",postionData.areaName,postionData.experienceName,postionData.educationName];
        self.salaryLabel.text = postionData.salaryName;
    }
}


@end
