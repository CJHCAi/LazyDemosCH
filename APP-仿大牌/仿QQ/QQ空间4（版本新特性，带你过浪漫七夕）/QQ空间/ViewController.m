//
//  ViewController.m
//  QQ空间登录
//
//  Created by 妖精的尾巴 on 15-8-19.
//  Copyright (c) 2015年 妖精的尾巴. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "qqZoneViewController.h"

@interface ViewController ()<UITextFieldDelegate>
/**
 *登录QQ号码密码的输入框
 */
@property(nonatomic,strong)UITextField* qqField;
/**
 *登录QQ号码的输入框
 */
@property(nonatomic,strong)UITextField* qqNumField;
/**
 *登录QQ按钮
 */
@property(nonatomic,strong)UIButton* loginBtn;
/**
 *登录QQ图片imageView
 */
@property(nonatomic,strong)UIImageView* imageView;
/**
 *登录QQ文字图片imageView
 */
@property(nonatomic,strong)UIImageView* qqImageView;
/**
 *用于添加蒙版的按钮
 */
@property(nonatomic,strong)UIButton* coverBtn;
/**
 *缓冲界面（菊花界面）
 */
@property(nonatomic,strong)UIActivityIndicatorView* actIndView;
/**
 *用来模拟根服务器对接的速度（也就是模拟当前网速，本次模拟没有考虑链接失败的情况）
 */
@property(nonatomic,strong)NSTimer* timer;
/**
 *定时器变量
 */
@property(nonatomic,assign)int i;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self createImageView];
    [self createTextField];
    [self creataloginBtn];
    [self createRegisterBtn];
    [self registerQQ];
}
/**
 *把注册后的QQ号传到QQ号码框，密码需要用户自己输入
 */
-(void)registerQQ
{
    NSLog(@"来到了registerQQ这个方法");
    RegisterViewController* qqVc=[[RegisterViewController alloc]init];
    qqVc.block=^(NSString* text){
        self.qqNumField.text=text;
         NSLog(@"传回的QQ号为%@",self.qqNumField.text);
    };
}
/**
 *创建空间背景图片
 */
-(void)createImageView
{
    UIImageView* bgImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login-bg.jpg"]];
    [self.view addSubview:bgImage];
    
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 20, 125, 129)];
    self.imageView.image=[UIImage imageNamed:@"bg_login_logo@2x"];
    [bgImage addSubview:self.imageView];
    
    self.qqImageView =[[UIImageView alloc]initWithFrame:CGRectMake(100, 160, 125, 40)];
    self.qqImageView.image=[UIImage imageNamed:@"bg_login_qzone@2x"];
    [bgImage addSubview:self.qqImageView];
}
/**
 *创建账号密码框
 */
-(void)createTextField
{
    self.qqNumField=[[UITextField alloc]initWithFrame:CGRectMake(15, 210, 292, 44)];
    self.qqNumField.borderStyle=3;
    self.qqNumField.background=[UIImage imageNamed:@"bg_login_top@2x"];
    self.qqNumField.placeholder=@"QQ号";
    self.qqNumField.keyboardType=4;
    self.qqNumField.clearButtonMode= UITextFieldViewModeWhileEditing;
    self.qqNumField.delegate=self;
    [self.view addSubview:self.qqNumField];
    
    self.qqField=[[UITextField alloc]initWithFrame:CGRectMake(15, 252, 292, 44)];
    self.qqField.borderStyle=3;
    self.qqField.keyboardType=4;
    self.qqField.background=[UIImage imageNamed:@"bg_login_bottom@2x"];
    self.qqField.placeholder=@"密码";
    self.qqField.clearButtonMode= UITextFieldViewModeWhileEditing;
    self.qqField.delegate=self;
    self.qqField.secureTextEntry=YES;
    [self.view addSubview:self.qqField];
}
/**
 *创建登录按钮
 */
