//
//  LoginEmailViewController.m
//  SportForum
//
//  Created by zyshi on 14-10-11.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "LoginEmailViewController.h"
#import "CSButton.h"
#import "UIImage+Blur.h"
#import "AlertManager.h"
#import "UIViewController+SportFormu.h"
#import "HTAutocompleteTextField.h"
#import "HTAutocompleteManager.h"
#import "BindPhoneViewController.h"

@interface LoginEmailViewController ()<UITextFieldDelegate>

@end

@implementation LoginEmailViewController
{
    HTAutocompleteTextField * _leAddress;
    UITextField * _lePassword;
    UIImageView *_backgroundImage;
    
    id m_processWindow;
}

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
    [self generateCommonViewInParent:self.view Title:@"登录" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    
    UILabel * lbAddress = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, 20, 266, 24)];
    lbAddress.backgroundColor = [UIColor clearColor];
    lbAddress.textColor = [UIColor darkGrayColor];
    lbAddress.text = @"邮箱地址或手机号：";
    lbAddress.font = [UIFont boldSystemFontOfSize:14];
    [viewBody addSubview:lbAddress];
    
    _leAddress = [[HTAutocompleteTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, 50, 266, 30)];
    _leAddress.backgroundColor = [UIColor clearColor];
    _leAddress.font = [UIFont boldSystemFontOfSize:14];
    _leAddress.autocompleteType = HTAutocompleteTypeEmail;
    
    if (IOS7_OR_LATER) {
        _leAddress.tintColor = [UIColor darkGrayColor];
    }
    
    _leAddress.keyboardType = UIKeyboardTypeASCIICapable;
    _leAddress.clearButtonMode = UITextFieldViewModeWhileEditing;
    _leAddress.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _leAddress.enablesReturnKeyAutomatically = YES;
    _leAddress.textAlignment = NSTextAlignmentLeft;
    _leAddress.multipleTouchEnabled = YES;
    _leAddress.delegate = self;
    _leAddress.textColor = [UIColor blackColor];
    _leAddress.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _leAddress.layer.borderWidth = 1.0;
    _leAddress.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _leAddress.leftViewMode = UITextFieldViewModeAlways;
    [viewBody addSubview:_leAddress];
    
    UILabel * lbPassword = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, 100, 266, 24)];
    lbPassword.backgroundColor = [UIColor clearColor];
    lbPassword.textColor = [UIColor darkGrayColor];
    lbPassword.text = @"密码：";
    lbPassword.font = [UIFont boldSystemFontOfSize:14];
    [viewBody addSubview:lbPassword];
    
    _lePassword = [[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, 130, 266, 30)];
    _lePassword.backgroundColor = [UIColor clearColor];
    _lePassword.font = [UIFont boldSystemFontOfSize:14];
    _lePassword.textColor = [UIColor darkGrayColor];

    if (IOS7_OR_LATER)
    {
        _lePassword.tintColor = [UIColor darkGrayColor];
    }
    
    _lePassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _lePassword.enablesReturnKeyAutomatically = YES;
    _lePassword.keyboardType = UIKeyboardTypeASCIICapable;
    _lePassword.textAlignment = NSTextAlignmentLeft;
    _lePassword.multipleTouchEnabled = YES;
    _lePassword.delegate = self;
    _lePassword.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _lePassword.layer.borderWidth = 1.0;
    _lePassword.secureTextEntry = YES;
    _lePassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _lePassword.leftViewMode = UITextFieldViewModeAlways;
    [viewBody addSubview:_lePassword];
    
    CSButton * btnShowPSW = [CSButton buttonWithType:UIButtonTypeCustom];
    btnShowPSW.frame = CGRectMake(255, 135, 28, 18);
    [btnShowPSW setBackgroundImage:[UIImage imageNamed:@"password-invisible"] forState:UIControlStateNormal];
    [btnShowPSW setBackgroundImage:[UIImage imageNamed:@"password-visible"] forState:UIControlStateSelected];
    btnShowPSW.selected = NO;
    [viewBody addSubview:btnShowPSW];

    CSButton * btnForget = [CSButton buttonWithType:UIButtonTypeCustom];
    btnForget.frame = CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, 165, 266, 24);
    btnForget.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnForget setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnForget setTitle:@"忘记密码?" forState:UIControlStateNormal];
    btnForget.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [viewBody addSubview:btnForget];
    
    UIImage * imgButton = [UIImage imageNamed:@"btn-2-blue"];
    CSButton * btnLogin = [[CSButton alloc] initNormalButtonTitle:@"登录" Rect:CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, 210, 266, 38)];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:imgButton forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btnLogin setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [viewBody addSubview:btnLogin];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, viewBody.frame.size.height - 50, 30, 30)];
    [imgView setImage:[UIImage imageNamed:@"weibo-icon"]];
    [viewBody addSubview:imgView];
    
    CSButton * btnWeibo = [CSButton buttonWithType:UIButtonTypeCustom];
    btnWeibo.frame = CGRectMake(CGRectGetMinX(imgView.frame), viewBody.frame.size.height - 60, 95, 50);
    btnWeibo.titleLabel.font = [UIFont boldSystemFontOfSize: 14];
    [btnWeibo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnWeibo setTitle:@"微博登录" forState:UIControlStateNormal];
    btnWeibo.backgroundColor = [UIColor clearColor];
    btnWeibo.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [viewBody addSubview:btnWeibo];
    
    _backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [_backgroundImage setContentMode:UIViewContentModeScaleAspectFill];
    [_backgroundImage setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_backgroundImage setImage:[UIImage imageNamed:@"Default-568h"]];
    _backgroundImage.hidden = YES;
    [self.view addSubview:_backgroundImage];
    
    __weak typeof (self) thisPoint = self;
    
    btnLogin.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        NSString * strEmail = thisStrongPoint->_leAddress.text;
        NSString * strPassword = thisStrongPoint->_lePassword.text;
        strPassword = [strPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEXP];
        
        if([strEmail isEqualToString:@""] || [strPassword isEqualToString:@""])
        {
            [JDStatusBarNotification showWithStatus:@"邮箱或密码为空，请输入完整的信息！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
        else if(![[CommonUtility sharedInstance] isPureNumandCharacters:strEmail] && ![prd evaluateWithObject:strEmail])
        {
            [JDStatusBarNotification showWithStatus:@"您输入的信息有误！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
        
        if(strPassword.length < 4)
        {
            [JDStatusBarNotification showWithStatus:@"您输入的密码位数不够，至少4位字母或数字！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }

        [thisStrongPoint->_leAddress resignFirstResponder];
        [thisStrongPoint->_lePassword resignFirstResponder];
        
        [thisStrongPoint viewShowWaitProcess];
        
        [[ApplicationContext sharedInstance] login:strEmail key:strPassword type:([[CommonUtility sharedInstance] isPureNumandCharacters:strEmail] ? login_type_phone : login_type_email) reset:NO FinishedBlock:^(int errorCode, NSString* strErr, NSString* strUserId){
            [thisStrongPoint viewDisWaitProcess];
            
            if (errorCode == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_SWITCH_VIEW object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:VIEW_MAIN_PAGE, @"PageName", nil]];
            }
            else
            {
                [JDStatusBarNotification showWithStatus:strErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
            }
        }];
    };
    
    __typeof__(CSButton) __weak *thisbtnShowPSW = btnShowPSW;
    btnShowPSW.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        [thisStrongPoint->_leAddress resignFirstResponder];
        [thisStrongPoint->_lePassword resignFirstResponder];
        
        if (thisStrongPoint->_lePassword.secureTextEntry) {
            thisStrongPoint->_lePassword.secureTextEntry = NO;
            thisbtnShowPSW.selected = YES;
        }
        else
        {
            thisStrongPoint->_lePassword.secureTextEntry = YES;
            thisbtnShowPSW.selected = NO;
        }
    };
    
    btnWeibo.actionBlock = ^void()
    {
        [[CommonUtility sharedInstance] sinaWeiBoLogin];
    };
    
    btnForget.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        BindPhoneViewController * bindPhoneViewController = [[BindPhoneViewController alloc] init];
        bindPhoneViewController.bForgetPwd = YES;
        bindPhoneViewController.bRegisterPhone = NO;

        [thisStrongPoint.navigationController pushViewController:bindPhoneViewController animated:YES];
    };
}

-(void)showBackgroundView:(BOOL)bShow
{
    _backgroundImage.hidden = !bShow;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *strAccount = [[ApplicationContext sharedInstance] getObjectByKey:@"AccountName"];
    
    if (strAccount.length > 0) {
        _leAddress.text = strAccount;
        [_lePassword becomeFirstResponder];
    }
    
    [MobClick beginLogPageView:@"邮箱登录 - LoginEmailViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"邮箱登录 - LoginEmailViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"邮箱登录 - LoginEmailViewController"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"LoginEmailViewController dealloc called!");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _lePassword)
    {
        UITextRange *markedRange = [textField markedTextRange];
        NSString * newText = [textField textInRange:markedRange];

        if (newText.length != 0)
        {
            return;
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL bAllowWord = YES;
    
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    [newtxt replaceCharactersInRange:range withString:string];
    
    if (textField == _leAddress) {
        if ([newtxt length] > 25)
        {
            bAllowWord = NO;
        }
    }
    else
    {
        bAllowWord = [[CommonUtility sharedInstance]isAllowChar:newtxt AlowedChars:ALLOW_CHARS];
        
        if ([newtxt length] > 12)
        {
            bAllowWord = NO;
        }
    }
    
    return bAllowWord;
}

-(void)viewShowWaitProcess
{
    if (m_processWindow) {
        [self viewDisWaitProcess];
    }
    
    m_processWindow = [AlertManager showCommonProgressWithText:@"正在登录"];
}

-(void)viewDisWaitProcess
{
    [AlertManager dissmiss:m_processWindow];
    m_processWindow = nil;
}


@end
