//
//  HomeCell.m
//  IStone
//
//  Created by 胡传业 on 14-7-23.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        _videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 170, 110)];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
