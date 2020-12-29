//
//  BindPhoneViewController.m
//  SportForum
//
//  Created by liyuan on 1/19/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "UIViewController+SportFormu.h"
#import "CSButton.h"
#import "RegisterEmailViewController.h"
#import "RecommendViewController.h"
#import "AlertManager.h"

#import "SMS_SDK/SMS_SDK.h"
#import "CommonUtility.h"
#import "IQKeyboardManager.h"

@interface BindPhoneViewController ()<UITextFieldDelegate,UITextFieldDelegate>

@end

@implementation BindPhoneViewController
{
    UIView *_viewFirst;
    UIView *_viewSecond;
    UIView *_viewThird;
    CSButton * _btnAction;
    CSButton *_btnSkip;
    UILabel *_lbTipsValue;
    
    UITextField* _areaCodeField;
    UITextField* _telField;
    
    UILabel* _lbPhoneNum;
    UILabel* _lbSmsRecTime;
    UITextField* _codeField;
    NSTimer* _timerCode;
    CSButton* _repeatBtn;
    int _nCount;
    
    UITextField* _lePassword;
    
    NSString* _str;
    
    UIAlertView *_alertView;
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

-(void)viewGenerateFirst
{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    
    _viewFirst = [[UIView alloc]init];
    _viewFirst.backgroundColor = [UIColor clearColor];
    _viewFirst.frame = CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), 200);
    [viewBody addSubview:_viewFirst];
    
    UILabel* lbPhoneTitle = [[UILabel alloc] init];
    lbPhoneTitle.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 266) / 2, 20, 266, 24);
    lbPhoneTitle.text = @"手机号码: ";
    lbPhoneTitle.textAlignment = NSTextAlignmentLeft;
    lbPhoneTitle.font = [UIFont boldSystemFontOfSize:16];
    lbPhoneTitle.textColor=[UIColor blackColor];
    [_viewFirst addSubview:lbPhoneTitle];
    
    _areaCodeField = [[UITextField alloc] init];
    _areaCodeField.frame=CGRectMake((CGRectGetWidth(self.view.frame) - 266) / 2, 50, 65, 35);
    _areaCodeField.text=[NSString stringWithFormat:@"+86"];
    _areaCodeField.textAlignment=NSTextAlignmentCenter;
    _areaCodeField.font=[UIFont boldSystemFontOfSize:16];
    _areaCodeField.keyboardType=UIKeyboardTypePhonePad;
    _areaCodeField.backgroundColor = [UIColor clearColor];
    _areaCodeField.font = [UIFont boldSystemFontOfSize:14];
    _areaCodeField.tintColor = [UIColor blackColor];
    _areaCodeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _areaCodeField.enablesReturnKeyAutomatically = YES;
    _areaCodeField.multipleTouchEnabled = YES;
    _areaCodeField.textColor = [UIColor blackColor];
    _areaCodeField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _areaCodeField.layer.borderWidth = 1.0;
    _areaCodeField.delegate = self;
    [_viewFirst addSubview:_areaCodeField];
    
    _telField=[[UITextField alloc] init];
    _telField.frame=CGRectMake(CGRectGetMaxX(_areaCodeField.frame), 50, 266 - 65, 35);
    _telField.layer.borderColor = [UIColor whiteColor].CGColor;
    _telField.placeholder=@"请输入手机号码";
    _telField.keyboardType=UIKeyboardTypeNumberPad;
    _telField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _telField.backgroundColor = [UIColor clearColor];
    _telField.font = [UIFont boldSystemFontOfSize:14];
    _telField.tintColor = [UIColor blackColor];
    _telField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _telField.enablesReturnKeyAutomatically = YES;
    _telField.textAlignment = NSTextAlignmentLeft;
    _telField.multipleTouchEnabled = YES;
    _telField.textColor = [UIColor blackColor];
    _telField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _telField.layer.borderWidth = 1.0;
    _telField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 25)];
    _telField.leftViewMode = UITextFieldViewModeAlways;
    _telField.delegate = self;
    [_viewFirst addSubview:_telField];
    
    _viewFirst.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetMaxY(_telField.frame) + 20);
}

