//
//  HKMyDeliveryCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyDeliveryCell.h"

@interface HKMyDeliveryCell ()




@end
@implementation HKMyDeliveryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle =UITableViewCellSelectionStyleNone;
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
        UILabel *contentLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                       textColor:UICOLOR_HEX(0x333333) textAlignment:NSTextAlignmentLeft font:PingFangSCRegular14
                                                            text:self.data.content
                                                      supperView:self.contentView];
        self.contentLabel = contentLabel;
        self.contentLabel.numberOfLines =0;
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(30);
            make.top.equalTo(self.contentView).offset(21);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(kScreenWidth-30);
        }];
        
        UILabel *createDateLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                      textColor:UICOLOR_HEX(0x999999) textAlignment:NSTextAlignmentLeft font:PingFangSCRegular12
                                                           text:self.data.createDate
                                                     supperView:self.contentView];
        self.createDateLabel = createDateLabel;
        [self.createDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentLabel);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(12);
        }];
    }else {
       //frame布局
        
        
    }
}

- (void)setData:(HKMyDeliveryLogs *)data {
    if (data) {
        _data = data;
        [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self setUpUI];
    }
}


@end
