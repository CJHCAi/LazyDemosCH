//
//  HKMyResumePreviewContentCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyResumePreviewContentCell.h"

@interface HKMyResumePreviewContentCell ()

@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation HKMyResumePreviewContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    UILabel *contentLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                     textColor:UICOLOR_HEX(0x666666) textAlignment:NSTextAlignmentLeft font:PingFangSCRegular14
                                                          text:self.userContent
                                                    supperView:self.contentView];
    contentLabel.numberOfLines = 0;
    self.contentLabel = contentLabel;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.top.equalTo(self.contentView).offset(18);
        make.right.equalTo(self.contentView).offset(-16);
        make.bottom.equalTo(self.contentView).offset(-17);
    }];
}

- (void)setUserContent:(NSString *)userContent {
    if (userContent) {
        _userContent = userContent;
        self.contentLabel.text = userContent;
    }
}

@end
