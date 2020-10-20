//
//  SXTMyTableViewCell.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/17.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTMyTableViewCell.h"
#import <Masonry.h>
@interface SXTMyTableViewCell()

@property (strong, nonatomic)   UIImageView *iconImage;              /** 图标 */
@property (strong, nonatomic)   UIImageView *nextImage;              /** 下一步 */
@property (strong, nonatomic)   UILabel *titileLabel;              /** 标题 */
@property (strong, nonatomic)   UILabel *lineLabel;              /** 分割线 */
@end

@implementation SXTMyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.iconImage];
        [self addSubview:self.nextImage];
        [self addSubview:self.titileLabel];
        [self addSubview:self.lineLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof (self) weakSelf = self;
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.left.equalTo(weakSelf.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_titileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(15);
        make.width.equalTo(@150);
    }];
    
    [_nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(-15);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(weakSelf);
        make.left.equalTo(weakSelf.titileLabel.mas_left);
        make.height.equalTo(@1);
    }];
    
}

- (void)setSourceDic:(NSDictionary *)sourceDic{
    _titileLabel.text = sourceDic[@"title"];
    _iconImage.image = [UIImage imageNamed:sourceDic[@"image"]];
}

- (UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
    }
    return _iconImage;
}

- (UIImageView *)nextImage{
    if (!_nextImage) {
        _nextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"下一步"]];
    }
    return _nextImage;
}

- (UILabel *)titileLabel{
    if (!_titileLabel) {
        _titileLabel = [[UILabel alloc]init];
        _titileLabel.font = [UIFont systemFontOfSize:14.0];
        _titileLabel.textColor = [UIColor blackColor];
        _titileLabel.text = @"1111111";
    }
    return _titileLabel;
}

- (UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = MainColor;
    }
    return _lineLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
