//
//  SDCutEditItemsCollectionViewCell.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDCutEditItemsCollectionViewCell.h"

#import "SDCutFunctionModel.h"

@interface SDCutEditItemsCollectionViewCell ()

@property (nonatomic, weak) UIImageView * showCutImageView;

@property (nonatomic, weak) UILabel * theCutLabel;

@property (nonatomic, weak) UILabel * theCutInfoLabel;

@property (nonatomic, weak) UIView * theBgContentView;

@property (nonatomic, strong) UIColor * theme_color;

@end

@implementation SDCutEditItemsCollectionViewCell


- (void)loadCutFunctionModel:(SDCutFunctionModel * )model
{
    _cutModel = model;
    self.backgroundColor = [UIColor whiteColor];

    
    if (self.cutModel.isSelected) {
        [self showSelectedItem];
    }else{
        [self notSelectedItem];
    }
    
    if (self.cutModel.cutModel == SDCutFunctionReset) {
        [self configResetCutFunctionView];
    }else if (self.cutModel.cutModel == SDCutFunctionFree){
        [self configFreeCutFunctionView];
    }else if (self.cutModel.cutModel == SDCutFunction1_1){
        [self configCutFunctionWithSW:1 SH:1];
    }else if (self.cutModel.cutModel == SDCutFunction3_2){
        [self configCutFunctionWithSW:3 SH:2];
    }else if (self.cutModel.cutModel == SDCutFunction4_3){
        [self configCutFunctionWithSW:4 SH:3];
    }else if (self.cutModel.cutModel == SDCutFunction5_4){
        [self configCutFunctionWithSW:5 SH:4];
    }else if (self.cutModel.cutModel == SDCutFunction16_9){
        [self configCutFunctionWithSW:16 SH:9];
    }
    
    
    
}

- (void)configResetCutFunctionView
{
    
    [self theBgContentView];
    [self theCutLabel];
    
    if (_showCutImageView) {
        [_showCutImageView removeFromSuperview];
        _showCutImageView = nil;
    }
    if (_theCutInfoLabel) {
        [_theCutInfoLabel removeFromSuperview];
        _theCutInfoLabel = nil;
    }
    
    NSString * reset_string = @"重置";
    self.theCutLabel.text = reset_string;
    
    if (!self.cutModel.isSelected) {
        self.theBgContentView.backgroundColor = [UIColor colorWithHexRGB:0xf6f6fa];
        self.theCutLabel.textColor = [UIColor colorWithHexRGB:0x757575];
    }else{
        self.theBgContentView.backgroundColor = [UIColor colorWithHexRGB:0x45454c];
        self.theCutLabel.textColor = [UIColor colorWithHexRGB:0xf6f6fa];
    }
    
    
    
    CGSize cut_size = [self.theCutLabel.text sizeWithAttributes:@{NSFontAttributeName:self.theCutLabel.font}];
    
    [self.theBgContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(cut_size.width + MAXSize(60));
    }];
    
    
    self.theBgContentView.layer.masksToBounds = true;
    
    self.theBgContentView.layer.cornerRadius = MAXSize(41);
    
    [self.theCutLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(cut_size);
    }];
    
}

- (void)configFreeCutFunctionView
{
    if (_theBgContentView) {
        [_theBgContentView removeFromSuperview];
        _theBgContentView = nil;
    }
    
    if (_theCutLabel) {
        [_theCutLabel removeFromSuperview];
        _theCutLabel = nil;
    }
    
    [self showCutImageView];
    
    [self theCutInfoLabel];
    
    NSString * text = @"自由";
    
    self.theCutInfoLabel.text = text;
    
    self.theCutInfoLabel.textColor = self.theme_color;
    
    UIImage * image = [self clampImage];
    
    self.showCutImageView.image = image;
    
    CGSize title_size = [self.theCutInfoLabel.text sizeWithAttributes:@{NSFontAttributeName:self.theCutInfoLabel.font}];
    
    [self.theCutInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(title_size);
    }];

}

