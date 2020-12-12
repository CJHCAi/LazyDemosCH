//
//  YSStaticTableViewCell.m
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/18.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import "YSStaticTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define YSScreenWidth      [UIScreen mainScreen].bounds.size.width
#define YSLeftGap 15

@implementation YSStaticTableViewCell

- (void)configureTableViewCellWithModel:(__kindof YSStaticCellModel *)cellModel {
    NSAssert(false, @"请自定义Cell+模型,在子类实现Cell的配置方法");
}

@end

@interface YSStaticDefaultCell ()
@property (nonatomic, strong) YSStaticDefaultModel *cellModel;

// 左侧
@property (nonatomic, strong) UIImageView *titleImageView;  ///< 左侧标题图片
@property (nonatomic, strong) UILabel     *titleLabel;      ///< 左侧标题

// 右侧
@property (nonatomic, strong) UIImageView *indicatorArrow;      ///< 右侧箭头
@property (nonatomic, strong) UISwitch    *indicatorSwitch;     ///< 右侧Switch
@property (nonatomic, strong) UIImageView *indicatorImageView;  ///< 左侧标题图片
@property (nonatomic, strong) UILabel     *indicatorLabel;      ///< 左侧标题
@end

@implementation YSStaticDefaultCell
@dynamic cellModel;

- (void)configureTableViewCellWithModel:(__kindof YSStaticCellModel *)cellModel {
    self.cellModel = cellModel;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self configLeft];
    [self configRight];
    
    [self configData];
}

- (void)configData {
    if (self.cellModel.titleSize.width > 0) {
        self.titleLabel.font = self.cellModel.titleFont;
        self.titleLabel.textColor = self.cellModel.titleColor;
        self.titleLabel.text = self.cellModel.title;
    }
    
    if (self.cellModel.indicatorTitleSize.width > 0) {
        self.indicatorLabel.font = self.cellModel.indicatorTitleFont;
        self.indicatorLabel.textColor = self.cellModel.indicatorTitleColor;
        self.indicatorLabel.text = self.cellModel.indicatorTitle;
    }
    
    UIImage *indicatorPlaceImage;
    if (self.cellModel.indicatorImageName) {
        indicatorPlaceImage = [UIImage imageNamed:self.cellModel.indicatorImageName];
        self.indicatorImageView.image = indicatorPlaceImage;
    }
    
    if (self.cellModel.indicatorImageUrl.length > 0) {
        [self.indicatorImageView sd_setImageWithURL:[NSURL URLWithString:self.cellModel.indicatorImageUrl] placeholderImage:indicatorPlaceImage];
    }
    
    UIImage *titlePlaceImage;
    if (self.cellModel.titleImageName) {
        titlePlaceImage = [UIImage imageNamed:self.cellModel.titleImageName];
        self.titleImageView.image = titlePlaceImage;
    }
    if (self.cellModel.titleImageUrl.length > 0) {
        [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:self.cellModel.titleImageUrl] placeholderImage:titlePlaceImage];
    }
}

- (void)configLeft {
    if (self.cellModel.showTitleImage) {
        [self.contentView addSubview:self.titleImageView];
        if (self.cellModel.titleSize.width > 0) {
            [self.contentView addSubview:self.titleLabel];
            if (self.cellModel.isTitleImageRight) {
                self.titleLabel.frame = CGRectMake(YSLeftGap, 0, self.cellModel.titleSize.width, self.cellModel.cellHeight);
                self.titleImageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + self.cellModel.titleImageSpace, (self.cellModel.cellHeight - self.cellModel.titleImageSize.height)/2, self.cellModel.titleImageSize.width, self.cellModel.titleImageSize.height);
            } else {
                self.titleImageView.frame = CGRectMake(YSLeftGap, (self.cellModel.cellHeight - self.cellModel.titleImageSize.height)/2, self.cellModel.titleImageSize.width, self.cellModel.titleImageSize.height);
                self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.titleImageView.frame) + self.cellModel.titleImageSpace, 0, self.cellModel.titleSize.width, self.cellModel.cellHeight);
            }
        } else { // 只展示Image
            self.titleImageView.frame = CGRectMake(YSLeftGap, (self.cellModel.cellHeight - self.cellModel.titleImageSize.height)/2, self.cellModel.titleImageSize.width, self.cellModel.titleImageSize.height);
        }
    } else if (self.cellModel.titleSize.width > 0)  {
        // 只展示Title
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.frame = CGRectMake(YSLeftGap, 0, self.cellModel.titleSize.width, self.cellModel.cellHeight);
    }
}

