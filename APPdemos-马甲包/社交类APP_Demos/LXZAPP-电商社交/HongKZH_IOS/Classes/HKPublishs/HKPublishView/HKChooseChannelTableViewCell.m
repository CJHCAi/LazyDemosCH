//
//  HKChooseChannelTableViewCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKChooseChannelTableViewCell.h"
@interface HKChooseChannelTableViewCell ()

@property (nonatomic, weak) TTTAttributedLabel *channelLabel;

@property (nonatomic, strong) UIControl *layerControl;

@end

@implementation HKChooseChannelTableViewCell

//设置发布频道富文本
- (void)setChannelTextValue {
    NSString *str = [NSString stringWithFormat:@"发布到 %@ 频道",self.category.name];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:PingFangSCRegular size:15.f] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(102, 102, 102) range:NSMakeRange(0, attributedString.length)];
    
    NSRange range = [str rangeOfString:self.category.name];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:PingFangSCMedium size:15.f] range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:RGB(51, 51, 51) range:range];
    
    self.channelLabel.text = attributedString;
}

- (TTTAttributedLabel *)channelLabel {
    if (_channelLabel == nil) {
        TTTAttributedLabel *channelLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:channelLabel];
        self.channelLabel = channelLabel;
        
        [_channelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _channelLabel;
}

- (UIControl *)layerControl {
    if (!_layerControl) {
        _layerControl = [[UIControl alloc] init];
        [_layerControl addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _layerControl;
}

- (void)controlClick {
    if (self.block) {
        self.block();
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.detailTextLabel.text = @"更改";
        self.detailTextLabel.font = [UIFont fontWithName:PingFangSCRegular size:14.f];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.layerControl];
        [_layerControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX);
            make.top.height.right.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setCategory:(HK_BaseAllCategorys *)category {
    if (category) {
        _category = category;
        if (!self.istrvel) {
            
            [self setChannelTextValue];
        }else {
            
            [self setCityTextValue];
        }
    }
}
-(void)setCityTextValue {
    self.detailTextLabel.text = self.category.name;
}

@end
