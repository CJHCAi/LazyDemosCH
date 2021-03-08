//
//  ViewController.m
//  HLAlertView
//
//  Created by benjaminlmz@qq.com on 2020/4/29.
//  Copyright © 2020 Tony. All rights reserved.
//

#import "ViewController.h"
#import "HLAlertView.h"

@interface ViewController ()
{
    HMLabel *hMLable;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"密码验证" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(encrytionAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 200, 30)];
    btn2.titleLabel.textColor = [UIColor blackColor];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"更新App弹框" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(upgradeAppAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 30)];
    btn3.titleLabel.textColor = [UIColor blackColor];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 setTitle:@"打开微信弹框" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(openWeChatAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(100, 250, 200, 30)];
    btn4.titleLabel.textColor = [UIColor blackColor];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn4 setTitle:@"强制退出登录" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(forceLoginOutAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];

    UIButton *btn5 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 200, 30)];
    btn5.titleLabel.textColor = [UIColor blackColor];
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn5 setTitle:@"设置密码提示" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(encrytionTipsAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
    UIButton *btn6 = [[UIButton alloc] initWithFrame:CGRectMake(100, 350, 200, 30)];
    btn6.titleLabel.textColor = [UIColor blackColor];
    [btn6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn6 setTitle:@"测试" forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn6];
    
}

