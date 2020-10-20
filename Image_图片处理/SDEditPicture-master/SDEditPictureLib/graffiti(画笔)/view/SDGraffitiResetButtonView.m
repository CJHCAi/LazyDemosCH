//
//  SDGraffitiResetButtonView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDGraffitiResetButtonView.h"

@implementation SDGraffitiResetButtonView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MAXSize(160), MAXSize(160));
    }
    return self;
}

- (void)setGraffitiResetModel:(SDGraffitiResetModel *)graffitiResetModel
{
    _graffitiResetModel = graffitiResetModel;
    
    [self sd_configResetView];
}

- (void)sd_configResetView
{
    
    
    [self theLabelBgView];
    [self theResetLabel];
    NSString * reset_string = @"重置";
    self.theResetLabel.text = reset_string;
    
    if (!self.graffitiResetModel.isSelected) {
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
    
    
    [self addTarget:self action:@selector(onResetAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)onResetAction:(id)sender
{
    [self.graffitiResetModel.done_subject sendNext:@"1"];
}



- (UILabel *)theResetLabel
{
    if (!_theResetLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
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
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(MAXSize(82));
        }];
        theView.backgroundColor = [UIColor colorWithHexRGB:0xf6f6fa];
        _theLabelBgView = theView;
    }
    return _theLabelBgView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
