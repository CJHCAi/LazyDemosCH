//
//  DouTodayFilmCell.m
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//

#import "DouTodayFilmCell.h"

@implementation DouTodayFilmCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.bgimageView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.contentLabel];
        
    }
    return self;
}

- (UIImageView *)bgimageView {
    if (_bgimageView == nil) {
        _bgimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, (SCREEN_WIDTH-40)*1.3)];
        _bgimageView.layer.cornerRadius = 15;
        _bgimageView.layer.masksToBounds = YES;
        
    }
    return _bgimageView;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, (SCREEN_WIDTH-40)*1.3+25)];
        
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-30, 30)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (SCREEN_WIDTH-40)*1.3-30, SCREEN_WIDTH-44, 15)];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.f];
        _contentLabel.alpha = 0.5;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

@end
