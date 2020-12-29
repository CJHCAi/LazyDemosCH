//
//  HKUserContentCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUserContentCell.h"

@interface HKUserContentCell ()

@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIButton *editButton;

@end

@implementation HKUserContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier userContent:@"" cellBlock:nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier userContent:(NSString *)userContent cellBlock:(UpdateResumeBlock) block{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.userContent = userContent;
        self.updateResumeBlock = block;
        [self setUpUI];
    }
    return self;
}

+ (instancetype)cellWithUserContent:(NSString *)userContent cellBlock:(UpdateResumeBlock) block {
    return [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HKUserContentCell class]) userContent:userContent cellBlock:block];
}

- (void)setUpUI {
    UILabel *contentLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                  textColor:UICOLOR_HEX(0x999999) textAlignment:NSTextAlignmentLeft font:PingFangSCRegular11
                                                       text:self.userContent
                                                 supperView:self.contentView];
    contentLabel.numberOfLines = 0;
    self.contentLabel = contentLabel;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(18);
        make.top.equalTo(self.containerView).offset(44);
        make.right.equalTo(self.containerView).offset(-18);
        make.bottom.equalTo(self.containerView).offset(-23);
    }];
    
    //修改 button
    UIButton *editButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                        frame:CGRectZero
                                                        taget:self
                                                       action:@selector(buttonClick) supperView:self.contentView];
    [editButton setImage:[UIImage imageNamed:@"bianji2s"] forState:UIControlStateNormal];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.top.equalTo(self.containerView).offset(10);
        make.right.equalTo(self.containerView).offset(-10);
    }];
}

- (void)buttonClick {
    if (self.updateResumeBlock) {
        self.updateResumeBlock();
    }
}

@end
