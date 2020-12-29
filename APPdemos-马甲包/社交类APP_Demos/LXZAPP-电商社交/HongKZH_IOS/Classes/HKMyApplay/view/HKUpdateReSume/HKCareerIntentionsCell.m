//
//  HKCareerIntentionsCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCareerIntentionsCell.h"

@interface HKCareerIntentionsCell ()

@property (nonatomic, weak) UIView *innerView;

@end

@implementation HKCareerIntentionsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier updateResumeBlock:(UpdateResumeBlock)block infoData:(HK_UserRecruitData *) infoData{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.infoData = infoData;
        [self setUpUI];
        self.updateResumeBlock = block;
    }
    return self;
}

+ (instancetype) careerIntentionsCellWithBlock:(UpdateResumeBlock)block infoData:(HK_UserRecruitData *) infoData{
    return [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self) updateResumeBlock:block infoData:infoData];
}

-(UIView *)innerView {
    if (_innerView == nil) {
        UIView *innerView = [[UIView alloc] init];
        [self.containerView addSubview:innerView];
        self.innerView = innerView;
    }
    return _innerView;
}

- (void)setUpUI {
    
    [self.innerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(16);
        make.top.equalTo(self.containerView).offset(19);
        make.bottom.equalTo(self.containerView).offset(-19);
        make.right.equalTo(self.containerView).offset(-44);
    }];
    
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
                              font:PingFangSCRegular14
                              text:key supperView:self.innerView];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.innerView);
            if (i == 0) {
                make.top.equalTo(self.innerView);
            } else {
                make.top.equalTo(lastLabel.mas_bottom).offset(15);
            }
            make.height.mas_equalTo(14);
        }];
        lastLabel = leftLabel;
        
        //右侧 label
        UILabel *rightLabel = [HKComponentFactory
                              labelWithFrame:CGRectZero
                              textColor:UICOLOR_HEX(0x666666)
                              textAlignment:NSTextAlignmentLeft
                              font:PingFangSCRegular14
                              text:value supperView:self.innerView];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.mas_right);
            make.height.mas_equalTo(14);
            make.centerY.equalTo(leftLabel);
        }];
    }
    
    //修改 button
    UIButton *editButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                        frame:CGRectZero
                                                        taget:self
                                                       action:@selector(buttonClick) supperView:self.containerView];
    [editButton setImage:[UIImage imageNamed:@"bianji2s"] forState:UIControlStateNormal];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.top.equalTo(self.containerView).offset(10);
        make.right.equalTo(self.containerView).offset(-10);
    }];
}

- (void)buttonClick {
    if(self.updateResumeBlock) {
        self.updateResumeBlock();
    }
}

- (NSArray *)packageData {
    if (self.infoData) {
        NSArray *data = @[
                          @{
                              @"期望职位：": self.infoData.functionsName  ?  self.infoData.functionsName : @""
                              },
                          @{
                              @"期望月薪：": self.infoData.salaryName ?  self.infoData.salaryName : @""
                              },
                          @{
                              @"期望地点：": self.infoData.placeName ?  self.infoData.placeName : @""
                              },
                          @{
                              @"工作性质：": self.infoData.workNatureName ?  self.infoData.workNatureName : @""
                              },
                          @{
                              @"当前状态：": self.infoData.stateName ?  self.infoData.stateName : @""
                              }
                          ];
        return data;
    }
    return nil;
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
