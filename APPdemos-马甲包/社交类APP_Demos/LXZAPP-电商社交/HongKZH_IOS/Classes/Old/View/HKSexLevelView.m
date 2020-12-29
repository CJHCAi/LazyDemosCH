//
//  HKSexLevelView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/9.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSexLevelView.h"

@interface HKSexLevelView ()

@property (nonatomic, strong) UIImageView *sexView;

@property (nonatomic, strong) UILabel *levelLabel;

@end

@implementation HKSexLevelView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpUI];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUpUI];
    }
    return self;
}

- (UIImageView *)sexView {
    if (!_sexView) {
        _sexView = [[UIImageView alloc] init];
    }
    return _sexView;
}

- (UILabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                               textColor:[UIColor whiteColor]
                                           textAlignment:NSTextAlignmentLeft
                                                    font:PingFangSCMedium9
                                                    text:@""
                                              supperView:nil];
    }
    return _levelLabel;
}

- (void)setUpUI {
    //背景圆角
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
   // self.sexView.image = [UIImage imageNamed:@"friend_boyW"];
    [self addSubview:self.sexView];
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexView.mas_right).offset(4);
        make.centerY.equalTo(self);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.levelLabel.mas_right).offset(8);
        make.height.mas_equalTo(13);
    }];
}

- (void)setSex:(NSInteger)sex {
    _sex = sex;
    if (sex == 1) {
        self.backgroundColor =RGB(113,181,252);
        self.sexView.image = [UIImage imageNamed:@"friend_boyW"];
    } else {
        self.backgroundColor = RGB(253,107,133);
        self.sexView.image = [UIImage imageNamed:@"friend_girlW"];
    }
}

- (void)setLevel:(NSString *)level {
    if (level) {
        _level = level;
        self.levelLabel.text = [NSString stringWithFormat:@"ＬV.%@",level];
    }
}


@end
