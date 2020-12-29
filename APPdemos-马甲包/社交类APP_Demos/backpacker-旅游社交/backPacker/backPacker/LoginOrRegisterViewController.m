//
//  LoginOrRegisterViewController.m
//  backPacker
//
//  Created by 聂 亚杰 on 13-5-23.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "LoginOrRegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "RegisterViewController.h"
@interface LoginOrRegisterViewController ()

@end

@implementation LoginOrRegisterViewController

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
//    //set navgationbar rightButton
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(exitAccount:)];
//    [self.navigationController.navigationItem setRightBarButtonItem:rightBarItem animated:YES];
    
    //set segmentTextColor
    UIFont *Boldfont = [UIFont systemFontOfSize:14.0f];
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:Boldfont,UITextAttributeFont,[UIColor darkGrayColor],UITextAttributeTextColor,nil];
    
    [self.loginOrRegisterSegment setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    
    UIFont *Boldfont2 = [UIFont systemFontOfSize:14.0f];
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:Boldfont2,UITextAttributeFont,[UIColor colorWithRed:223.0/255.0 green:102.0/255.0 blue:5.0/255.0 alpha:1.0],UITextAttributeTextColor,nil];
    
    [self.loginOrRegisterSegment setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    //设置view背景色
    self.view.backgroundColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1.0];
    
    //add childViewcontroller
    LoginViewController *lVC = (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    [lVC.view setFrame:CGRectMake(0, 0, 320, 475)];
    RegisterViewController *rVC = (RegisterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"];
    [rVC.view setFrame:CGRectMake(0, 0, 320, 475)];
    [self addChildViewController:lVC];
    [self addChildViewController:rVC];
    
    UIButton *myButton = (UIButton *)[self.view viewWithTag:3];
    NSString *title;
    if ([self.loginOrRegister isEqualToString:@"0"]) {
        title = @"注册";
        [self.loginOrRegisterSegment setSelectedSegmentIndex:1];
        NSLog(@"self.childViewframe:%f",self.childView.frame.origin.y);
        NSLog(@"rVC.viewFrame.y:%f",rVC.view.frame.origin.y);
        [self.childView addSubview:rVC.view];
    }else if([self.loginOrRegister isEqualToString:@"1"]){
        title = @"登录";
//        [self.loginOrRegisterSegment setSelectedSegmentIndex:0];
        [self.childView addSubview:lVC.view];
    }
    [myButton setTitle:title forState:UIControlStateNormal];
    
    

}

-(void)viewWillAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)lrSegmentPressed:(id)sender {
    NSLog(@"self.segment.frame.height:%f",self.loginOrRegisterSegment.frame.size.height);

    LoginViewController *lVC = (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    [lVC.view setFrame:CGRectMake(0, 0, 320, 475)];

    RegisterViewController *rVC = (RegisterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"];
    [rVC.view setFrame:CGRectMake(0, 0, 320, 475)];

    int selectIndex = [self.loginOrRegisterSegment selectedSegmentIndex];
      if (selectIndex == 0) {
        [rVC.view removeFromSuperview];
        [self.childView addSubview:lVC.view];
    }else{
        [lVC.view removeFromSuperview];
        [self.childView addSubview:rVC.view];
    }

}


-(IBAction)exitAccount:(id)sender{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    [saveDefaults setValue:@"0" forKey:@"hasLogin"];
    [self.navigationController popViewControllerAnimated:YES];

}
@end
