//
//  SingTableViewCell.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/21.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "SingTableViewCell.h"

@implementation SingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.nameLabel setFont:[UIFont fontWithName:@"HannotateSC-W5" size:17]];
    [self.textLabel setFont:[UIFont fontWithName:@"HannotateSC-W5" size:13]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
