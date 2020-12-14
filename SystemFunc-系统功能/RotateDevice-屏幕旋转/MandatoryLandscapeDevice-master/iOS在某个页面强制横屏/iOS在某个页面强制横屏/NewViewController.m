//
//  NewViewController.m
//  iOS在某个页面强制横屏
//
//  Created by Mac on 2020/5/11.
//  Copyright © 2020 Mac. All rights reserved.
//

//#define KASORIENTATION   @"orientation"

#import "AppDelegate.h"
#import "UIDevice+ASMandatoryLandscapeDevice.h"

#import "NewViewController.h"

@interface NewViewController ()

@property (nonatomic, strong) UIImageView * mainBGVImageView;
@property (nonatomic, strong) UIButton * backButton;

@end

@implementation NewViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 打开横屏开关
    appDelegate.allowRotation = YES;
    // 调用转屏代码
    [UIDevice deviceMandatoryLandscapeWithNewOrientation:UIInterfaceOrientationLandscapeRight];
    
    
    [self setupUI];
}

- (void)setupUI {
    
    [self.view addSubview:self.mainBGVImageView];
    self.mainBGVImageView.frame = self.view.bounds;
    
    [self.view addSubview:self.backButton];
    self.backButton.frame = CGRectMake(20, 20, 104, 44);
}

- (void)backButtonAction {
    
    [self backClickForPushVCAction];
}

/// push控制器：
- (void)backClickForPushVCAction {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 关闭横屏仅允许竖屏
    appDelegate.allowRotation = NO;
    // 切换到竖屏
    [UIDevice deviceMandatoryLandscapeWithNewOrientation:UIInterfaceOrientationPortrait];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)mainBGVImageView {
    if (!_mainBGVImageView) {
        _mainBGVImageView = [[UIImageView alloc] init];
        _mainBGVImageView.image = [UIImage imageNamed:@"Img_17"];
        _mainBGVImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _mainBGVImageView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setTitle:@"Back" forState:UIControlStateNormal];
        _backButton.backgroundColor = [UIColor blueColor];
        _backButton.layer.cornerRadius = 22;
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}



@end
