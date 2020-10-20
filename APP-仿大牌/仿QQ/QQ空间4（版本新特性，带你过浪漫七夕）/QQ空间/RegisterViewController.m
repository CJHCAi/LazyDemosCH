//
//  RegisterViewController.m
//  QQ空间登录
//
//  Created by 妖精的尾巴 on 15-8-19.
//  Copyright (c) 2015年 妖精的尾巴. All rights reserved.
//

#import "RegisterViewController.h"
#import "ViewController.h"

@interface RegisterViewController ()
/**
 *顶部半透明label
 */
@property(nonatomic,strong)UILabel* topLabel;
/**
 *QQ号label
 */
@property(nonatomic,strong)UILabel* qqLabel;
/**
 *QQ密码label
 */
@property(nonatomic,strong)UILabel* pswLabel;
/**
 *顶部右边关闭按钮
 */
@property(nonatomic,strong)UIButton* closeBtn;
/**
 *顶部左边导航按钮
 */
@property(nonatomic,strong)UIButton* navgationBtn;
/**
 *底部注册按钮
 */
@property(nonatomic,strong)UIButton* registerBtn;
/**
 *注册QQ号UITextField
 */
@property(nonatomic,strong)UITextField* registerQQField;
/**
 *注册QQ号密码UITextField
 */
@property(nonatomic,strong)UITextField* registerQQPswField;
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
@property(nonatomic,assign)int j;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    [self createBackgroundImage];
    [self createLabel];
    [self createCloseBtn];
    [self createTextfield];
    [self createRegisterBtn];
}
-(void)createBackgroundImage
{
    UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    imageView.image=[UIImage imageNamed:@"10.png"];
    [self.view addSubview:imageView];
    
}
-(void)createLabel
{
    /**
     *创建顶部的label
     */
    self.topLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 66)];
    self.topLabel.userInteractionEnabled=YES;
    self.topLabel.alpha=0.4;
    self.topLabel.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:self.topLabel];
    
    /**
     *创建QQ号label
     */
    self.qqLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 100, 60, 30)];
    self.qqLabel.text=@"QQ号";
    [self.view addSubview:self.qqLabel];
    
    /**
     *创建QQ密码label
     */
    self.pswLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 140, 60, 30)];
    self.pswLabel.text=@"密码";
    [self.view addSubview:self.pswLabel];
}
-(void)createTextfield
{
    /**
     *注册QQ号UITextField
     */
    self.registerQQField=[[UITextField alloc]initWithFrame:CGRectMake(75, 100, 210, 30)];
    self.registerQQField.keyboardType=UIKeyboardTypeNumberPad;
    self.registerQQField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.registerQQField.background=[UIImage imageNamed:@"bg_login_top@2x"];
    self.registerQQField.borderStyle=3;
    [self.view addSubview:self.registerQQField];
    
    /**
     *注册QQ号密码UITextField
     */
    self.registerQQPswField=[[UITextField alloc]initWithFrame:CGRectMake(75, 135, 210, 30)];
    self.registerQQPswField.keyboardType=UIKeyboardTypeNumberPad;
    self.registerQQPswField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.registerQQPswField.background=[UIImage imageNamed:@"bg_login_bottom@2x"];
    self.registerQQPswField.background=[UIImage imageNamed:@"bg_login_top@2x"];
    self.registerQQPswField.borderStyle=3;
    self.registerQQPswField.secureTextEntry=YES;
    [self.view addSubview:self.registerQQPswField];
}
/**
 *创建注册按钮
 */