-(void)creataloginBtn
{
    self.loginBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 320, 292, 40)];
    UIImage* image=[UIImage imageNamed:@"btn_login_login@2x"];
    int leftCap = image.size.width * 0.5;
    int topCap = image.size.height * 0.5;
    UIImage* stretchImage= [image stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
    [self.loginBtn setBackgroundImage:stretchImage forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
}
/**
 *创建注册按钮
 */
-(void)createRegisterBtn
{
    UIButton* registerbtn=[[UIButton alloc]initWithFrame:CGRectMake(110,410, 100, 30)];
    [registerbtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [registerbtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerbtn];
}
/**
 *登录按钮点击事件
 */
-(void)loginBtnClick
{
    [self.qqNumField resignFirstResponder];
    [self.qqField resignFirstResponder];
    NSLog(@"用户点击了登录按钮");
    if (self.qqNumField.text.length==0 && self.qqField.text.length==0)
    {
        UIAlertView* alter=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲，输入你的账号密码就可以登录咯" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alter show];
    }
    else
    {
        if ([self.qqNumField.text isEqualToString:@"2218"]&&[self.qqField.text isEqualToString:@"2218"])
        {
            [self loginSuccess];
        }
        else
        {
            UIAlertView* alter=[[UIAlertView alloc]initWithTitle:@"很抱歉" message:@"亲，你输入的账号或者密码有误" delegate:nil cancelButtonTitle:@"我看一下" otherButtonTitles:@"重新输入", nil];
            [alter show];
        }
    }
}
/**
 *登录成功时候调用该方法
 */
-(void)loginSuccess
{
    self.i++;
    for (int j=0; j<5; j++) {
        NSLog(@"纯粹是为了模拟网速，延长登录时间");
    }
    [self createCoverBtn];
    [self createActivityIndicatorView];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}
/**
 *添加蒙版的按钮方法
 */
-(void)createCoverBtn
{
    self.coverBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.coverBtn.backgroundColor=[UIColor blackColor];
    [self.coverBtn setTitle:@"正在登录中。。。" forState:UIControlStateNormal];
    self.coverBtn.alpha=0.3;
    [self.view addSubview:self.coverBtn];
}
/**
 *添加蒙版时注册时等候界面(菊花界面)
 */
-(void)createActivityIndicatorView
{
    self.actIndView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.actIndView.frame=CGRectMake(140,235,40,40);
    [self.coverBtn addSubview:self.actIndView];
    [self.actIndView startAnimating];
}
/**
 *定时器响应方法
 */
-(void)timerAction:(NSTimer*)timer
{
    NSLog(@"登录控制器正在调用定时器方法");
    self.i++;
    for (int j=0; j<5; j++) {
        NSLog(@"正在登录中");
    }
    if (self.i==5) {
        [timer invalidate];
        timer=nil;
        [self UntilSeccessDone];
        NSLog(@"登录完成");
       }
}
/**
 *登陆成功后调用的方法
 */
-(void)UntilSeccessDone
{
    [self.actIndView stopAnimating];
    [self.coverBtn removeFromSuperview];
    NSLog(@"用户登录成功");
    qqZoneViewController* qqZoneVc=[[qqZoneViewController alloc]init];
    self.view.window.rootViewController=qqZoneVc;
    /**
     *保存用户注册数据到沙盒
     */
#warning 在这里做保存用户登录数据的工作
}
/**
 *注册按钮点击事件
 */
-(void)registerBtnClick
{
    RegisterViewController* registerVc=[[RegisterViewController alloc]init];
    [self presentViewController:registerVc animated:YES completion:^{
        self.qqNumField.text=nil;
        self.qqNumField.text=nil;
    }];
}
/**
 *键盘退下事件的处理
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate代理方法---监听用户输入文字信息
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"调用了textFieldDidBeginEditing--开始编辑");
    [self changeframe];
}
-(void)changeframe
{
    self.imageView.frame=CGRectMake(30, 60, 50,50);
    self.qqImageView.frame=CGRectMake(95, 60, 145, 55);
    self.qqNumField.frame=CGRectMake(15, 142, 292, 44);
    self.qqField.frame=CGRectMake(15, 186, 292, 44);
    self.loginBtn.frame=CGRectMake(15, 240, 292, 40);
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"调用了textFieldDidEndEditing--结束编辑");
    [self resetframe];
}
-(void)resetframe
{
    self.imageView.frame=CGRectMake(100, 20, 125, 129);
    self.qqImageView.frame=CGRectMake(100, 160, 125, 40);
    self.qqNumField.frame=CGRectMake(15, 210, 292, 44);
    self.qqField.frame=CGRectMake(15, 252, 292, 44);
    self.loginBtn.frame=CGRectMake(15, 320, 292, 40);
}
@end
