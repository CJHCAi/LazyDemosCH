//
//  YSAvatorCell.m
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/19.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import "YSAvatorCell.h"
#import "YSAvatarModel.h"

@interface YSAvatorCell ()
//MeViewController里面的头像cell
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) UIImageView *avatarIndicatorImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userIdLabel;

@property (nonatomic, readwrite, strong) YSAvatarModel *cellModel;

@end

@implementation YSAvatorCell

@dynamic cellModel;

- (void)configureTableViewCellWithModel:(__kindof YSStaticCellModel *)cellModel {
    self.cellModel = cellModel;
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.userIdLabel];
    [self.contentView addSubview:self.avatarIndicatorImageView];
    [self.contentView addSubview:self.codeImageView];
    
    self.avatarImageView.image = self.cellModel.avatarImage;
    self.userNameLabel.text = self.cellModel.userName;
    self.userIdLabel.text = self.cellModel.userID;
    self.codeImageView.image = self.cellModel.codeImage;
}

#pragma mark - 懒加载
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.frame = CGRectMake(15, 15, self.cellModel.cellHeight - 2*15,  self.cellModel.cellHeight - 2*15);
    }
    return _avatarImageView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont systemFontOfSize:15];
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame) + 15, self.avatarImageView.frame.origin.y + 15/2, 150, 20);
    }
    return _userNameLabel;
}

- (UILabel *)userIdLabel {
    if (!_userIdLabel) {
        _userIdLabel   = [[UILabel alloc] init];
        _userIdLabel.font = [UIFont systemFontOfSize:12];
        _userIdLabel.textColor = [UIColor blackColor];
        _userIdLabel.frame = CGRectMake(CGRectGetMaxX(_avatarImageView.frame) + 15, CGRectGetMaxY(self.userNameLabel.frame) + 4, 150, 20);
    }
    return _userIdLabel;
}

- (UIImageView *)avatarIndicatorImageView {
    if (!_avatarIndicatorImageView) {
        _avatarIndicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YSStaticTableViewController.bundle/arrow@2x.png"]];
        _avatarIndicatorImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 15 - _avatarIndicatorImageView.bounds.size.width, (self.cellModel.cellHeight - _avatarIndicatorImageView.bounds.size.height)/2, _avatarIndicatorImageView.bounds.size.width, _avatarIndicatorImageView.bounds.size.height);
    }
    
    return _avatarIndicatorImageView;
}

- (UIImageView *)codeImageView {
    if (!_codeImageView) {
        _codeImageView = [[UIImageView alloc] init];
        _codeImageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 15 - _avatarIndicatorImageView.bounds.size.width - 15 - 20, (self.cellModel.cellHeight - 20)/2, 20, 20);
    }
    return _codeImageView;
}

@end
