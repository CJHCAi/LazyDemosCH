//
//  loginViewController.m
//  SuperDirvers
//
//  Created by 王俊钢 on 2017/2/20.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "loginViewController.h"
#import "logupViewController.h"
@interface loginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UIImageView *bgimg;
@property (nonatomic,strong) UIButton *denglubtn;
@property (nonatomic,strong) UIButton *zucebtn;
@property (nonatomic,strong) UITextField *text1;
@property (nonatomic,strong) UITextField *text2;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.bgimg];
    
    [self.view addSubview:self.denglubtn];
    [self.view addSubview:self.zucebtn];
    
    [self.view addSubview:self.text1];
    [self.view addSubview:self.text2];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.text1.frame = CGRectMake(DEVICE_WIDTH/2-100, 150, 200, 40);
    self.text2.frame = CGRectMake(DEVICE_WIDTH/2-100, 200, 200, 40);
    self.denglubtn.frame = CGRectMake(DEVICE_WIDTH/2-80, DEVICE_HEIGHT/2, 160, 40);
    self.zucebtn.frame = CGRectMake(DEVICE_WIDTH/2-80, DEVICE_HEIGHT/2+80, 160, 40);
}

#pragma mark - getters

-(UIImageView *)bgimg
{
    if(!_bgimg)
    {
        _bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        _bgimg.image = [UIImage imageNamed:@"lgbg"];
    }
    return _bgimg;
}

-(UIButton *)denglubtn
{
    if(!_denglubtn)
    {
        _denglubtn = [[UIButton alloc] init];
        [_denglubtn setTitle:@"登录" forState:normal];
        [_denglubtn setTitleColor:[UIColor whiteColor] forState:normal];
        _denglubtn.layer.masksToBounds = YES;
        _denglubtn.layer.borderWidth = 2;
        _denglubtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _denglubtn.layer.cornerRadius = 10;
        [_denglubtn addTarget:self action:@selector(denglubtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _denglubtn;
}

-(UIButton *)zucebtn
{
    if(!_zucebtn)
    {
        _zucebtn = [[UIButton alloc] init];
        [_zucebtn addTarget:self action:@selector(zucebtnclick) forControlEvents:UIControlEventTouchUpInside];
        [_zucebtn setTitle:@"注册" forState:normal];
        [_zucebtn setTitleColor:[UIColor whiteColor] forState:normal];
        _zucebtn.layer.masksToBounds = YES;
        _zucebtn.layer.borderWidth = 2;
        _zucebtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _zucebtn.layer.cornerRadius = 10;
    }
    return _zucebtn;
}

-(UITextField *)text1
{
    if(!_text1)
    {
        _text1 = [[UITextField alloc] init];
        _text1.delegate = self;
        _text1.placeholder = @"请输入手机号";
        _text1.layer.masksToBounds = YES;
        _text1.layer.borderWidth = 1;
        _text1.backgroundColor = [UIColor whiteColor];
        _text1.layer.cornerRadius = 5;
    }
    return _text1;
}

-(UITextField *)text2
{
    if(!_text2)
    {
        _text2 = [[UITextField alloc] init];
        _text2.delegate = self;
        _text2.placeholder = @"请输入密码";
        _text2.layer.masksToBounds = YES;
        _text2.layer.borderWidth = 1;
        _text2.backgroundColor = [UIColor whiteColor];
        _text2.layer.cornerRadius = 5;
    }
    return _text2;
}

#pragma mark - 实现方法

-(void)denglubtnclick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)zucebtnclick
{
    NSLog(@"注册");
    logupViewController *logupVC = [[logupViewController alloc] init];
    [self presentViewController:logupVC animated:YES completion:^{
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    [self.text1 resignFirstResponder];
    [self.text2 resignFirstResponder];
}
@end
