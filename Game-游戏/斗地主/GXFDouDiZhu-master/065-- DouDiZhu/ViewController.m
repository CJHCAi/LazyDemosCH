//
//  ViewController.m
//  065-- DouDiZhu
//
//  Created by 顾雪飞 on 17/5/23.
//  Copyright © 2017年 顾雪飞. All rights reserved.
//

#import "ViewController.h"
#import "GXFPlayerManager.h"
#import "MainViewController.h"
#import "RangeView.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIButton *startButton;

@property (nonatomic, strong) UIButton *rangeButton;

@property (nonatomic, strong) UIButton *soundButton;

@property (nonatomic, strong) GXFPlayerManager *playerManager;

@property (nonatomic, strong) RangeView *rangeView;

@property (nonatomic, strong) UIView *blackView;

@end

@implementation ViewController

static id _instance;
+ (instancetype)shareVc {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self loadStartView];
    
    [self playMusic];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (self.sign == 1) {
        [self startButtonClick:nil];
    }
}

- (void)loadStartView {
    
    // 背景大图
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 排行榜按钮
    [self.view addSubview:self.rangeButton];
    [self.rangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.view).offset(-40);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(50);
    }];
    
    // 开始按钮
    [self.view addSubview:self.startButton];
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-30);
        make.bottom.equalTo(self.rangeButton.mas_top).offset(-10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(50);
    }];
    
    // 声音按钮
    [self.view addSubview:self.soundButton];
    [_soundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
}

- (void)soundButtonClick:(UIButton *)button {
    
    button.selected = !button.selected;
    
    if (button.selected == YES) {
        [self.playerManager pauseMusic];
    } else {
        [self playMusic];
    }
    
}

- (void)startButtonClick:(UIButton *)button {
    
    // 调到主界面
    CATransition *anim = [CATransition animation];
    
    // `fade', `moveIn', `push' and `reveal'. Defaults to `fade'
    // cube pageCurl pageUnCurl oglFlip suckEffect rippleEffect
    anim.type = @"suckEffect";
    anim.subtype = @"fromRight";
    anim.duration = 1.0;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    MainViewController *mainVc = [[MainViewController alloc] init];
    [mainVc.view.layer addAnimation:anim forKey:nil];
    mainVc.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:mainVc animated:YES completion:^{
        
        
    }];
}

- (void)playMusic {
    
    // 播放声音
    self.playerManager = [GXFPlayerManager new];
    
    [self.playerManager playMusicWithfileName:@"game_music.mp3"];
    
    
}

- (UIImageView *)bgImageView {
    
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"844x1334.jpg"];
    }
    return _bgImageView;
}

- (UIButton *)startButton {
    
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setImage:[UIImage imageNamed:@"start1"] forState:UIControlStateNormal];
        [_startButton setImage:[UIImage imageNamed:@"start2"] forState:UIControlStateHighlighted];
        [_startButton addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UIButton *)rangeButton {
    
    if (!_rangeButton) {
        _rangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rangeButton setImage:[UIImage imageNamed:@"range1"] forState:UIControlStateNormal];
        [_rangeButton setImage:[UIImage imageNamed:@"range2"] forState:UIControlStateHighlighted];
        [_rangeButton addTarget:self action:@selector(rangeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rangeButton;
}

- (void)rangeButtonClick {
    
    // 蒙版
    self.blackView = [UIView new];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.4;
    [self.view addSubview:self.blackView];
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.rangeView = [RangeView new];
    [self.view addSubview:self.rangeView];
    [self.rangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(350);
        make.height.mas_equalTo(250);
    }];
}

- (UIButton *)soundButton {
    
    if (!_soundButton) {
        _soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_soundButton setImage:[UIImage imageNamed:@"musicon"] forState:UIControlStateNormal];
        [_soundButton setImage:[UIImage imageNamed:@"musicoff"] forState:UIControlStateSelected];
        [_soundButton addTarget:self action:@selector(soundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _soundButton;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.rangeView removeFromSuperview];
    [self.blackView removeFromSuperview];
}

- (void)setSign:(NSInteger)sign {
    
    _sign = sign;
}

@end
