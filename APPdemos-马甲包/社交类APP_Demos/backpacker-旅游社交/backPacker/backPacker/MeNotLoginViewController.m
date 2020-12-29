//
//  MeNotLoginViewController.m
//  backPacker
//
//  Created by 聂 亚杰 on 13-6-4.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "MeNotLoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginOrRegisterViewController.h"
@interface MeNotLoginViewController ()

@end

@implementation MeNotLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void)addNotLoginView{

    UILabel *loginText = [[UILabel alloc]initWithFrame:CGRectMake(30, 95, 260, 20)];
    [loginText setText:@"登陆账号，开启属于你的精彩之旅吧"];
    [loginText setFont:[UIFont systemFontOfSize:16.0]];
    [loginText setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:loginText];
    
    UIButton *registerButton =[[UIButton alloc]initWithFrame:CGRectMake(30, 140, 260, 35)];
    registerButton.backgroundColor = [UIColor colorWithRed:62/255.0 green:136/255.0 blue:82.0/255.0 alpha:1.0];
    registerButton.layer.cornerRadius = 4;
    registerButton.layer.shadowColor = [UIColor blackColor].CGColor;
    registerButton.layer.shadowOffset = CGSizeMake(1,1);
    registerButton.layer.shadowOpacity = 0.5;
    registerButton.layer.shadowRadius = 3;
    registerButton.layer.borderWidth = 1.0;
    registerButton.layer.borderColor = [UIColor grayColor].CGColor;
    [registerButton setTitle:@"登录" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTag:3];
    [registerButton addTarget:self action:@selector(LoginOrRegisterBPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    UIButton *loginButton =[[UIButton alloc]initWithFrame:CGRectMake(30, 185, 260, 35)];
    loginButton.backgroundColor = [UIColor colorWithRed:106.0/255.0 green:206.0/255.0 blue:231.0/255.0 alpha:1.0];
    loginButton.layer.cornerRadius = 4;
    loginButton.layer.shadowColor = [UIColor blackColor].CGColor;
    loginButton.layer.shadowOffset = CGSizeMake(1,1);
    loginButton.layer.shadowOpacity = 0.5;
    loginButton.layer.shadowRadius = 3;
    loginButton.layer.borderWidth = 1.0;
    loginButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [loginButton setTitle:@"注册" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTag:4];
    [loginButton addTarget:self action:@selector(LoginOrRegisterBPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

-(void)LoginOrRegisterBPressed:(UIButton *)sender{
    LoginOrRegisterViewController *lrVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginOrRegisterVC"];
    if (sender.tag == 3) {
        [lrVC setLoginOrRegister:@"1"];
    }else if (sender.tag == 4){
        [lrVC setLoginOrRegister:@"0"];
    }
    [self.navigationController pushViewController:lrVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
