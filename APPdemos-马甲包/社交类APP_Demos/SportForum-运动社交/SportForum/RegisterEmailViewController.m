//
//  RegisterEmailViewController.m
//  SportForum
//
//  Created by zyshi on 14-10-11.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "RegisterEmailViewController.h"
#import "CSButton.h"
#import "UIImage+Blur.h"
#import "AlertManager.h"
#import "UIViewController+SportFormu.h"
#import "CommonUtility.h"
#import "HTAutocompleteTextField.h"
#import "HTAutocompleteManager.h"
#import "RecommendViewController.h"

@interface RegisterEmailViewController ()<UITextFieldDelegate>

@end

@implementation RegisterEmailViewController
{
    HTAutocompleteTextField * _leAddress;
    UITextField * _lePassword;
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
    [self generateCommonViewInParent:self.view Title:@"绑定邮箱" IsNeedBackBtn:YES];
    
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
    lbAddress.text = @"邮箱地址：";
    lbAddress.font = [UIFont boldSystemFontOfSize:14];
    [viewBody addSubview:lbAddress];
    
    _leAddress = [[HTAutocompleteTextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, 50, 266, 30)];
    _leAddress.autocompleteType = HTAutocompleteTypeEmail;
    _leAddress.backgroundColor = [UIColor clearColor];
    _leAddress.font = [UIFont boldSystemFontOfSize:14];
    _leAddress.tintColor = [UIColor darkGrayColor];
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
    _lePassword.tintColor = [UIColor darkGrayColor];
    _lePassword.textColor = [UIColor darkGrayColor];
    _lePassword.keyboardType = UIKeyboardTypeASCIICapable;
    _lePassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _lePassword.enablesReturnKeyAutomatically = YES;
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
    
    UILabel * lbRemind = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, 165, 270, 20)];
    lbRemind.backgroundColor = [UIColor clearColor];
    lbRemind.textColor = [UIColor darkGrayColor];
    lbRemind.text = @"密码数4-12位，英文字母或数字";
    lbRemind.font = [UIFont boldSystemFontOfSize:12];
    [viewBody addSubview:lbRemind];
    
    UIImage * imgButton = [UIImage imageNamed:@"btn-2-blue"];
    CSButton * btnRegedit = [[CSButton alloc] initNormalButtonTitle:@"注册" Rect:CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, 210, 266, 38)];
    [btnRegedit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRegedit setBackgroundImage:imgButton forState:UIControlStateNormal];
    btnRegedit.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btnRegedit setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [viewBody addSubview:btnRegedit];
    
    UILabel *lbTipsValue = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(btnRegedit.frame) + 10, 290, 40)];
    lbTipsValue.backgroundColor = [UIColor clearColor];
    lbTipsValue.textColor = [UIColor lightGrayColor];
    lbTipsValue.font = [UIFont systemFontOfSize:13];
    lbTipsValue.textAlignment = NSTextAlignmentLeft;
    lbTipsValue.text = @"基于安全的原因，请填写你常用的邮箱进行绑定，保护你的帐号和密码。";
    lbTipsValue.numberOfLines = 0;
    [viewBody addSubview:lbTipsValue];
    
    __weak typeof (self) thisPoint = self;
    
    btnRegedit.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        NSString * strEmail = thisStrongPoint->_leAddress.text;
        NSString * strPassword = thisStrongPoint->_lePassword.text;
        
        strPassword = [strPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([strEmail isEqualToString:@""] || [strPassword isEqualToString:@""])
        {
            [JDStatusBarNotification showWithStatus:@"邮箱或密码为空，请输入完整的信息！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
        
        NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEXP];
        if(![[CommonUtility sharedInstance] isPureNumandCharacters:strEmail] && ![prd evaluateWithObject:strEmail])
        {
            [JDStatusBarNotification showWithStatus:@"您输入的Email有误！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
        
        if(strPassword.length < 4)
        {
            [JDStatusBarNotification showWithStatus:@"您输入的密码位数不够，至少4位字母或数字！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
        
        [thisStrongPoint->_leAddress resignFirstResponder];
        [thisStrongPoint->_lePassword resignFirstResponder];
        
        [[SportForumAPI sharedInstance]accountCheckExistById:strEmail AccountType:login_type_email FinishedBlock:^(int errorCode, NSString* userId)
         {
             if (errorCode == 0) {
                 if (userId.length > 0) {
                     [JDStatusBarNotification showWithStatus:@"该邮箱地址已注册，请使用其他邮箱地址" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                 }
                 else
                 {
                     NSMutableDictionary *regProfileDict = [[ApplicationContext sharedInstance] getObjectByKey:@"RegProfile"];
                     NSString *strNickName = [regProfileDict objectForKey:@"NickName"];
                     NSString *strProUrl = [regProfileDict objectForKey:@"ProfileUrl"];
                     NSString *strSexType = [regProfileDict objectForKey:@"SexType"];
                     long long lBirthday = [[regProfileDict objectForKey:@"Birthday"]longLongValue];
                     
                     id process = [AlertManager showCommonProgress];
                     
                     [[ApplicationContext sharedInstance]createAccountWithId:strEmail password:strPassword Type:login_type_email nikeName:strNickName ProfileUrl:strProUrl Gender:[strSexType isEqualToString:@"男"] ? @"male" : @"female"  Birthday:lBirthday FinishedBlock:^(int errorCode, NSString* strErr, NSString* strUserId)
                      {
                          [AlertManager dissmiss:process];
                          
                          if (errorCode == 0) {
                              RecommendViewController *recommendViewController = [[RecommendViewController alloc]init];
                              [self.navigationController pushViewController:recommendViewController animated:NO];
                          }
                          else
                          {
                              [JDStatusBarNotification showWithStatus:strErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                          }
                      }];
                 }
             }
             else
             {
                [JDStatusBarNotification showWithStatus:@"检查数据异常" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"RegisterEmailViewController dealloc called!");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"邮箱注册 - RegisterEmailViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"邮箱注册 - RegisterEmailViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"邮箱注册 - RegisterEmailViewController"];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
        if ([newtxt length] > 12)
        {
            bAllowWord = NO;
        }
        else
        {
            bAllowWord = [[CommonUtility sharedInstance]isAllowChar:newtxt AlowedChars:ALLOW_CHARS];
        }
    }
    
    return bAllowWord;
}

@end
