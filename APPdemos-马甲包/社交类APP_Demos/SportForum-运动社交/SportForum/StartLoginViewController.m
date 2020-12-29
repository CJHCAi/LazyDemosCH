//
//  StartLoginViewController.m
//  SportForum
//
//  Created by liyuan on 14-8-18.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "StartLoginViewController.h"
#import "IntroControll.h"
#import "LoginEmailViewController.h"
#import "RegisterInfoViewController.h"

@interface StartLoginViewController ()

@end

@implementation StartLoginViewController
{
    IntroControll *_IntroControll;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    //self.wantsFullScreenLayout = YES;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;
}

- (void)loadView {
    [super loadView];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    IntroModel *model1 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"introduction-1"];
    IntroModel *model2 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"introduction-2"];
    IntroModel *model3 = [[IntroModel alloc] initWithTitle:@"" description:@"" image:@"introduction-4"];
    
    _IntroControll = [[IntroControll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:@[model1, model2, model3]];
    [self.view addSubview:_IntroControll];
    
    UIView *viewRegedit = [[UIView alloc]initWithFrame:CGRectMake(0, APP_SCREEN_HEIGHT - 60, APP_SCREEN_WIDTH / 2, 60)];
    UIImage *image = [UIImage imageNamed:@"start-page-register"];
    viewRegedit.layer.contents = (id) image.CGImage;
    [self.view addSubview:viewRegedit];
    
    UIView *viewLogin = [[UIView alloc]initWithFrame:CGRectMake(APP_SCREEN_WIDTH / 2, APP_SCREEN_HEIGHT - 60, APP_SCREEN_WIDTH / 2, 60)];
    image = [UIImage imageNamed:@"start-page-login"];
    viewLogin.layer.contents = (id) image.CGImage;
    [self.view addSubview:viewLogin];
    
    CSButton *btnRegedit = [CSButton buttonWithType:UIButtonTypeCustom];
    [btnRegedit setTitle:@"注册" forState:UIControlStateNormal];
    btnRegedit.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btnRegedit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRegedit.frame = viewRegedit.frame;
    btnRegedit.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnRegedit];
    [self.view bringSubviewToFront:btnRegedit];
    
    __typeof__(self) __weak thisPointer = self;
    
    btnRegedit.actionBlock = ^void()
    {
        __typeof__(self) thisPointerStrong = thisPointer;
        RegisterInfoViewController *registerInfoViewController = [[RegisterInfoViewController alloc]init];
        registerInfoViewController.nRegisterType = REGISTER_NIKENAME_PAGE;
        [thisPointerStrong.navigationController pushViewController:registerInfoViewController animated:YES];
    };
    
    CSButton *btnLogin = [CSButton buttonWithType:UIButtonTypeCustom];
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLogin.frame = viewLogin.frame;
    btnLogin.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnLogin];
    [self.view bringSubviewToFront:btnLogin];
    
    btnLogin.actionBlock = ^void()
    {
        __typeof__(self) thisPointerStrong = thisPointer;
        LoginEmailViewController *loginEmailViewController = [[LoginEmailViewController alloc]init];
        [thisPointerStrong.navigationController pushViewController:loginEmailViewController animated:YES];
    };
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_IntroControll setCurrentPage:0];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"StartLoginViewController dealloc called!");
}

@end