-(void)viewGenerateSecond
{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    
    _viewSecond = [[UIView alloc]init];
    _viewSecond.backgroundColor = [UIColor clearColor];
    _viewSecond.hidden = YES;
    _viewSecond.frame = CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), 200);
    [viewBody addSubview:_viewSecond];
    
    UILabel* lbNote = [[UILabel alloc] init];
    lbNote.frame = CGRectMake(10, 20, 300, 24);
    lbNote.text = @"我们已发送验证码到这个号码";
    lbNote.textAlignment = NSTextAlignmentCenter;
    lbNote.font = [UIFont boldSystemFontOfSize:16];
    lbNote.textColor=[UIColor blackColor];
    [_viewSecond addSubview:lbNote];
    
    _lbPhoneNum = [[UILabel alloc] init];
    _lbPhoneNum.frame = CGRectMake(10, 50, 300, 24);
    _lbPhoneNum.text = @"";
    _lbPhoneNum.textAlignment = NSTextAlignmentCenter;
    _lbPhoneNum.font = [UIFont boldSystemFontOfSize:16];
    _lbPhoneNum.textColor=[UIColor blackColor];
    [_viewSecond addSubview:_lbPhoneNum];
    
    _lbSmsRecTime = [[UILabel alloc] init];
    _lbSmsRecTime.frame = CGRectMake(10, 85, 300, 24);
    _lbSmsRecTime.text = @"";
    _lbSmsRecTime.textAlignment = NSTextAlignmentCenter;
    _lbSmsRecTime.font = [UIFont boldSystemFontOfSize:16];
    _lbSmsRecTime.textColor=[UIColor blackColor];
    [_viewSecond addSubview:_lbSmsRecTime];
    
    _codeField=[[UITextField alloc] init];
    _codeField.frame=CGRectMake((CGRectGetWidth(self.view.frame) - 266) / 2, 130, 266, 30);
    _codeField.layer.borderColor = [UIColor whiteColor].CGColor;
    _codeField.placeholder=@"填写收到的短信验证码";
    _codeField.keyboardType=UIKeyboardTypePhonePad;
    _codeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _codeField.backgroundColor = [UIColor clearColor];
    _codeField.font = [UIFont boldSystemFontOfSize:14];
    _codeField.tintColor = [UIColor blackColor];
    _codeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _codeField.enablesReturnKeyAutomatically = YES;
    _codeField.textAlignment = NSTextAlignmentLeft;
    _codeField.multipleTouchEnabled = YES;
    _codeField.textColor = [UIColor blackColor];
    _codeField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _codeField.layer.borderWidth = 1.0;
    _codeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 25)];
    _codeField.leftViewMode = UITextFieldViewModeAlways;
    _codeField.delegate = self;
    [_viewSecond addSubview:_codeField];
    
    CSButton * btnReInput = [CSButton buttonWithType:UIButtonTypeCustom];
    btnReInput.frame = CGRectMake(CGRectGetMinX(_codeField.frame), 180, 120, 24);
    btnReInput.titleLabel.font = [UIFont boldSystemFontOfSize: 14];
    [btnReInput setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnReInput setTitle:@"重新输入手机号?" forState:UIControlStateNormal];
    btnReInput.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_viewSecond addSubview:btnReInput];
    
    _repeatBtn = [CSButton buttonWithType:UIButtonTypeCustom];
    _repeatBtn.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 266) / 2, 85, 266, 24);
    _repeatBtn.titleLabel.font = [UIFont boldSystemFontOfSize: 14];
    [_repeatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_repeatBtn setTitle:@"收不到验证码?" forState:UIControlStateNormal];
    _repeatBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    _repeatBtn.hidden = YES;
    [_viewSecond addSubview:_repeatBtn];
    
    __weak typeof (self) thisPoint = self;
    
    btnReInput.actionBlock = ^()
    {
        typeof(self) thisStrongPoint = thisPoint;
        [thisStrongPoint->_codeField endEditing:YES];
        thisStrongPoint->_nCount = 60;
        [thisStrongPoint->_timerCode invalidate];
        [thisStrongPoint->_btnAction setTitle:@"下一步" forState:UIControlStateNormal];
        thisStrongPoint->_btnAction.frame = CGRectMake((CGRectGetWidth(thisStrongPoint.view.frame) - 266) / 2, CGRectGetMaxY(thisStrongPoint->_viewFirst.frame) + 20, 266, 38);
        thisStrongPoint->_viewFirst.hidden = NO;
        thisStrongPoint->_btnSkip.hidden = NO;
        thisStrongPoint->_lbTipsValue.hidden = NO;
        thisStrongPoint->_viewSecond.hidden = YES;
        thisStrongPoint->_lbPhoneNum.text = @"";
        thisStrongPoint->_lbSmsRecTime.text = [NSString stringWithFormat:@"接收短信大约需要%d秒", 60];
        thisStrongPoint->_lbSmsRecTime.hidden = NO;
        thisStrongPoint->_repeatBtn.hidden = YES;
    };
    
    _repeatBtn.actionBlock = ^()
    {
        typeof(self) thisStrongPoint = thisPoint;
        [thisStrongPoint->_codeField endEditing:YES];
        NSString* str=[NSString stringWithFormat:@"%@:%@",@"我们将重新发送验证码短信到这个号码", thisStrongPoint->_telField.text];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"确认手机号码" message:str delegate:thisStrongPoint cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 10;
        [alert show];
    };
}

