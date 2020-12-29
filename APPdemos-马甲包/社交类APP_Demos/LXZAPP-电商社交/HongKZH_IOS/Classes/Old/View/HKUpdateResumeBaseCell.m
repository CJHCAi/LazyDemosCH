//
//  HKUpdateResumeBaseCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUpdateResumeBaseCell.h"

@interface HKUpdateResumeBaseCell ()



@end

@implementation HKUpdateResumeBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGB(241,241,241);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:containerView];
        self.containerView = containerView;
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        //设置边框阴影
        self.containerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.containerView.layer.shadowOpacity = 0.5;
        self.containerView.layer.shadowOffset = CGSizeMake(1, 1);
        self.containerView.layer.borderWidth = 1.f;
        self.containerView.layer.borderColor = UICOLOR_HEX(0xdddddd).CGColor;
    }
    return self;
}


@end
