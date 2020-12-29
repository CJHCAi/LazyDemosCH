//
//  SecurityPasswordViewController.m
//  SportForum
//
//  Created by liyuan on 4/2/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "SecurityPasswordViewController.h"
#import "UIViewController+SportFormu.h"
#import "AlertManager.h"

@interface SecurityPasswordViewController ()<UITextFieldDelegate>

@end

@implementation SecurityPasswordViewController
{
    UITextField * _lePasswordOld;
    UITextField * _lePasswordNew;
    UITextField * _lePasswordConfirm;
    id m_processWindow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"重设密码" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    //Create But Right Nav Btn
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    UIImageView *imgViewFinish = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
    [imgViewFinish setImage:[UIImage imageNamed:@"nav-finish-btn"]];
    [self.view addSubview:imgViewFinish];
    
    CSButton *btnFinish = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFinish.frame = CGRectMake(CGRectGetMinX(imgViewFinish.frame) - 5, CGRectGetMinY(imgViewFinish.frame) - 5, 45, 45);
    btnFinish.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnFinish];
    [self.view bringSubviewToFront:btnFinish];
    
        __weak typeof (self) thisPoint = self;
    
    btnFinish.actionBlock = ^void()
    {
        __typeof(self) strongSelf = thisPoint;
        [strongSelf changePassword];
    };
    
    UILabel * lbPassword = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
    lbPassword.backgroundColor = [UIColor clearColor];
    lbPassword.textColor = [UIColor darkGrayColor];
    lbPassword.text = @"旧密码";
    lbPassword.font = [UIFont boldSystemFontOfSize:14];
    lbPassword.textAlignment = NSTextAlignmentLeft;
    [viewBody addSubview:lbPassword];
    
    _lePasswordOld = [[UITextField alloc] initWithFrame:CGRectMake(10, 30, 310 - 20, 30)];
    _lePasswordOld.backgroundColor = [UIColor clearColor];
    _lePasswordOld.font = [UIFont boldSystemFontOfSize:14];
    _lePasswordOld.tintColor = [UIColor darkGrayColor];
    _lePasswordOld.keyboardType = UIKeyboardTypeASCIICapable;
    _lePasswordOld.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _lePasswordOld.enablesReturnKeyAutomatically = YES;
    _lePasswordOld.textAlignment = NSTextAlignmentLeft;
    _lePasswordOld.multipleTouchEnabled = YES;
    _lePasswordOld.delegate = self;
    _lePasswordOld.textColor = [UIColor darkGrayColor];
    _lePasswordOld.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _lePasswordOld.layer.borderWidth = 1.0;
    _lePasswordOld.secureTextEntry = YES;
    _lePasswordOld.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _lePasswordOld.leftViewMode = UITextFieldViewModeAlways;
    [viewBody addSubview:_lePasswordOld];
    
    [_lePasswordOld becomeFirstResponder];
    
    CSButton * btnShowPSW0 = [CSButton buttonWithType:UIButtonTypeCustom];
    btnShowPSW0.frame = CGRectMake(CGRectGetMaxX(_lePasswordOld.frame) - 38, CGRectGetMinY(_lePasswordOld.frame) + 6, 28, 18);
    [btnShowPSW0 setBackgroundImage:[UIImage imageNamed:@"password-invisible"] forState:UIControlStateNormal];
    [btnShowPSW0 setBackgroundImage:[UIImage imageNamed:@"password-visible"] forState:UIControlStateSelected];
    btnShowPSW0.selected = NO;
    [viewBody addSubview:btnShowPSW0];
    
    __typeof__(CSButton) __weak *thisbtnShowPSW = btnShowPSW0;
    btnShowPSW0.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        [thisStrongPoint->_lePasswordOld resignFirstResponder];
        
        if (thisStrongPoint->_lePasswordOld.secureTextEntry) {
            thisStrongPoint->_lePasswordOld.secureTextEntry = NO;
            thisbtnShowPSW.selected = YES;
        }
        else
        {
            thisStrongPoint->_lePasswordOld.secureTextEntry = YES;
            thisbtnShowPSW.selected = NO;
        }
    };

    UILabel * lbNewPassword = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_lePasswordOld.frame) + 30, 150, 20)];
    lbNewPassword.backgroundColor = [UIColor clearColor];
    lbNewPassword.textColor = [UIColor darkGrayColor];
    lbNewPassword.text = @"新密码";
    lbNewPassword.font = [UIFont boldSystemFontOfSize:14];
    lbNewPassword.textAlignment = NSTextAlignmentLeft;
    [viewBody addSubview:lbNewPassword];
    
    _lePasswordNew = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lbNewPassword.frame), 310 - 20, 30)];
    _lePasswordNew.backgroundColor = [UIColor clearColor];
    _lePasswordNew.font = [UIFont boldSystemFontOfSize:14];
    _lePasswordNew.tintColor = [UIColor darkGrayColor];
    _lePasswordNew.keyboardType = UIKeyboardTypeASCIICapable;
    _lePasswordNew.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _lePasswordNew.enablesReturnKeyAutomatically = YES;
    _lePasswordNew.textAlignment = NSTextAlignmentLeft;
    _lePasswordNew.multipleTouchEnabled = YES;
    _lePasswordNew.delegate = self;
    _lePasswordNew.textColor = [UIColor blackColor];
    _lePasswordNew.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _lePasswordNew.layer.borderWidth = 1.0;
    _lePasswordNew.secureTextEntry = YES;
    _lePasswordNew.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _lePasswordNew.leftViewMode = UITextFieldViewModeAlways;
    [viewBody addSubview:_lePasswordNew];
    
    CSButton * btnShowPSW1 = [CSButton buttonWithType:UIButtonTypeCustom];
    btnShowPSW1.frame = CGRectMake(CGRectGetMaxX(_lePasswordNew.frame) - 38, CGRectGetMinY(_lePasswordNew.frame) + 6, 28, 18);
    [btnShowPSW1 setBackgroundImage:[UIImage imageNamed:@"password-invisible"] forState:UIControlStateNormal];
    [btnShowPSW1 setBackgroundImage:[UIImage imageNamed:@"password-visible"] forState:UIControlStateSelected];
    btnShowPSW1.selected = NO;
    [viewBody addSubview:btnShowPSW1];
    
    __typeof__(CSButton) __weak *thisbtnShowPSW1 = btnShowPSW1;
    btnShowPSW1.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        [thisStrongPoint->_lePasswordNew resignFirstResponder];
        
        if (thisStrongPoint->_lePasswordNew.secureTextEntry) {
            thisStrongPoint->_lePasswordNew.secureTextEntry = NO;
            thisbtnShowPSW1.selected = YES;
        }
        else
        {
            thisStrongPoint->_lePasswordNew.secureTextEntry = YES;
            thisbtnShowPSW1.selected = NO;
        }
    };

    UILabel * lbConfirmedPassword = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_lePasswordNew.frame) + 10, 150, 20)];
    lbConfirmedPassword.backgroundColor = [UIColor clearColor];
    lbConfirmedPassword.textColor = [UIColor darkGrayColor];
    lbConfirmedPassword.text = @"确认新密码";
    lbConfirmedPassword.font = [UIFont boldSystemFontOfSize:14];
    lbConfirmedPassword.textAlignment = NSTextAlignmentLeft;
    [viewBody addSubview:lbConfirmedPassword];
    
    _lePasswordConfirm = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lbConfirmedPassword.frame), 310 - 20, 30)];
    _lePasswordConfirm.backgroundColor = [UIColor clearColor];
    _lePasswordConfirm.font = [UIFont boldSystemFontOfSize:14];
    _lePasswordConfirm.tintColor = [UIColor darkGrayColor];
    _lePasswordConfirm.keyboardType = UIKeyboardTypeASCIICapable;
    _lePasswordConfirm.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _lePasswordConfirm.enablesReturnKeyAutomatically = YES;
    _lePasswordConfirm.textAlignment = NSTextAlignmentLeft;
    _lePasswordConfirm.multipleTouchEnabled = YES;
    _lePasswordConfirm.delegate = self;
    _lePasswordConfirm.textColor = [UIColor blackColor];
    _lePasswordConfirm.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _lePasswordConfirm.layer.borderWidth = 1.0;
    _lePasswordConfirm.secureTextEntry = YES;
    _lePasswordConfirm.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _lePasswordConfirm.leftViewMode = UITextFieldViewModeAlways;
    [viewBody addSubview:_lePasswordConfirm];
    
    CSButton * btnShowPSW2 = [CSButton buttonWithType:UIButtonTypeCustom];
    btnShowPSW2.frame = CGRectMake(CGRectGetMaxX(_lePasswordConfirm.frame) - 38,  CGRectGetMinY(_lePasswordConfirm.frame) + 6, 28, 18);
    [btnShowPSW2 setBackgroundImage:[UIImage imageNamed:@"password-invisible"] forState:UIControlStateNormal];
    [btnShowPSW2 setBackgroundImage:[UIImage imageNamed:@"password-visible"] forState:UIControlStateSelected];
    btnShowPSW2.selected = NO;
    [viewBody addSubview:btnShowPSW2];
    
    __typeof__(CSButton) __weak *thisbtnShowPSW2 = btnShowPSW2;
    btnShowPSW2.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        [thisStrongPoint->_lePasswordConfirm resignFirstResponder];
        
        if (thisStrongPoint->_lePasswordConfirm.secureTextEntry) {
            thisStrongPoint->_lePasswordConfirm.secureTextEntry = NO;
            thisbtnShowPSW2.selected = YES;
        }
        else
        {
            thisStrongPoint->_lePasswordConfirm.secureTextEntry = YES;
            thisbtnShowPSW2.selected = NO;
        }
    };

    UILabel * lbRemind = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_lePasswordConfirm.frame) + 20, 290, 20)];
    lbRemind.backgroundColor = [UIColor clearColor];
    lbRemind.textColor = [UIColor darkGrayColor];
    lbRemind.text = @"密码数4-12位，英文字母或数字";
    lbRemind.font = [UIFont boldSystemFontOfSize:12];
    [viewBody addSubview:lbRemind];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"密码修改 - SecurityPasswordViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"密码修改 - SecurityPasswordViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"密码修改 - SecurityPasswordViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"SecurityPasswordViewController dealloc called!");
}

