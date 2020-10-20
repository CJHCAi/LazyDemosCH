//
//  SDFilterImageCollectionViewCell.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/24.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDFilterImageCollectionViewCell.h"
#import "SDFilterFunctionModel.h"

#import "AppFileComment.h"

@implementation SDFilterImageCollectionViewCell



- (void)loadFilterModel:(SDFilterFunctionModel * )model
{
    
    _filterModel = model;
    
    [self theFilterBgContentView];
    NSString * imageLink = self.filterModel.filterImageLink;
    
    imageLink = [AppFileComment imagePathStringWithImagename:imageLink imageType:@"jpg"];
    
    self.theFilterImageView.image = [UIImage imageNamed:imageLink];
    NSString * title = self.filterModel.filterTitle;
    
    self.theFilterTitleLabel.text = title;
    CGSize title_size = [self.theFilterTitleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.theFilterTitleLabel.font}];
    
    [self.theFilterTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(title_size);
    }];
    self.theFilterBgContentView.hidden = !self.filterModel.isSelected;
    
}


- (UIView *)theFilterBgContentView
{
    if (!_theFilterBgContentView) {
        UIView * theView = [[UIView alloc] init];
        [self.contentView addSubview:theView];
        
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(MAXSize(20));
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(MAXSize(200), MAXSize(200)));
        }];
        theView.backgroundColor = [UIColor colorWithHexRGB:0xfbc02d];
        
        theView.layer.masksToBounds = YES;
        theView.layer.cornerRadius = MAXSize(100);
        
        _theFilterBgContentView = theView;
    }
    return _theFilterBgContentView;
}

- (UIImageView *)theFilterImageView
{
    if (!_theFilterImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self.contentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.theFilterBgContentView);
            make.size.mas_equalTo(CGSizeMake(MAXSize(180), MAXSize(180)));
        }];
        theView.layer.masksToBounds = YES;
        theView.layer.cornerRadius = MAXSize(90);
        _theFilterImageView = theView;
    }
    return _theFilterImageView;
}

- (UILabel *)theFilterTitleLabel
{
    if (!_theFilterTitleLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.contentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.theFilterBgContentView.mas_bottom).offset(MAXSize(10));
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeZero);
        }];
        theView.font = [UIFont systemFontOfSize:DFont(32)];
        theView.textColor = [UIColor colorWithHexRGB:0x757575];
        theView.lineBreakMode = NSLineBreakByWordWrapping;
        _theFilterTitleLabel = theView;
    }
    return _theFilterTitleLabel;
}


@end
