//
//  SettingView.m
//  065-- DouDiZhu
//
//  Created by 顾雪飞 on 17/5/23.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "SettingView.h"

#define ZHENISON @"ZHENISON"

@interface SettingView ()

@property (nonatomic, strong) UIImageView *musicProView;

@property (nonatomic, strong) UIImageView *yinxiaoProView;

@property (nonatomic, strong) UIImageView *greenView1;

@property (nonatomic, strong) UIImageView *greenView2;

@property (nonatomic, strong) UIImageView *yellowRound1;

@property (nonatomic, strong) UIImageView *yellowRound2;

@property (nonatomic, strong) UIButton *zhenButtonOff;

@property (nonatomic, strong) UIButton *zhenButtonOn;

@property (nonatomic, strong) UIImageView *blueRound;

@property (nonatomic, assign) BOOL zhenIsOn;

@end

@implementation SettingView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"settingbg"];
        
        // 关闭按钮
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"settingclose1"] forState:UIControlStateNormal];
        [closeButton setImage:[UIImage imageNamed:@"settingclose2"] forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.width.height.mas_equalTo(40);
        }];
        
        // 返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"settingback"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClcik) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.bottom.equalTo(self).offset(-20);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(35);
        }];
        
        // 音乐进度
        [self addSubview:self.musicProView];
        [self.musicProView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(75);
            make.top.equalTo(self).offset(65);
            make.width.mas_equalTo(195);
            make.height.mas_equalTo(11);
        }];
        
        // 音效进度
        [self addSubview:self.yinxiaoProView];
        [self.yinxiaoProView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.right.equalTo(self.musicProView);
            make.top.equalTo(self.musicProView.mas_bottom).offset(26);
        }];
        
        // 震动
        [self addSubview:self.zhenButtonOff];
        [self.zhenButtonOff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.yinxiaoProView);
            make.top.equalTo(self.yinxiaoProView.mas_bottom).offset(24);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(22);
        }];
        
        
    }
    return self;
}

- (void)backButtonClcik {
    
    // 通知MainVC
    if ([self.delegate respondsToSelector:@selector(settingView:didClickBackButton:)]) {
        [self.delegate settingView:self didClickBackButton:nil];
    }
}

- (void)closeButtonClick {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
}

- (UIImageView *)musicProView {
    
    if (!_musicProView) {
        _musicProView = [UIImageView new];
        _musicProView.image = [UIImage imageNamed:@"settingjindu1"];
        
        // 绿色条
        self.greenView1 = [UIImageView new];
        self.greenView1.image = [UIImage imageNamed:@"settingjindu2"];
        [_musicProView addSubview:self.greenView1];
        
        // 黄色圆
        self.yellowRound1 = [UIImageView new];
        self.yellowRound1.image = [UIImage imageNamed:@"settingjinduyuan"];
        [_musicProView addSubview:self.yellowRound1];
    }
    return _musicProView;
}

- (UIImageView *)yinxiaoProView {
    
    if (!_yinxiaoProView) {
        _yinxiaoProView = [UIImageView new];
        _yinxiaoProView.image = [UIImage imageNamed:@"settingjindu1"];
        
        // 绿色条
        self.greenView2 = [UIImageView new];
        self.greenView2.image = [UIImage imageNamed:@"settingjindu2"];
        [_yinxiaoProView addSubview:self.greenView2];
        
        // 黄色圆
        self.yellowRound2 = [UIImageView new];
        self.yellowRound2.image = [UIImage imageNamed:@"settingjinduyuan"];
        [_yinxiaoProView addSubview:self.yellowRound2];
        
    }
    return _yinxiaoProView;
}

- (UIButton *)zhenButtonOff {
    
    if (!_zhenButtonOff) {
        _zhenButtonOff = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zhenButtonOff setImage:[UIImage imageNamed:@"settingoff"] forState:UIControlStateNormal];
        [_zhenButtonOff addTarget:self action:@selector(offClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // on
        self.zhenButtonOn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.zhenButtonOn setImage:[UIImage imageNamed:@"settingon"] forState:UIControlStateNormal];
        [_zhenButtonOff addSubview:self.zhenButtonOn];
        [self.zhenButtonOn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.zhenButtonOn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_zhenButtonOff);
        }];
        
        // 蓝圆
        [_zhenButtonOff addSubview:self.blueRound];
        [self.blueRound mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_zhenButtonOff).offset(2);
            make.centerY.equalTo(_zhenButtonOff);
            make.width.mas_equalTo(28);
            make.height.mas_equalTo(26);
        }];
        
    }
    return _zhenButtonOff;
}

- (UIImageView *)blueRound {
    
    if (!_blueRound) {
        _blueRound = [UIImageView new];
        _blueRound.image = [UIImage imageNamed:@"settingstate"];
        _blueRound.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blueRoundTap:)];
        [_blueRound addGestureRecognizer:tap];
    }
    return _blueRound;
}

- (void)offClick:(UIButton *)button {
    
    // 改变值并归档
    self.zhenIsOn = YES;
    [self saveZhenState:self.zhenIsOn forKey:ZHENISON];
    
    // 显示on
    self.zhenButtonOn.hidden = NO;
    
    // 改变蓝圆位置
    [self.blueRound mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.zhenButtonOff.mas_left).offset(self.zhenButtonOff.bounds.size.width + 2);
    }];
    
}

- (void)onClick:(UIButton *)button {
    
    // 改变值并归档
    self.zhenIsOn = NO;
    [self saveZhenState:self.zhenIsOn forKey:ZHENISON];
    
    // 隐藏on
    self.zhenButtonOn.hidden = YES;
    
    // 改变蓝圆位置
#warning 这里的28不能用self.blueRound.bounds.size.width
    [self.blueRound mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.zhenButtonOff.mas_left).offset(28 - 2);
    }];
}

- (void)blueRoundTap:(UITapGestureRecognizer *)tap {
    
    // 判断blueBound位置，分情况调方法
    GXFLog(@"%f", self.blueRound.frame.origin.x);
    
    if (self.blueRound.frame.origin.x > 0) {
        [self onClick:nil];
        
    } else {
        [self offClick:nil];
    }
    
}

// 偏好设置归档
- (void)saveZhenState:(BOOL )state forKey:(NSString *)key {
    
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 偏好设置解档
- (BOOL)getValueWithKey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.greenView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.musicProView);
        make.width.mas_equalTo(self.musicProView.bounds.size.width * 0.5);
    }];
    [self.greenView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.yinxiaoProView);
        make.width.mas_equalTo(self.yinxiaoProView.bounds.size.width * 0.5);
    }];
    
    [self.yellowRound1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.musicProView);
        make.width.height.mas_equalTo(23);
    }];
    [self.yellowRound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.yinxiaoProView);
        make.width.height.mas_equalTo(23);
    }];
    
    // 解档zhenIsOn，并改变震动的布局
    self.zhenIsOn = [self getValueWithKey:ZHENISON];
    if (self.zhenIsOn) {
        GXFLog(@"iiiiiii");
                    [self offClick:nil];
        
        //            return self;
    } else {
        GXFLog(@"hhhhhhh");
                    [self onClick:nil];
    }
}

@end
