//
//  HKMyResumePreviewEducationCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyResumePreviewEducationCell.h"

@interface HKMyResumePreviewEducationCell()

@property (nonatomic, weak) UILabel *majorLabel;    //专业
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIView *timeline;
@property (nonatomic, weak) UIView *timeLineFlag;

@end


@implementation HKMyResumePreviewEducationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    UIView *timeline = [[UIView alloc] init];
    timeline.backgroundColor = UICOLOR_HEX(0xeeeeee);
    [self.contentView addSubview:timeline];
    self.timeline = timeline;
    
    UIView *timeLineFlag = [[UIView alloc] init];
    [self.contentView addSubview:timeLineFlag];
    self.timeLineFlag = timeLineFlag;
    
    if (self.data) {
        if (self.data.lineStyle == 1) { //首个
            self.timeLineFlag.backgroundColor = UICOLOR_HEX(0x0092ff);
            [self.timeLineFlag mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(15);
                make.top.equalTo(self.contentView).offset(26);
                make.width.height.mas_equalTo(6);
            }];
            
            [self.timeline mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.timeLineFlag);
                make.top.equalTo(self.timeLineFlag.mas_bottom);
                make.width.mas_equalTo(1);
                make.bottom.equalTo(self.contentView);
            }];
        } else if (self.data.lineStyle == 2) {  //中间的
            self.timeLineFlag.backgroundColor = UICOLOR_HEX(0x999999);
            [self.timeLineFlag mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(15);
                make.top.equalTo(self.contentView).offset(26);
                make.width.height.mas_equalTo(6);
            }];
            
            [self.timeline mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.timeLineFlag);
                make.top.bottom.equalTo(self.contentView);
                make.width.mas_equalTo(1);
            }];
        } else if (self.data.lineStyle == 3) {  //最后一个
            self.timeLineFlag.backgroundColor = UICOLOR_HEX(0x999999);
            [self.timeLineFlag mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(15);
                make.top.equalTo(self.contentView).offset(26);
                make.width.height.mas_equalTo(6);
            }];
            
            [self.timeline mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.timeLineFlag);
                make.top.equalTo(self.contentView);
                make.width.mas_equalTo(1);
                make.bottom.equalTo(self.timeLineFlag.mas_top);
            }];
        }
        UILabel *majorLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                       textColor:UICOLOR_HEX(0x333333) textAlignment:NSTextAlignmentLeft font:PingFangSCRegular14
                                                            text:[NSString stringWithFormat:@"%@ | %@ | %@",self.data.graduate,self.data.major,self.data.educationName]
                                                      supperView:self.contentView];
        self.majorLabel = majorLabel;
        [self.majorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(30);
            make.top.equalTo(self.contentView).offset(21);
            make.height.mas_equalTo(14);
        }];
        
        UILabel *timeLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                      textColor:UICOLOR_HEX(0x999999) textAlignment:NSTextAlignmentLeft font:PingFangSCRegular11
                                                           text:self.data.graduationTime
                                                     supperView:self.contentView];
        self.timeLabel = timeLabel;
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.majorLabel);
            make.top.equalTo(self.majorLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(11);
        }];
    }
}

- (void)setData:(HKMyResumePreviewEducationals *)data {
    if (data) {
        _data = data;
        [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self setUpUI];
    }
}



@end