- (void)configRight {
    CGFloat endX = YSScreenWidth - YSLeftGap;
    if (self.cellModel.cellType == YSStaticCellTypeAccessoryNone) {
    } else if (self.cellModel.cellType == YSStaticCellTypeAccessorySwitch) {
        [self.contentView addSubview:self.indicatorSwitch];
        self.indicatorSwitch.frame = CGRectMake(endX - self.indicatorSwitch.bounds.size.width, (self.cellModel.cellHeight -  self.indicatorSwitch.bounds.size.height)/2, self.indicatorSwitch.bounds.size.width, self.indicatorSwitch.bounds.size.height);
        endX = CGRectGetMaxX(self.indicatorSwitch.frame) - YSLeftGap;
    } else if (self.cellModel.cellType == YSStaticCellTypeAccessoryArrow) {
        [self.contentView addSubview:self.indicatorArrow];
        self.indicatorArrow.frame = CGRectMake(endX - self.indicatorArrow.bounds.size.width, (self.cellModel.cellHeight - self.indicatorArrow.bounds.size.height)/2, self.indicatorArrow.bounds.size.width, self.indicatorArrow.bounds.size.height);
        endX = CGRectGetMaxX(self.indicatorArrow.frame) - YSLeftGap;
    }
    
    if (self.cellModel.showIndicatorImage) {
        [self.contentView addSubview:self.indicatorImageView];
        if (self.cellModel.indicatorTitleSize.width > 0) {
            [self.contentView addSubview:self.indicatorLabel];
            if (self.cellModel.isIndicatorImageLeft) {
                self.indicatorLabel.frame = CGRectMake(endX - self.cellModel.indicatorTitleSize.width, 0, self.cellModel.indicatorTitleSize.width, self.cellModel.cellHeight);
                self.indicatorImageView.frame = CGRectMake(CGRectGetMinX(self.indicatorLabel.frame) - self.cellModel.indicatorImageSpace - self.cellModel.indicatorImageSize.width, (self.cellModel.cellHeight - self.cellModel.indicatorImageSize.height)/2, self.cellModel.indicatorImageSize.width, self.cellModel.indicatorImageSize.height);
            } else {
                self.indicatorImageView.frame = CGRectMake(endX - self.cellModel.indicatorImageSize.width, (self.cellModel.cellHeight - self.cellModel.indicatorImageSize.height)/2, self.cellModel.indicatorImageSize.width, self.cellModel.indicatorImageSize.height);
                self.indicatorLabel.frame = CGRectMake(CGRectGetMinX(self.indicatorImageView.frame) - self.cellModel.indicatorImageSpace - self.cellModel.indicatorTitleSize.width, 0, self.cellModel.indicatorTitleSize.width, self.cellModel.cellHeight);
            }
        } else { // 只展示Image
            self.indicatorImageView.frame = CGRectMake(endX - self.cellModel.indicatorImageSize.width, (self.cellModel.cellHeight - self.cellModel.indicatorImageSize.height)/2, self.cellModel.indicatorImageSize.width, self.cellModel.indicatorImageSize.height);
        }
    } else if (self.cellModel.indicatorTitleSize.width > 0)  {
        // 只展示Title
        [self.contentView addSubview:self.indicatorLabel];
        self.indicatorLabel.frame = CGRectMake(endX - self.cellModel.indicatorTitleSize.width, 0, self.cellModel.indicatorTitleSize.width, self.cellModel.cellHeight);
    }
}

#pragma mark - switch block
- (void)switchTouched:(UISwitch *)indicatorSwitch {
    !self.cellModel.switchValueDidChangeBlock ?: self.cellModel.switchValueDidChangeBlock(indicatorSwitch.isOn);
}

#pragma mark - 懒加载
- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
    }
    return _titleImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel= [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UISwitch *)indicatorSwitch {
    if (!_indicatorSwitch) {
        _indicatorSwitch = [[UISwitch alloc] init];
        [_indicatorSwitch addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
    }
    return _indicatorSwitch;
}

- (UIImageView *)indicatorArrow {
    if (!_indicatorArrow) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        _indicatorArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow" inBundle:bundle compatibleWithTraitCollection:nil]];
    }
    return _indicatorArrow;
}

- (UILabel *)indicatorLabel {
    if (!_indicatorLabel) {
        _indicatorLabel= [[UILabel alloc] init];
    }
    return _indicatorLabel;
}

- (UIImageView *)indicatorImageView {
    if (!_indicatorImageView) {
        _indicatorImageView = [[UIImageView alloc] init];
    }
    return _indicatorImageView;
}

@end


@interface YSStaticButtonCell ()
@property (nonatomic, strong) YSStaticDefaultModel *cellModel;
@property (nonatomic, strong) UILabel     *titleLabel;   ///< 退出登录的label
@end

@implementation YSStaticButtonCell
@dynamic cellModel;

- (void)configureTableViewCellWithModel:(__kindof YSStaticCellModel *)cellModel {
    self.cellModel = cellModel;
    
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.frame = CGRectMake(0, 0, YSScreenWidth, self.cellModel.cellHeight);
}

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel= [[UILabel alloc] init];
        _titleLabel.font = self.cellModel.titleFont;
        _titleLabel.textColor = self.cellModel.titleColor;
        _titleLabel.text = self.cellModel.title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
