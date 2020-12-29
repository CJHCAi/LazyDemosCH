//
//  HKMarketHeadTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMarketHeadTableViewCell.h"
#import "AppDelegate.h"
@implementation HKMarketHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)gotoGame:(id)sender {
    [KAppdelegate StartMyUnity3DGames];
}

@end
