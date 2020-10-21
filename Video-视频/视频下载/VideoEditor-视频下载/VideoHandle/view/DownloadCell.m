//
//  DownloadCell.m
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/13.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import "DownloadCell.h"
#import "DownloadTool.h"

@interface DownloadCell ()

@end

@implementation DownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200 * SCREENWIDTH / 375, 17));
    }];
    _progressView.layer.cornerRadius = 8.0f;
    _progressView.layer.masksToBounds = YES;
}

//
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont boldSystemFontOfSize:16];
        _titleLab.textColor = COLOR(23, 23, 23, 1);
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(18);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(20);
            make.width.mas_equalTo(235 * SCREENWIDTH / 375);
        }];
        
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.tintColor = COLOR(255, 158, 87, 1);
        _progressView.trackTintColor = COLOR(214, 214, 214, 1);
        _progressView.layer.cornerRadius = 8.0f;
        _progressView.layer.masksToBounds = YES;
        [self.contentView addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLab);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(200 * SCREENWIDTH / 375, 17));
        }];
        
        _progressLab = [UILabel new];
        _progressLab.textColor = COLOR(255, 109, 109, 1);
        _progressLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_progressLab];
        [_progressLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_progressView.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(_progressView);
        }];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"wdxz_delete"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-18);
            make.centerY.mas_equalTo(_progressView);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        _controlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_controlBtn setImage:[UIImage imageNamed:@"wdxz_start"] forState:UIControlStateNormal];
        [self.contentView addSubview:_controlBtn];
        [_controlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_deleteBtn.mas_left).mas_offset(-10);
            make.centerY.mas_equalTo(_progressView);
            make.size.mas_equalTo(_deleteBtn);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = COLOR(179, 179, 179, 1);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(12);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-12);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(0);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
