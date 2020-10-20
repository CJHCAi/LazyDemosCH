//
//  SDDecorateEditItemsCollectionViewCell.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDDecorateEditItemsCollectionViewCell.h"

#import "SDDecorateFunctionModel.h"

#import "AppFileComment.h"

@implementation SDDecorateEditItemsCollectionViewCell

- (void)loadDecorateModel:(SDDecorateFunctionModel * )model
{
    _decorateModel = model;
    
    if (self.decorateModel.decorateType == SDDecorateFunctionReset) {
        [self sd_configResetView];
    }else if (self.decorateModel.decorateType == SDDecorateFunctionImage){
        [self sd_configDecorateView];
    }
    
}

- (void)sd_configResetView
{
    [self theLabelBgView];
    [self theResetLabel];
    
    if (_theBgContentView) {
        [_theBgContentView removeFromSuperview];
        _theBgContentView = nil;
    }
    
    if (_theShowImageView) {
        [_theShowImageView removeFromSuperview];
        _theShowImageView = nil;
    }
    
    NSString * reset_string = @"重置";
    self.theResetLabel.text = reset_string;
    
    if (!self.decorateModel.isSelected) {
        self.theLabelBgView.backgroundColor = [UIColor colorWithHexRGB:0xf6f6fa];
        self.theResetLabel.textColor = [UIColor colorWithHexRGB:0x757575];
    }else{
        self.theLabelBgView.backgroundColor = [UIColor colorWithHexRGB:0x45454c];
        self.theResetLabel.textColor = [UIColor colorWithHexRGB:0xf6f6fa];
    }
    
    
    
    CGSize cut_size = [self.theResetLabel.text sizeWithAttributes:@{NSFontAttributeName:self.theResetLabel.font}];
    
    [self.theLabelBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(cut_size.width + MAXSize(60));
    }];
    
    
    self.theLabelBgView.layer.masksToBounds = true;
    
    self.theLabelBgView.layer.cornerRadius = MAXSize(41);
    
    [self.theResetLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(cut_size);
    }];

}

- (void)sd_configDecorateView
{
    [self theBgContentView];
    [self theShowImageView];
    if (_theLabelBgView) {
        [_theLabelBgView removeFromSuperview];
        _theLabelBgView = nil;
    }
    if (_theResetLabel) {
        [_theResetLabel removeFromSuperview];
        _theResetLabel = nil;
    }

//    if (self.decorateModel.isSelected) {
//        self.theBgContentView.hidden = false;
//    }else{
//        self.dec
//    }
    
    NSString * imageLink = self.decorateModel.imageLink;
    
    imageLink = [AppFileComment imagePathStringWithImagename:imageLink];
    
    
    self.theShowImageView.image = [UIImage imageNamed:imageLink];
    
}



- (UILabel *)theResetLabel
{
    if (!_theResetLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.contentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeZero);
        }];
        
        theView.font = [UIFont systemFontOfSize:DFont(36)];
        theView.lineBreakMode = NSLineBreakByWordWrapping;
        _theResetLabel = theView;
    }
    return _theResetLabel;
}

- (UIView *)theLabelBgView
{
    if (!_theLabelBgView) {
        UIView * theView = [[UIView alloc] init];
        [self.contentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(MAXSize(82));
        }];
        theView.backgroundColor = [UIColor colorWithHexRGB:0xf6f6fa];
        _theLabelBgView = theView;
    }
    return _theLabelBgView;
}
- (UIView *)theBgContentView
{
    if (!_theBgContentView) {
        UIView * theView = [[UIView alloc] init];
        [self.contentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(MAXSize(200), MAXSize(200)));
        }];
        theView.backgroundColor = [UIColor colorWithHexRGB:0xfbc02d];
        theView.hidden = YES;
        _theBgContentView = theView;
    }
    return _theBgContentView;
}

- (UIImageView *)theShowImageView
{
    if (!_theShowImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self.contentView addSubview:theView];
        
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(MAXSize(180), MAXSize(180)));
        }];
        _theShowImageView = theView;
    }
    return _theShowImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
