//
//  HKResumeOpenwCell.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKResumeOpenwCell.h"

@interface HKResumeOpenwCell ()

@property (nonatomic, weak) UISwitch *switchView;
@property (nonatomic, weak) UILabel *tipLabel;

@end

@implementation HKResumeOpenwCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.text = @"是否开放";
        self.textLabel.font = PingFangSCRegular14;
        self.textLabel.textColor = RGB(102,102,102);
        
        UISwitch *switchView = [[UISwitch alloc] init];
        [switchView addTarget:self action:@selector(switchViewClick) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:switchView];
        self.switchView = switchView;
        [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-11);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(41);
            make.height.mas_equalTo(29);
        }];
        
        UILabel *tipLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                     textColor:RGB(102,102,102) textAlignment:NSTextAlignmentRight font:PingFangSCRegular14 text:@"不公开" supperView:self.contentView];
        self.tipLabel = tipLabel;
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.switchView.mas_left).offset(-12);
        }];
        
    }
    return self;
}

- (void)switchViewClick {
     DLog(@"22222");
  //  self.switchView.on = !self.switchView.on;
    if (self.switchView.isOn) {
         DLog(@"shi");
        self.tipLabel.text = @"公开";
    } else {
         DLog(@"bushi");
        self.tipLabel.text = @"不公开";
    }
    if (self.block) {
        
        self.block(self.switchView.isOn);
    }
}

- (void)setOpen:(BOOL)open {
    DLog(@"几次");
    _open = open;
    self.switchView.on = open;
    if (open) {
        self.tipLabel.text = @"公开";
    } else {
        self.tipLabel.text = @"不公开";
    }
}


@end