-(void)viewGenerateThird
{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    _viewThird = [[UIView alloc]init];
    _viewThird.backgroundColor = [UIColor clearColor];
    _viewThird.hidden = YES;
    _viewThird.frame = CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), 200);
    [viewBody addSubview:_viewThird];
    
    if (_bRegisterPhone || _bForgetPwd) {
        UILabel* lbNote = [[UILabel alloc] init];
        lbNote.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 266) / 2, 20, 266, 40);
        lbNote.text = _bForgetPwd ? @"恭喜完成验证,请重新设置登录密码" : @"恭喜完成验证,请再设置一个登录密码";
        lbNote.textAlignment = NSTextAlignmentLeft;
        lbNote.font = [UIFont boldSystemFontOfSize:16];
        lbNote.textColor=[UIColor darkGrayColor];
        lbNote.numberOfLines = 0;
        [_viewThird addSubview:lbNote];
        
        UILabel * lbPassword = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 266) / 2, 80, 266, 24)];
        lbPassword.backgroundColor = [UIColor clearColor];
        lbPassword.textColor = [UIColor darkGrayColor];
        lbPassword.text = @"密码：";
        lbPassword.font = [UIFont boldSystemFontOfSize:14];
        [_viewThird addSubview:lbPassword];
        
        _lePassword = [[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 266) / 2, 105, 266, 30)];
        _lePassword.backgroundColor = [UIColor clearColor];
        _lePassword.font = [UIFont boldSystemFontOfSize:14];
        _lePassword.keyboardType = UIKeyboardTypeASCIICapable;
        _lePassword.tintColor = [UIColor darkGrayColor];
        _lePassword.textColor = [UIColor darkGrayColor];
        _lePassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _lePassword.enablesReturnKeyAutomatically = YES;
        _lePassword.textAlignment = NSTextAlignmentLeft;
        _lePassword.multipleTouchEnabled = YES;
        _lePassword.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _lePassword.layer.borderWidth = 1.0;
        _lePassword.secureTextEntry = YES;
        _lePassword.delegate = self;
        _lePassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
        _lePassword.leftViewMode = UITextFieldViewModeAlways;
        [_viewThird addSubview:_lePassword];
        
        CSButton * btnShowPSW = [CSButton buttonWithType:UIButtonTypeCustom];
        btnShowPSW.frame = CGRectMake(255, 110, 28, 18);
        [btnShowPSW setBackgroundImage:[UIImage imageNamed:@"password-invisible"] forState:UIControlStateNormal];
        [btnShowPSW setBackgroundImage:[UIImage imageNamed:@"password-visible"] forState:UIControlStateSelected];
        btnShowPSW.selected = NO;
        [_viewThird addSubview:btnShowPSW];
        
        UILabel * lbRemind = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 266) / 2, 140, 270, 20)];
        lbRemind.backgroundColor = [UIColor clearColor];
        lbRemind.textColor = [UIColor darkGrayColor];
        lbRemind.text = @"密码数4-12位，英文字母或数字";
        lbRemind.font = [UIFont boldSystemFontOfSize:12];
        [_viewThird addSubview:lbRemind];
        
        __weak typeof (self) thisPoint = self;
        
        __typeof__(CSButton) __weak *thisbtnShowPSW = btnShowPSW;
        btnShowPSW.actionBlock = ^void()
        {
            typeof(self) thisStrongPoint = thisPoint;
            typeof(CSButton*) thisBtnStrongPoint = thisbtnShowPSW;
            
            [thisStrongPoint->_lePassword resignFirstResponder];
            if (thisStrongPoint->_lePassword.secureTextEntry) {
                thisStrongPoint->_lePassword.secureTextEntry = NO;
                thisBtnStrongPoint.selected = YES;
            }
            else
            {
                thisStrongPoint->_lePassword.secureTextEntry = YES;
                thisBtnStrongPoint.selected = NO;
            }
        };
    }
    else
    {
        UIImage *imgBind = [UIImage imageNamed:@"phone-binding-success"];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - imgBind.size.width) / 2, (CGRectGetHeight(self.view.frame) - imgBind.size.height) / 2 - CGRectGetMinY(viewBody.frame), imgBind.size.width, imgBind.size.height)];
        [imgView setImage:imgBind];
        [_viewThird addSubview:imgView];
        
        UILabel* lbBinding = [[UILabel alloc] init];
        lbBinding.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 266) / 2, CGRectGetMaxY(imgView.frame), 266, 40);
        lbBinding.text = @"恭喜完成绑定";
        lbBinding.textAlignment = NSTextAlignmentCenter;
        lbBinding.font = [UIFont boldSystemFontOfSize:16];
        lbBinding.textColor=[UIColor blackColor];
        lbBinding.numberOfLines = 0;
        [_viewThird addSubview:lbBinding];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self generateCommonViewInParent:self.view Title:_bForgetPwd ? @"找回密码" : @"绑定手机" IsNeedBackBtn:YES];
    
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
    
    [self viewGenerateFirst];
    [self viewGenerateSecond];
    [self viewGenerateThird];
    
    UIImage * imgButton = [UIImage imageNamed:@"btn-2-blue"];
    _btnAction = [[CSButton alloc] initNormalButtonTitle:@"下一步" Rect:CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, CGRectGetMaxY(_viewFirst.frame) + 20, 266, 38)];
    [_btnAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnAction setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [_btnAction setBackgroundImage:imgButton forState:UIControlStateNormal];
    [_btnAction setBackgroundImage:[UIImage imageNamed:@"btn-2-grey"] forState:UIControlStateDisabled];
    [_btnAction setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    _btnAction.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [viewBody addSubview:_btnAction];
    
    if (_bRegisterPhone) {
        _btnSkip = [CSButton buttonWithType:UIButtonTypeCustom];
        [_btnSkip.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        _btnSkip.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_btnSkip setTitleColor:[UIColor colorWithRed:98.0 / 255.0 green:197.0 / 255.0 blue:255.0 / 255.0 alpha:1] forState:UIControlStateNormal];
        _btnSkip.backgroundColor = [UIColor clearColor];
        _btnSkip.frame = CGRectMake((CGRectGetWidth(viewBody.frame) - 100) / 2, CGRectGetHeight(viewBody.frame) - 60, 100, 20);
        [_btnSkip setTitle:@"跳过" forState:UIControlStateNormal];
        [viewBody addSubview:_btnSkip];
        
        __weak __typeof(self) weakSelf = self;
        
        _btnSkip.actionBlock = ^(void)
        {
            __typeof(self) strongSelf = weakSelf;
            
            RegisterEmailViewController *registerEmailViewController = [[RegisterEmailViewController alloc]init];
            [strongSelf.navigationController pushViewController:registerEmailViewController animated:YES];
        };
        
        _lbTipsValue = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_btnAction.frame) + 10, 290, 40)];
        _lbTipsValue.backgroundColor = [UIColor clearColor];
        _lbTipsValue.textColor = [UIColor lightGrayColor];
        _lbTipsValue.font = [UIFont systemFontOfSize:13];
        _lbTipsValue.textAlignment = NSTextAlignmentLeft;
        _lbTipsValue.text = @"基于安全的原因，请你进行手机绑定，保护你的帐号和密码。";
        _lbTipsValue.numberOfLines = 0;
        [viewBody addSubview:_lbTipsValue];
    }

    __weak typeof (self) thisPoint = self;
    
    _btnAction.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        
        if (![thisStrongPoint->_viewFirst isHidden]) {
            [thisStrongPoint->_telField endEditing:YES];
            
            if (thisStrongPoint->_telField.text.length != 11) {
                //手机号码不正确
                [JDStatusBarNotification showWithStatus:@"手机号码格式不正确，请重新填写" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                return;
            }
            
            if(!thisStrongPoint->_bForgetPwd)
            {
                [[SportForumAPI sharedInstance]accountCheckExistById:thisStrongPoint->_telField.text AccountType:login_type_phone FinishedBlock:^(int errorCode, NSString* userId)
                 {
                     if (errorCode == 0) {
                         if (userId.length > 0) {
                             [JDStatusBarNotification showWithStatus:@"该手机号已绑定，请使用其他手机号" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                         }
                         else
                         {
                             NSString* str=[NSString stringWithFormat:@"%@: %@%@",@"我们将发送验证码到这个号码",thisStrongPoint->_areaCodeField.text,thisStrongPoint->_telField.text];
                             thisStrongPoint->_str = [NSString stringWithFormat:@"%@",thisStrongPoint->_telField.text];
                             UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"确认手机号码" message:str delegate:thisStrongPoint cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                             [alert show];
                         }
                     }
                     else
                     {
                         [JDStatusBarNotification showWithStatus:@"检查数据异常" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                     }
                 }];
            }
        }
        else if(![thisStrongPoint->_viewSecond isHidden])
        {
            [thisStrongPoint->_codeField endEditing:YES];
            
            if(thisStrongPoint->_codeField.text.length!=4)
            {
                [JDStatusBarNotification showWithStatus:@"验证码格式错误,请重新填写" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            }
            else
            {
                NSLog(@"去服务端进行验证中...");
                
                [thisStrongPoint showCommonProgress:@"正在验证中..."];
                
                [SMS_SDK commitVerifyCode:thisStrongPoint->_codeField.text result:^(enum SMS_ResponseState state) {
                    [thisStrongPoint hidenCommonProgress];
                    
                    if (1==state) {
                        NSLog(@"block 验证成功");
                        NSString* str=[NSString stringWithFormat:@"验证码正确"];
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"验证成功" message:str delegate:thisStrongPoint cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alert.tag = 11;
                        [alert show];
                    }
                    else if(0==state)
                    {
                        NSLog(@"block 验证失败");
                        NSString* str=[NSString stringWithFormat:@"验证码无效 请重新获取验证码"];
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"验证失败" message:str delegate:thisStrongPoint cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }];
            }
        }
        else if((thisStrongPoint->_bForgetPwd || thisStrongPoint->_bRegisterPhone) && ![thisStrongPoint->_viewThird isHidden])
        {
            typeof(self) thisStrongPoint = thisPoint;
            NSString * strPassword = thisStrongPoint->_lePassword.text;
            strPassword = [strPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [thisStrongPoint->_lePassword resignFirstResponder];
            
            if([strPassword isEqualToString:@""])
            {
                [JDStatusBarNotification showWithStatus:@"密码不能为空！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                return;
            }
            
            if(strPassword.length < 4)
            {
                [JDStatusBarNotification showWithStatus:@"您输入的密码位数不够，至少4位字母或数字！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                return;
            }

            if(thisStrongPoint->_bRegisterPhone)
            {
                NSMutableDictionary *regProfileDict = [[ApplicationContext sharedInstance] getObjectByKey:@"RegProfile"];
                NSString *strNickName = [regProfileDict objectForKey:@"NickName"];
                NSString *strProUrl = [regProfileDict objectForKey:@"ProfileUrl"];
                NSString *strSexType = [regProfileDict objectForKey:@"SexType"];
                long long lBirthday = [[regProfileDict objectForKey:@"Birthday"]longLongValue];
                
                id process = [AlertManager showCommonProgress];
                
                [[ApplicationContext sharedInstance]createAccountWithId:thisStrongPoint->_telField.text password:strPassword Type: login_type_phone nikeName:strNickName ProfileUrl:strProUrl Gender:[strSexType isEqualToString:@"男"] ? @"male" : @"female"  Birthday:lBirthday FinishedBlock:^(int errorCode, NSString* strErr, NSString* strUserId)
                 {
                     [AlertManager dissmiss:process];
                     
                     if (errorCode == 0) {
                         RecommendViewController *recommendViewController = [[RecommendViewController alloc]init];
                         [thisStrongPoint.navigationController pushViewController:recommendViewController animated:NO];
                     }
                     else
                     {
                         [JDStatusBarNotification showWithStatus:strErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                     }
                 }];
            }
            else if(thisStrongPoint->_bForgetPwd)
            {
                id process = [AlertManager showCommonProgress];
                
                [[SportForumAPI sharedInstance]userResetPwdByPhone:thisStrongPoint->_telField.text Password:strPassword FinishedBlock:^void(int errorCode, NSString* strDescErr){
                    if (errorCode == 0) {
                        [[ApplicationContext sharedInstance] login:thisStrongPoint->_telField.text key:strPassword type:login_type_phone reset:YES FinishedBlock:^(int errorCode, NSString* strErr, NSString* strUserId){
                            [AlertManager dissmiss:process];
                            
                            if (errorCode == 0) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_SWITCH_VIEW object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:VIEW_MAIN_PAGE, @"PageName", nil]];
                            }
                            else
                            {
                                [JDStatusBarNotification showWithStatus:strErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                            }
                        }];
                    }
                    else
                    {
                        [AlertManager dissmiss:process];
                        [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                    }
                }];
            }
        }
    };
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [MobClick beginLogPageView:@"绑定手机 - BindPhoneViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"绑定手机 - BindPhoneViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hidenCommonProgress];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [MobClick endLogPageView:@"绑定手机 - BindPhoneViewController"];
}

-(void)showCommonProgress:(NSString*)strText{
    if (m_processWindow) {
        [self hidenCommonProgress];
    }
    
    if (strText.length > 0) {
        m_processWindow = [AlertManager showCommonProgressWithText:strText];
    }
    else
    {
        m_processWindow = [AlertManager showCommonProgress];
    }
}

-(void)hidenCommonProgress {
    [AlertManager dissmiss:m_processWindow];
    m_processWindow = nil;
}

-(void)dismissAlertView {
    if (_alertView) {
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView.delegate = nil;
        _alertView = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"BindPhoneViewController dealloc called!");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL bAllowWord = YES;
    
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    [newtxt replaceCharactersInRange:range withString:string];
    
    if(textField == _telField) {
        if ([newtxt length] > 11)
        {
            bAllowWord = NO;
        }
        else
        {
            bAllowWord = [[CommonUtility sharedInstance]isAllowChar:newtxt AlowedChars:@"0123456789"];
        }
    }
    
    return bAllowWord;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //不允许用户输入 国家码
    if (textField==_areaCodeField) {
        [self.view endEditing:YES];
    }
    NSLog(@"textFieldDidBeginEditing");
}

-(void)updateTime
{
    _nCount--;
    if (_nCount < 0) {
        [_timerCode invalidate];
        _lbSmsRecTime.hidden = YES;
        _repeatBtn.hidden = NO;
        return;
    }
    
    _lbSmsRecTime.text=[NSString stringWithFormat:@"接收短信大约需要%d秒", _nCount];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11) {
        if (_bRegisterPhone || _bForgetPwd) {
            [_timerCode invalidate];
            _btnAction.frame = CGRectMake((CGRectGetWidth(self.view.frame) - 266) / 2, 230, 266, 38);
            [_btnAction setTitle:@"完成" forState:UIControlStateNormal];
            _viewThird.hidden = NO;
            _viewFirst.hidden = YES;
            _viewSecond.hidden = YES;
            _btnSkip.hidden = YES;
            _lbTipsValue.hidden = YES;
        }
        else
        {
            [_timerCode invalidate];
            UserUpdateInfo *userUpdateInfo = [[UserUpdateInfo alloc]init];
            userUpdateInfo.phone_number = _telField.text;
            
            [self showCommonProgress:@""];
            
            [[SportForumAPI sharedInstance] userSetInfoByUpdateInfo:userUpdateInfo FinishedBlock:^void(int errorCode, NSString* strDescErr, ExpEffect* expEffect)
             {
                 [self hidenCommonProgress];
                 
                 if (errorCode == 0) {
                     _btnAction.hidden = YES;
                     _viewThird.hidden = NO;
                     _viewFirst.hidden = YES;
                     _viewSecond.hidden = YES;
                     _btnSkip.hidden = YES;
                     _lbTipsValue.hidden = YES;
                     
                     UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                     [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                      {
                          if (errorCode == 0)
                          {
                              [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
                          }
                      }];
                 }
                 else
                 {
                     [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                 }
             }];
        }
    }
    else
    {
        if (1==buttonIndex)
        {
            NSLog(@"点击了确定按钮");
            
            [self showCommonProgress:@"正在发送中..."];
            NSString* str2=[_areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@""];
            
            [SMS_SDK getVerifyCodeByPhoneNumber:_telField.text AndZone:str2 result:^(enum SMS_GetVerifyCodeResponseState state) {
                [self hidenCommonProgress];
                
                if (1==state) {
                    NSLog(@"block 获取验证码成功");
                    
                    if (alertView.tag == 10) {
                        [_timerCode invalidate];
                        return;
                    }
                    
                    _btnAction.frame = CGRectMake((CGRectGetWidth([self.view viewWithTag:GENERATE_VIEW_BODY].frame) - 266) / 2,  230, 266, 38);
                    [_btnAction setTitle:@"提交" forState:UIControlStateNormal];
                    _viewFirst.hidden = YES;
                    _viewSecond.hidden = NO;
                    _viewThird.hidden = YES;
                    _btnSkip.hidden = YES;
                    _lbTipsValue.hidden = YES;
                    _lbPhoneNum.text = _telField.text;
                    _lbSmsRecTime.text = [NSString stringWithFormat:@"接收短信大约需要%d秒", 60];
                    _lbSmsRecTime.hidden = NO;
                    _repeatBtn.hidden = YES;
                    
                    _nCount = 60;
                    [_timerCode invalidate];
                    _timerCode=[NSTimer scheduledTimerWithTimeInterval:1
                                                                target:self
                                                              selector:@selector(updateTime)
                                                              userInfo:nil
                                                               repeats:YES];
                }
                else if(0==state)
                {
                    NSLog(@"block 获取验证码失败");
                    NSString* str=[NSString stringWithFormat:@"验证码发送失败 请稍后重试"];
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"发送失败" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else if (SMS_ResponseStateMaxVerifyCode==state)
                {
                    NSString* str=[NSString stringWithFormat:@"请求验证码超上限 请稍后重试"];
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"超过上限" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
                {
                    NSString* str=[NSString stringWithFormat:@"客户端请求发送短信验证过于频繁"];
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }
        if (0==buttonIndex) {
            NSLog(@"点击了取消按钮");
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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