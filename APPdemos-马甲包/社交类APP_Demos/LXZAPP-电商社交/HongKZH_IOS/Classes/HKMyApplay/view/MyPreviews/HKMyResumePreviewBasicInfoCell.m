//
//  HKMyResumePreviewBasicInfoCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyResumePreviewBasicInfoCell.h"

@implementation HKMyResumePreviewBasicInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpUI];
    }
    return self;
}

- (NSArray *)packageData {
    if (self.myResumePreviewData) {
        NSArray *data = @[
                          @{
                              @"姓名": self.myResumePreviewData.name  ?  self.myResumePreviewData.name : @""
                              },
                          @{
                              @"性别": self.myResumePreviewData.sexName ?  self.myResumePreviewData.sexName : @""
                              },
                          @{
                              @"最高学历": self.myResumePreviewData.educationName ?  self.myResumePreviewData.educationName : @""
                              },
                          @{
                              @"工作年限": self.myResumePreviewData.workingLifeName ?  self.myResumePreviewData.workingLifeName : @""
                              },
                          @{
                              @"出生年份": self.myResumePreviewData.birthday ?  self.myResumePreviewData.birthday : @""
                              },
                          @{
                              @"所在城市": self.myResumePreviewData.locatedName ?  self.myResumePreviewData.locatedName : @""
                              },
                          @{
                              @"联系电话": self.myResumePreviewData.mobile ?  self.myResumePreviewData.mobile : @""
                              },
                          @{
                              @"联系邮箱": self.myResumePreviewData.email ?  self.myResumePreviewData.email : @""
                              }
                          ];
        return data;
    }
    return nil;
}

- (void)setUpUI {
    NSArray *items = [self packageData];
    UILabel *lastLabel = nil;
    for (int i = 0; i < items.count; i++) {
        NSDictionary *dict = items[i];
        NSString *key = [[dict allKeys] lastObject];
        NSString *value = dict[key];
        //左侧 label
        UILabel *leftLabel = [HKComponentFactory
                              labelWithFrame:CGRectZero
                              textColor:UICOLOR_HEX(0x333333)
                              textAlignment:NSTextAlignmentLeft
                              font:PingFangSCRegular13
                              text:key supperView:self.contentView];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(16);
            if (i == 0) {
                make.top.equalTo(self.contentView).offset(21);;
            } else {
                make.top.equalTo(lastLabel.mas_bottom).offset(12);
            }
            make.height.mas_equalTo(13);
        }];
        lastLabel = leftLabel;
        
        //右侧 label
        UILabel *rightLabel = [HKComponentFactory
                               labelWithFrame:CGRectZero
                               textColor:UICOLOR_HEX(0x666666)
                               textAlignment:NSTextAlignmentLeft
                               font:PingFangSCRegular13
                               text:value supperView:self.contentView];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(108);
            make.height.mas_equalTo(13);
            make.centerY.equalTo(leftLabel);
        }];
    }
}

- (void)setMyResumePreviewData:(HKMyResumePreviewData *)myResumePreviewData {
    if (myResumePreviewData) {
        _myResumePreviewData = myResumePreviewData;
        [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self setUpUI];
    }
}

@end
