//
//  HKPositionTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPositionsTableViewCell.h"
@interface HKPositionsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *timeDate;
@property (weak, nonatomic) IBOutlet UILabel *wages;

@end

@implementation HKPositionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(EnterpriseRecruitModel *)model{
    _model = model;
    self.name.text = model.title;
    self.desc.text = [NSString stringWithFormat:@"%@ | %@ | %@",model.areaName,model.experienceName,model.educationName];
    self.timeDate.text = model.createDate;
    self.wages.text = model.salaryName;
}
@end