-(void)changePassword
{
    NSString * strOldPassword = _lePasswordOld.text;
    NSString * strNewPassword = _lePasswordNew.text;
    NSString * strConfirmPassword = _lePasswordConfirm.text;
    
    strOldPassword = [strOldPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    strNewPassword = [strNewPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    strConfirmPassword = [strConfirmPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([strOldPassword isEqualToString:@""] || [strNewPassword isEqualToString:@""] || [strConfirmPassword isEqualToString:@""])
    {
        [JDStatusBarNotification showWithStatus:@"密码不能为空！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }
    
    if(strOldPassword.length < 4 || strNewPassword.length < 4 || strConfirmPassword.length < 4)
    {
        [JDStatusBarNotification showWithStatus:@"您输入的密码位数不够，至少4位字母或数字！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }
    
    if (![strNewPassword isEqualToString:strConfirmPassword]) {
        [JDStatusBarNotification showWithStatus:@"您输入的新密码与确认密码不一致！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }
    
    [_lePasswordOld resignFirstResponder];
    [_lePasswordNew resignFirstResponder];
    [_lePasswordConfirm resignFirstResponder];
    
    [self viewShowWaitProcess];
    
    [[SportForumAPI sharedInstance]accountModifyPassword:strOldPassword NewPassword:strNewPassword FinishedBlock:^(int errorCode, NSString* strErr){
        [self viewDisWaitProcess];
        
        if (errorCode == 0) {
            [JDStatusBarNotification showWithStatus:@"修改密码成功" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [JDStatusBarNotification showWithStatus:strErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
        }
    }];
}

-(void)viewShowWaitProcess
{
    if (m_processWindow) {
        [self viewDisWaitProcess];
    }
    
    m_processWindow = [AlertManager showCommonProgress];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL bAllowWord = YES;
    
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    [newtxt replaceCharactersInRange:range withString:string];
    
    if ([newtxt length] > 12)
    {
        bAllowWord = NO;
    }
    else
    {
        bAllowWord = [[CommonUtility sharedInstance]isAllowChar:newtxt AlowedChars:ALLOW_CHARS];
    }
    
    return bAllowWord;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
