//
//  JRGymClassCell.m
//  JR
//
//  Created by Zj on 17/8/20.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "JRGymClassCell.h"

@interface JRGymClassCell()
@property (nonatomic, strong) UIView *containerView;


@end

@implementation JRGymClassCell

#pragma mark - lifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = JRClearColor;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - userInteraction
- (void)joinBtnClicked{
    NSLog(@"%s", __func__);
}


#pragma mark - private
- (void)setupSubViews{
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(JRPadding, 0, JRScreenWidth - 2 * JRPadding, JRGymClassCellHeight)];
    _containerView.backgroundColor = JRWhiteColor;
    _containerView.layer.cornerRadius = 3;
    [JRTool shadow:_containerView.layer];
    
    [self addSubview:_containerView];
    
    _classImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _containerView.width, JRHeight(185))];
    
    [_containerView addSubview:_classImageView];
    
    CGFloat labelHeight = (JRGymClassCellHeight - _classImageView.height - JRPadding) / 2;
    CGFloat joinBtnWidth = JRWidth(95);
    _memberLabel = [UILabel labelWithFrame:CGRectMake(_containerView.width - joinBtnWidth - JRPadding, _classImageView.bottom + 5, joinBtnWidth, labelHeight) text:@"(12人/15人)" color:JRHexColor(0x3ed5f2) font:JRBlodFont(JRCommonTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [_containerView addSubview:_memberLabel];
    
    CGFloat joinBtnHeight = JRHeight(38);
    _joinBtn = [UIButton buttonWithFrame:CGRectMake(_memberLabel.x, _containerView.height - joinBtnHeight - 5, joinBtnWidth, joinBtnHeight) title:@"预约" color:JRWhiteColor font:JRCommonFont(12) backgroundImage:[UIImage imageNamed:@"joinBg"] target:self action:@selector(joinBtnClicked)];
    
    [_containerView addSubview:_joinBtn];
    
    CGFloat labelWidth = _memberLabel.x - JRPadding;
    _classInfoLabel = [UILabel labelWithFrame:CGRectMake(JRPadding, _classImageView.bottom + 5, labelWidth, labelHeight) text:nil color:nil font:nil textAlignment:NSTextAlignmentLeft];
    
    [_containerView addSubview:_classInfoLabel];
    
    _classTimeLabel = [UILabel labelWithFrame:CGRectMake(JRPadding, _classInfoLabel.bottom, labelWidth, labelHeight) text:nil color:JRLightTextColor font:JRCommonFont(13) textAlignment:NSTextAlignmentLeft];
    
    [_containerView addSubview:_classTimeLabel];
}

@end
