//
//  NFMenuHeaderView.m
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/19.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import "NFMenuHeaderView.h"

@implementation NFMenuHeaderView
{
    UIImageView *_logoView;
    UILabel     *_nameLabel;
    UILabel     *_versionLabel;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _logoView = [[UIImageView alloc]init];
        _logoView.layer.masksToBounds = YES;
        _logoView.layer.cornerRadius  = 45;
        _logoView.image = [UIImage imageNamed:@"yc_icon"];
        _logoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = YC_Base_TitleFont;
        _nameLabel.text = kAppName;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = YC_Base_TitleColor;
        [self addSubview:_nameLabel];
        
        _versionLabel = [[UILabel alloc]init];
        _versionLabel.font = YC_Base_ContentFont;
        _versionLabel.text = [NSString stringWithFormat:@"V%@", [YCToolManager currentVerson]];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.textColor = YC_Base_TitleColor;
        [self addSubview:_versionLabel];
    }
    return self;
}
#pragma mark - layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).with.offset(20);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_logoView.mas_bottom).with.offset(12);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(@15);
    }];
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(10);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(@13);
    }];
}
@end
