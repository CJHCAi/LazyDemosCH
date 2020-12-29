//
//  HKMyResumePreviewCareerIntentionCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyResumePreviewCareerIntentionCell.h"

@implementation HKMyResumePreviewCareerIntentionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.myResumePreviewData = myResumePreviewData;
//        [self setUpUI];
    }
    return self;
}

- (NSArray *)packageData {
    if (self.myResumePreviewData) {
        NSArray *data = @[
                          @{
                              @"期望职位": self.myResumePreviewData.functionsName  ?  self.myResumePreviewData.functionsName : @""
                              },
                          @{
                              @"工作性质": self.myResumePreviewData.workNatureName ?  self.myResumePreviewData.workNatureName : @""
                              },
                          @{
                              @"期望地点": self.myResumePreviewData.placeName ?  self.myResumePreviewData.placeName : @""
                              },
                          @{
                              @"期望月薪": self.myResumePreviewData.salaryName ?  self.myResumePreviewData.salaryName : @""
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
                make.top.equalTo(self.contentView).offset(21);
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
            make.left.equalTo(leftLabel.mas_right).offset(42);
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
