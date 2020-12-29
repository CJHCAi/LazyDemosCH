//
//  HKResumeCompletionCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKResumeCompletionCell.h"
@interface HKResumeCompletionCell ()

@property (nonatomic, weak) UILabel *tipLabel;

@end

@implementation HKResumeCompletionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *tipLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                     textColor:RGB(244,72,52)
                                                 textAlignment:NSTextAlignmentLeft
                                                          font:[UIFont fontWithName:PingFangSCRegular size:11]
                                                          text:@"请完善信息"
                                                    supperView:self.contentView];
        self.tipLabel = tipLabel;

        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.textLabel);
            make.left.equalTo(self.textLabel.mas_right).offset(5);
        }];

        self.textLabel.font = [UIFont fontWithName:PingFangSCRegular size:14];
        self.textLabel.textColor = RGB(102,102,102);
        
        self.detailTextLabel.font = [UIFont fontWithName:PingFangSCRegular size:14];
        self.detailTextLabel.textColor = RGB(153,153,153);
        
        self.textLabel.text = @"简历";
        if (self.complete) {
            self.detailTextLabel.text = [NSString stringWithFormat:@"完整度：%@%%",self.complete];
        }
    }
    return self;
}

- (void)setComplete:(NSString *)complete {
    if (complete) {
        _complete = complete;
        self.detailTextLabel.text = self.detailTextLabel.text = [NSString stringWithFormat:@"完整度：%@",self.complete];
        if ([complete isEqualToString:@"100%"]) {
            self.tipLabel.hidden = YES;
        } else {
            self.tipLabel.hidden = NO;
        }
    }
}

@end