-(void)createRegisterBtn
{
   self.registerBtn=[[UIButton alloc]initWithFrame:CGRectMake(30,190, 270, 30)];
    [self.registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    /**
     *该段代码注释掉得原因是：添加了背景图片，和该按钮的背景色冲突了
     *
     *所以去掉了这段代码
     */
//    UIImage* image=[UIImage imageNamed:@"btn_login_login@2x"];
//    int leftCap = image.size.width * 0.5;
//    int topCap = image.size.height * 0.5;
//    UIImage* stretchImage= [image stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
//    [self.registerBtn setBackgroundImage:stretchImage forState:UIControlStateNormal];

    [self.view addSubview:self.registerBtn];
}
/**
 *创建顶部两个按钮
 */
-(void)createCloseBtn
{
    /**
     *创建右边的关闭按钮
     */
    self.closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(265, 25, 30, 30)];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"preview_close_single@2x"] forState:UIControlStateNormal];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"preview_close_single_pressed@2x"] forState:UIControlStateHighlighted];
    [self.closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.topLabel addSubview:self.closeBtn];
    
    /**
     *创建左边导航按钮
     */
    self.navgationBtn=[[UIButton alloc]initWithFrame:CGRectMake(13, 25, 30, 30)];
    [self.navgationBtn setBackgroundImage:[UIImage imageNamed:@"back_iphone5"] forState:UIControlStateNormal];
    [self.navgationBtn addTarget:self action:@selector(backToViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.topLabel addSubview:self.navgationBtn];
}
/**
 *注册按钮点击事件方法
 */
-(void)registerBtnClick
{
    
    if (self.registerQQField.text.length==0 && self.registerQQPswField.text.length==0)
    {
        UIAlertView* alter=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲，你还没注册哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alter show];
    }
    else
    {
        if (self.registerQQField.text.length!=0 && self.registerQQPswField.text.length!=0)
        {
            [self.registerQQField resignFirstResponder];
            [self.registerQQPswField resignFirstResponder];
            [self.registerBtn setTitle:@"正在注册中。。。请稍后" forState:UIControlStateNormal];
            //创建蒙版
            [self createCoverBtn];
            //添加菊花
            [self createActivityIndicatorView];
#warning block回调不成功，暂时没找出原因
            if (_block) {
                NSLog(@"回调block传值");
                _block(self.registerQQField.text);
            }
            NSLog(@"block没有被调用");
            self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        }
        else
        {
            UIAlertView* alter=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲，你还没注册完成哦" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:@"我再试试", nil];
            [alter show];
        }
    }
}
/**
 *添加蒙版的按钮方法
 */
-(void)createCoverBtn
{
    self.coverBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.coverBtn.backgroundColor=[UIColor blackColor];
    self.coverBtn.alpha=0.3;
    [self.view addSubview:self.coverBtn];
}
/**
 *添加蒙版时注册时等候界面(菊花界面)
 */
-(void)createActivityIndicatorView
{
    self.actIndView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.actIndView.frame=CGRectMake(140,240,40,40);
    [self.coverBtn addSubview:self.actIndView];
    [self.actIndView startAnimating];
}
/**
 *定时器响应方法
 */
-(void)timerAction:(NSTimer*)timer
{
    NSLog(@"注册控制器正在调用定时器方法");
    self.j++;
    for (int i=0; i<7; i++) {
        NSLog(@"正在注册中");
    }
    if (self.j==7) {
        [self.actIndView stopAnimating];
        [self.coverBtn removeFromSuperview];
        [self.registerBtn setTitle:@"^_^恭喜你，注册成功！" forState:UIControlStateNormal];
        [timer invalidate];
        timer=nil;
        
       /**
        *保存用户注册数据到沙盒
        */
#warning 利用单例保存用户注册数据功能暂未实现
    }
}
/**
 *键盘退下事件的处理
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/**
 *顶部左边导航按钮点击被点击响应方法(这个左边的导航按钮只做测试用，并没有什么使用的地方，本来想传值给登录控制器，后来发现不行，所以就做了测试用)
 */
-(void)backToViewController
{
    NSLog(@"用户点击了导航按钮");
    ViewController* vc=[[ViewController alloc]init];
    self.view.window.rootViewController=vc;
    
}
/**
 *顶部右边关闭按钮点击被点击响应方法
 */
-(void)close
{
    NSLog(@"用户关闭了当前注册界面");
    [self dismissViewControllerAnimated:YES completion:^{
        self.registerQQField.text=nil;
        self.registerQQPswField.text=nil;
        [self.registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    }];
}
/**
 *监听注册按钮是否被销毁的方法
 */
-(void)dealloc
{
    NSLog(@"注册控制器被销毁了");
}
@end
