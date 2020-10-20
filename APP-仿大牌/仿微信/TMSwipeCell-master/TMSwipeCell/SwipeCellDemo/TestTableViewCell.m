//
//  TestTableViewCell.m
//  TMSwipeCell
//
//  Created by cocomanber on 2018/7/7.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "TestTableViewCell.h"

@interface TestTableViewCell ()

@end

@implementation TestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV.layer.cornerRadius = 5;
    self.imageV.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

+ (CGFloat)rowHeight{
    return 70.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
