//
//  CliffordEndViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/20.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CliffordEndViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CliffordEndViewController()
/** 背景图*/
@property (nonatomic, strong) UIImageView *backIV;
/** 祈福语框*/
@property (nonatomic, strong) UIImageView *cliffordStrIV;
/** 祈福语文本*/
@property (nonatomic, strong) UITextView *cliffordStrTX;
/** 祈福语接收后的弹框*/
@property (nonatomic, strong) UIImageView *endCliffordIV;
/** 音乐播放器*/
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation CliffordEndViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self startMusic];
    [self.view addSubview:self.backIV];
    [self.backIV addSubview:self.cliffordStrIV];
    [self.cliffordStrIV addSubview:self.cliffordStrTX];
    [self.backIV addSubview:self.jossIV];
    [self getCliffordStr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.endCliffordIV) {
            [self endCliffordViewAppear];
        }
    });
}

-(void)startMusic{
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"endqf" withExtension:@"wav"];
    self.player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}


#pragma mark - lazyLoad
-(UIImageView *)backIV{
    if (!_backIV) {
        _backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
        _backIV.image = MImage(@"qf_bg_02");
        _backIV.userInteractionEnabled = YES;
    }
    return _backIV;
}

-(UIImageView *)cliffordStrIV{
    if (!_cliffordStrIV) {
        _cliffordStrIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.1391*CGRectW(self.backIV), 0.6571*CGRectH(self.backIV), 0.725*CGRectW(self.backIV), 0.3187*CGRectH(self.backIV))];
        _cliffordStrIV.image = MImage(@"qfy_kuang");
        _cliffordStrIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endCliffordViewAppear)];
        [_cliffordStrIV addGestureRecognizer:tap];
    }
    return _cliffordStrIV;
}

-(UITextView *)cliffordStrTX{
    if (!_cliffordStrTX) {
        _cliffordStrTX = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, CGRectW(self.cliffordStrIV)-20, CGRectH(self.cliffordStrIV)-20)];
        _cliffordStrTX.backgroundColor = [UIColor clearColor];
        _cliffordStrTX.textColor = [UIColor whiteColor];
        _cliffordStrTX.font = MFont(14);
        _cliffordStrTX.editable = NO;
    }
    return _cliffordStrTX;
}

-(UIImageView *)jossIV{
    if (!_jossIV) {
        _jossIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.28125*CGRectW(self.backIV), 0.1099*CGRectH(self.backIV), 0.4531*CGRectW(self.backIV), 0.4945*CGRectH(self.backIV))];
    }
    return _jossIV;
}

#pragma mark - 网络请求
-(void)getCliffordStr{
    NSDictionary *logDic = @{@"userid":[NSString stringWithFormat:@"%@",GetUserId]};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"getmemqfy" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic[@"data"]);
        if (succe) {
            NSDictionary *dic = [NSDictionary DicWithString:jsonDic[@"data"]];
            
            weakSelf.cliffordStrTX.text = [NSString stringWithFormat:@"佛语：\n\n%@\n\n%@",dic[@"qf1"],dic[@"qf2"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 点击事件
-(void)endCliffordViewAppear{
    self.endCliffordIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.0406*CGRectW(self.backIV), 0.3055*CGRectH(self.backIV), 0.91875*CGRectW(self.backIV), 0.3231*CGRectH(self.backIV))];
    self.endCliffordIV.image = MImage(@"qfy_kuangj");
    self.endCliffordIV.userInteractionEnabled = YES;
    [self.backIV addSubview:self.endCliffordIV];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.1939*CGRectW(self.endCliffordIV), 0.2177*CGRectH(self.endCliffordIV), 0.6020*CGRectW(self.endCliffordIV), 0.1905*CGRectH(self.endCliffordIV))];
    label.text = @"今日虔诚祈福，虔诚度上升10";
    label.font = MFont(12);
    label.textAlignment = NSTextAlignmentCenter;
    [self.endCliffordIV addSubview:label];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.2432*CGRectW(self.endCliffordIV), 0.5272*CGRectH(self.endCliffordIV), 0.2398*CGRectW(self.endCliffordIV), 0.1973*CGRectH(self.endCliffordIV))];
    leftBtn.layer.cornerRadius = 3.0f;
    [leftBtn setTitle:@"返回主页" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = MFont(12);
    leftBtn.backgroundColor = LH_RGBCOLOR(231, 0, 40);
    [leftBtn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [self.endCliffordIV addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.5442*CGRectW(self.endCliffordIV), CGRectY(leftBtn), CGRectW(leftBtn), CGRectH(leftBtn))];
    rightBtn.layer.cornerRadius = 3.0f;
    [rightBtn setTitle:@"留下礼佛" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = MFont(12);
    rightBtn.backgroundColor = LH_RGBCOLOR(75, 88, 91);
    [rightBtn addTarget:self action:@selector(backToPrevious) forControlEvents:UIControlEventTouchUpInside];
    [self.endCliffordIV addSubview:rightBtn];
}

-(void)backToMain{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)backToPrevious{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