- (void)configCutFunctionWithSW:(NSInteger)wd SH:(NSInteger)he
{
    if (_theBgContentView) {
        [_theBgContentView removeFromSuperview];
        _theBgContentView = nil;
    }

    
    if (_theCutLabel) {
        [_theCutLabel removeFromSuperview];
        _theCutLabel = nil;
    }
    
    [self showCutImageView];
    
    [self theCutInfoLabel];
    
    NSString * text_string = [NSString stringWithFormat:@"%ld:%ld",wd,he];
    
    
    self.theCutInfoLabel.text = text_string;
    
    self.theCutInfoLabel.textColor = self.theme_color;

    UIImage * image = [self rangeWithwidthpar:wd heightpar:he];
    
    self.showCutImageView.image = image;
    
    CGSize title_size = [self.theCutInfoLabel.text sizeWithAttributes:@{NSFontAttributeName:self.theCutInfoLabel.font}];
    
    [self.theCutInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(title_size);
    }];

    
    
    
}


#pragma mark - 自由path
- (UIImage *)clampImage
{
    UIImage *clampImage = nil;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){22,22}, NO, 0.0f);
    {
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(1, 1, 18, 18)];
        [self.theme_color setStroke];
        rectanglePath.lineWidth = 1;
        [rectanglePath stroke];
        
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(10.5, 0.5)];
        [bezierPath addLineToPoint: CGPointMake(10.5, 10.5)];
        [bezierPath addLineToPoint: CGPointMake(18.5, 10.5)];
        [self.theme_color setStroke];
        bezierPath.lineWidth = 1;
        [bezierPath setLineDash: (CGFloat[]){3, 1} count: 2 phase: 0];
        [bezierPath stroke];
        
        clampImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return clampImage;
}


- (UIImage *)rangeWithwidthpar:(NSInteger)wp heightpar:(NSInteger)hp
{
    CGFloat width_size = 20;
    
    CGSize size = CGSizeZero;
    if (wp > hp) {
        size = CGSizeMake(width_size, width_size * (float)hp / (float)wp);
    }else if(wp < hp){
        size = CGSizeMake(width_size * (float)wp / (float)hp , width_size);
    }else{
        size = CGSizeMake(width_size, width_size);
    }
    
    
    UIImage *clampImage = nil;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){22,22}, NO, 0.0f);
    {
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(22 / 2.f - size.width /2.f, 22 / 2.f - size.height /2.f, size.width, size.height)];
        [self.theme_color setStroke];
        rectanglePath.lineWidth = 1;
        [rectanglePath stroke];
        clampImage = UIGraphicsGetImageFromCurrentImageContext();
        
    }
    UIGraphicsEndImageContext();
    
    return clampImage;
}

- (void)showSelectedItem
{
    self.theme_color = [UIColor colorWithHexRGB:0x45454c];
    
}
- (void)notSelectedItem
{
    self.theme_color = [UIColor colorWithHexRGB:0x969696];
}
#pragma mark - getter


- (UIView *)theBgContentView
{
    if (!_theBgContentView) {
        UIView * theView = [[UIView alloc] init];
        [self.contentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(MAXSize(20));
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(MAXSize(82));
        }];
        theView.backgroundColor = [UIColor colorWithHexRGB:0xf6f6fa];
        _theBgContentView = theView;
    }
    return _theBgContentView;
}

- (UILabel *)theCutLabel
{
    if (!_theCutLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.contentView addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.theBgContentView);
            make.size.mas_equalTo(CGSizeZero);
        }];
        
        theView.font = [UIFont systemFontOfSize:DFont(36)];
        theView.lineBreakMode = NSLineBreakByWordWrapping;
        _theCutLabel = theView;
    }
    return _theCutLabel;
}


- (UIImageView *)showCutImageView
{
    if (!_showCutImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self.contentView addSubview:theView];
        
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(MAXSize(30));
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(MAXSize(46), MAXSize(46)));
        }];
        _showCutImageView = theView;
    }
    return _showCutImageView;
}

- (UILabel *)theCutInfoLabel
{
    if (!_theCutInfoLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self.contentView addSubview:theView];
        
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.showCutImageView.mas_bottom).offset(MAXSize(10));
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeZero);
        }];
        
        theView.font = [UIFont systemFontOfSize:DFont(32)];
        
        theView.textColor = [UIColor colorWithHexRGB:0x45454c];
        theView.lineBreakMode = NSLineBreakByWordWrapping;
        _theCutInfoLabel = theView;
    }
    return _theCutInfoLabel;
}


@end
