//
//  HKPositionTableViewCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPositionTableViewCell.h"

@implementation HKPositionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont fontWithName:PingFangSCRegular size:14];
        self.textLabel.textColor = RGB(153,153,153);
        self.detailTextLabel.font = [UIFont fontWithName:PingFangSCRegular size:12];
        self.detailTextLabel.textColor = RGB(244,72,52);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setPositionData:(HK_RecruitPositionData *)positionData {
    if (!positionData) {
        return;
    }
    _positionData = positionData;
    self.textLabel.text = positionData.title;
    self.detailTextLabel.text = positionData.salaryName;
}

-(void)confiueCellWithModel:(HK_positionData *)data {
  
    self.textLabel.text = data.title;
    self.detailTextLabel.text = data.salaryName;
}



@end