- (void)openWeChatAlert {
     HLAlertView *alert = [HLAlertView alertWithTitle:nil message:nil];


    HLLabel *la = [HLLabel labelWithTitle:@"”XXXXX”想要打开“微信”" block:^(Constraint * _Nonnull constraint, HLLabelModel * _Nonnull labelModel) {
        constraint.top = 20;
        constraint.bottom = 20;
        constraint.height = 30;
        labelModel.textFont = [UIFont fontWithName:@"STXihei" size:13];
    }];
    
    [alert addLabel:la];

     HLAction *action2 = [HLAction actionWithTitle:@"取消" handler:^(HLAction * _Nonnull action) {
         [HLAlertView dismiss];
     }];
     [alert addAciton:action2];
     HLAction *action = [HLAction actionWithTitle:@"打开" handler:^(HLAction * _Nonnull action) {
         [HLAlertView dismiss];
     }];
     [alert addAciton:action];
     alert.shadowAction = NO;
     [HLAlertView show];
}
- (void)forceLoginOutAlert {
    HLAlertView *alert = [HLAlertView alertWithTitle:nil message:nil];
    
    HLLabel *la = [HLLabel labelWithTitle:@"提示" block:^(Constraint * _Nonnull constraint, HLLabelModel * _Nonnull labelModel) {
        constraint.top = 15;
        constraint.height = 30;
        labelModel.textFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    }];
    [alert addLabel:la];
    
    HLLabel *la2 = [HLLabel labelWithTitle:@"您的账号在另一台设备中被更换，请重新登录" block:^(Constraint * _Nonnull constraint, HLLabelModel * _Nonnull labelModel) {
        constraint.top = 15;
        constraint.height = 40;
        constraint.left = 15;
        constraint.right = -15;
        constraint.bottom = 15;
        labelModel.textAlignment = NSTextAlignmentLeft;
        labelModel.textFont = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    }];
    [alert addLabel:la2];

    HLAction *action = [HLAction actionWithTitle:@"退出" handler:^(HLAction * _Nonnull action) {
        [HLAlertView dismiss];
    }];
    [alert addAciton:action];
    alert.shadowAction = NO;
    [HLAlertView show];
}
- (void)encrytionAlert {
    HLAlertView *alert = [HLAlertView alertWithTitle:nil message:nil];
    
    HLLabel *la = [HLLabel labelWithTitle:@"请输入视频图片加密密码" block:^(Constraint * _Nonnull constraint, HLLabelModel * _Nonnull labelModel) {
        constraint.left = 15;
        constraint.right = -15;
        constraint.bottom = 5;
        constraint.height = 30;
        labelModel.textFont = [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
    }];
    [alert addLabel:la];

    HLLabel *la1 = [HLLabel labelWithTitle:@"视频已被加密，请您输入密码验证解密" block:^(Constraint * _Nonnull constraint, HLLabelModel * _Nonnull labelModel) {
        constraint.left = 15;
        constraint.right = -15;
        constraint.bottom = 5;
        constraint.height = 30;
        labelModel.textFont = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    }];
    [alert addLabel:la1];
      
    [alert addTextFieldWithConfigurationHandler:^(HLTextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
    }];

    HLLabel *la2 = [HLLabel labelWithTitle:@"输入验证码不正确" block:^(Constraint * _Nonnull constraint, HLLabelModel * _Nonnull labelModel) {
        constraint.top = 5;
        constraint.left = 15;
        constraint.right = -15;
        constraint.bottom = 2;
        constraint.height = 20;
        labelModel.textAlignment = NSTextAlignmentLeft;
        labelModel.textColor = [UIColor redColor];
        labelModel.textFont = [UIFont systemFontOfSize:12];
    }];
    [alert addLabel:la2];
    [la2 hide:YES];
    HLAction *action2 = [HLAction actionWithTitle:@"取消" handler:^(HLAction * _Nonnull action) {
        [HLAlertView dismiss];
    }];
    [alert addAciton:action2];
    HLAction *action = [HLAction actionWithTitle:@"确定" handler:^(HLAction * _Nonnull action) {
        [la2 hide:NO];
    }];
    [alert addAciton:action];
    alert.shadowAction = NO;
    [HLAlertView show];
}

//视频加密提示框
- (void)encrytionTipsAlert {
    HLAlertView *alert = [HLAlertView alertWithTitle:nil message:nil];
    
    
    HLLabel *la = [HLLabel labelWithTitle:@"视频加密" block:^(Constraint * _Nonnull constraint, HLLabelModel * _Nonnull labelModel) {
        labelModel.textFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        constraint.top = 15;
        constraint.bottom = 10;
        constraint.left = 15.5;
        constraint.right = -15.5;
        constraint.height = 30;
    }];
    [alert addLabel:la];

    NSString *title = @"为了保障您的信息及数据安全，开启视频加密功能后，我们会对产生的视频及图像进行加密。\n(1) 初始密码为xxxxxx\n(2) 修改密码后，视频和图片将采用新密码加密，修改密码前的录像与图片仍需要使用旧密码进行查看。\n(3) 请牢记您的密码，若密码丢失，只能重置为原始密码，查看由原始密码加密的数据";
    HMLabel *lav = [HMLabel labelWithTitle:title block:^(Constraint * _Nonnull constraint, HLTextModel * _Nonnull textModel) {
        constraint.top = 15;
        constraint.bottom = 10;
        constraint.left = 15.5;
        constraint.right = -15.5;
        constraint.height = 190;
        textModel.textFont = [UIFont systemFontOfSize:15];
        textModel.textColor = [UIColor orangeColor];
        textModel.textAlignment = NSTextAlignmentLeft;
        textModel.scrollEnable = YES;
    }];
    [alert addLabel:lav];
      
    HLButton *hlButton = [HLButton buttonWithTitle:@"我知道了" block:^(Constraint * _Nonnull constraint, HLButtonModel * _Nonnull buttonModel) {
        constraint.top = 30;
        constraint.left = 30;
        constraint.right = -30;
        constraint.height = 40;
        constraint.bottom = 0;
        
        buttonModel.textColor = [UIColor whiteColor];
        buttonModel.normalColor = [UIColor colorWithRed:73.0f/255.0f green:166.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
        buttonModel.highlightedColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.4 alpha:1];
        buttonModel.cornerRadius = 20;
        buttonModel.maskToBounds = YES;
        
    } handler:^(HLButton * _Nonnull action) {
        NSLog(@"");
        [HLAlertView dismiss];
    }];
    
    [alert addButton:hlButton];

    alert.shadowAction = YES;
    [HLAlertView show];
}

//更新弹框
- (void)upgradeAppAlert {
    HLAlertView *alert = [HLAlertView alertWithTitle:nil message:nil];
    
    HLImageView *imagev = [HLImageView imageViewWithImage:[UIImage imageNamed:@"set_firmware_img_upgrade"] block:^(Constraint * _Nonnull constraint, HLImageViewModel * _Nonnull imageModel) {
        constraint.top = 0;
        constraint.left = 0;
        constraint.right = 0;
        constraint.height = 120;
    }];
    [alert addImageView:imagev];
    
    HLLabel *la = [HLLabel labelWithTitle:@"1、Lorem ipsum dolor sit amet, consectetur adipiscing elit." block:^(Constraint * _Nonnull constraint, HLLabelModel * _Nonnull labelModel) {
        constraint.top = 15;
        constraint.bottom = 10;
        constraint.left = 20;
        constraint.right = -15.5;
        constraint.height = 50;
        labelModel.textFont = [UIFont fontWithName:@"PingFang-SC-Regular" size:13.0f];
        labelModel.textAlignment = NSTextAlignmentLeft;
    }];
    [alert addLabel:la];

    HLLabel *lax = [HLLabel labelWithTitle:@"2、Lorem ipsum dolor sit amet, consectetur adipiscing elit." block:^(Constraint * _Nonnull constraint, HLLabelModel * _Nonnull labelModel) {
        constraint.top = 15;
        constraint.bottom = 10;
        constraint.left = 20;
        constraint.right = -15.5;
        constraint.height = 50;
        labelModel.textFont = [UIFont fontWithName:@"PingFang-SC-Regular" size:13.0f];
        labelModel.textAlignment = NSTextAlignmentLeft;
        labelModel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    }];
    [alert addLabel:lax];
   
    HLAction *action2 = [HLAction actionWithTitle:@"拒绝" handler:^(HLAction * _Nonnull action) {
        [HLAlertView dismiss];
    }];
    [alert addAciton:action2];
    HLAction *action = [HLAction actionWithTitle:@"立即更新" handler:^(HLAction * _Nonnull action) {
        [HLAlertView dismiss];
    }];
    [alert addAciton:action];

    HLAction *action3 = [HLAction actionWithTitle:@"更新" handler:^(HLAction * _Nonnull action) {
        [HLAlertView dismiss];
    }];
    [alert addAciton:action3];
    alert.shadowAction = NO;
//    [alert alertSize:CGSizeMake(260, 315)];
    
    
    [HLAlertView show];
    
    
}



- (void)alert {
    HLAlertView *alert = [HLAlertView alertWithTitle:@"测试" message:nil];
    NSString *title = @"测试测试测试测试测试测试测试测试 测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试\n测试测试测试测试测试测试测试";
    HMLabel *lav = [HMLabel labelWithTitle:title block:^(Constraint * _Nonnull constraint, HLTextModel * _Nonnull textModel) {
        constraint.top = 15;
        constraint.bottom = 10;
        constraint.left = 15.5;
        constraint.right = -15.5;
        constraint.height = 190;
        
        textModel.textFont = [UIFont systemFontOfSize:15];
        textModel.textColor = [UIColor orangeColor];
        textModel.textAlignment = NSTextAlignmentLeft;
        textModel.scrollEnable = NO;
    }];
    [alert addLabel:lav];
    alert.shadowAction = YES;
    
    [HLAlertView show];
}


- (void)dealloc {
    NSLog(@"");
}
@end
