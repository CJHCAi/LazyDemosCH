//
//  LKCommentListContentCell.m
//  douYinTest
//
//  Created by Kai Liu on 2019/3/5.
//  Copyright © 2019 Kai Liu. All rights reserved.
//

#import "LKCommentListContentCell.h"

#import "UITableViewCell+FSAutoCountHeight.h"
#import "LKContentModel.h"

@implementation LKCommentListContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.FS_cellBottomView = self.contentLabel;//尽量传入底视图，不传也不会报错
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configData:(LKContentModel *)model
{
    self.userNameLabel.text = model.username;
    self.contentLabel.text = model.content;
}

@end
