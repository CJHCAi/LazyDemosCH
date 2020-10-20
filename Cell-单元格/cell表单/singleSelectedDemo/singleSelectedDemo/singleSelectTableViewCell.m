//
//  singleSelectTableViewCell.m
//  singleSelectedDemo
//
//  Created by qhx on 2017/7/27.
//  Copyright © 2017年 quhengxing. All rights reserved.
//

#import "singleSelectTableViewCell.h"

@implementation singleSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenSizeWidth-50, cellHeight)];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.titleLabel];
        
        self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenSizeWidth, cellHeight)];
        self.selectBtn.imageEdgeInsets = UIEdgeInsetsMake(15, ScreenSizeWidth-35, 15, 15);//设置边距
        [self.selectBtn addTarget:self action:@selector(selectPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectBtn];
        
    }
    return self;
}

- (void)selectPressed:(UIButton *)sender{
    self.isSelect = !self.isSelect;
    if (self.qhxSelectBlock) {
        self.qhxSelectBlock(self.isSelect,sender.tag);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
