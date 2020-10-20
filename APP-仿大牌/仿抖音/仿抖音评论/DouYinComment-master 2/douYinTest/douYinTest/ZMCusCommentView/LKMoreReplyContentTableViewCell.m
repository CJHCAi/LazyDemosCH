//
//  LKMoreReplyContentTableViewCell.m
//  douYinTest
//
//  Created by Kai Liu on 2019/3/5.
//  Copyright © 2019 Kai Liu. All rights reserved.
//

#import "LKMoreReplyContentTableViewCell.h"

#import "UITableViewCell+FSAutoCountHeight.h"

@implementation LKMoreReplyContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.FS_cellBottomView = self.moreLabel;//尽量传入底视图，不传也不会报错
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
