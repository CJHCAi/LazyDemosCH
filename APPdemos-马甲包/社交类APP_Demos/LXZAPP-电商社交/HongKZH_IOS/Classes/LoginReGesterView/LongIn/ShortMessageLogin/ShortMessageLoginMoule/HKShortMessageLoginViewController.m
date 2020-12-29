//
//  HKShortMessageLoginViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/22.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShortMessageLoginViewController.h"
#import "HKShortMessageView.h"
#import "HKMessageInputVC.h"
#import "HKLoginViewModel.h"
#import "HK_LoginRegesterTool.h"
#import "HK_ShareViews.h"
#import "WXApi.h"
@interface HKShortMessageLoginViewController ()<HKShortMessageViewDelegate,TencentSessionDelegate>
{
    NSString * _preMessageCode;
}
@property (nonatomic, strong)HKShortMessageView *loginInputPhoneView;

@property (nonatomic, strong) TencentOAuth * tencentOAuth;
@end

@implementation HKShortMessageLoginViewController
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //增加监听 监听三方登录返回的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLogin:) name:WeChatLoginMessage object:nil];

    [self setUI];
}
//微信登录
-(void)wechatLogin:(NSNotification *)noti {
    
    [HK_LoginRegesterTool WeixinOauthSuccessForApi:noti.object withCurrentVc:self];
    
}
-(void)sendPrendRequest {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    //极光推送ID
    [dic setObject:kUUID forKey:@"registrationID"];
    
//    [self Business_Request:BusinessRequestType_get_presendMessage dic:dic cache:NO];
    
}
//-(void)Business_Request_State:(BusinessRequestType)type statusCode:(NSInteger)statusCode responseJsonObject:(id)jsonObj{
//    if(BusinessRequestType_get_presendMessage == type)
//    {
//        if (RequsetStatusCodeSuccess == statusCode)
//        {
//            //拿到与推送相关的登录码
//            _preMessageCode = jsonObj[@"data"][@"verificationCode"];
//            
//        }
//    }
//}
-(void)setUI{
    
    self.navigationItem.title = @"登录乐小转";
    [self setShowCustomerLeftItem:YES];
    [self.view addSubview:self.loginInputPhoneView];
  self.loginInputPhoneView.nextBtn.backgroundColor = RGB(204,204,204);
   self.loginInputPhoneView.nextBtn.enabled = NO;
    
   self.loginInputPhoneView.inputTextF.placeholder = @"请输入手机号";
    [self.loginInputPhoneView.inputTextF setValue:RGB(153,153,153) forKeyPath:@"_placeholderLabel.textColor"];
    [self.loginInputPhoneView.inputTextF setValue:PingFangSCRegular16 forKeyPath:@"_placeholderLabel.font"];
    self.loginInputPhoneView.inputTextF.keyboardType = UIKeyboardTypeNumberPad;
    [self.loginInputPhoneView.inputTextF addTarget:self action:@selector(inputChanged) forControlEvents:UIControlEventEditingChanged];
   self.loginInputPhoneView.inputTextF.clearButtonMode = UITextFieldViewModeAlways;
    
    [self.loginInputPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
    }];
    
    
    if (![WXApi isWXAppInstalled]||![TencentOAuth iphoneQQInstalled]) {
        self.loginInputPhoneView.otherTypeLogin.hidden =YES;
    }
  
}
//输入框改变调用
-(void)inputChanged {
    if (self.loginInputPhoneView.inputTextF.text.length && self.loginInputPhoneView.inputTextF.text.length >=11) {
        self.loginInputPhoneView.nextBtn.backgroundColor = RGB(74,145, 233);
        self.loginInputPhoneView.nextBtn.enabled = YES;
    }else {
        self.loginInputPhoneView.nextBtn.backgroundColor =RGB(204,204, 204);
        self.loginInputPhoneView.nextBtn.enabled  = NO;
    }
}
-(void)nextToVc{
    [self.loginInputPhoneView.inputTextF resignFirstResponder];
    
    //验证手机号是否有效.......
    if (![AppUtils verifyPhoneNumbers:self.loginInputPhoneView.inputTextF.text]) {
        
        [EasyShowTextView showText:@"输入的手机号不合法"];
    }else {
        [HK_LoginRegesterTool pushCodeSendMessageVcWithPreCode:_preMessageCode andPhone:self.loginInputPhoneView.inputTextF.text withTypeCode:codePhoneLogin onCurrentVc:self];
    }
}
//弹出分享图
-(void)showLoginViews {
    
    [HK_ShareViews showSelfBotomWithselectSheetBlock:^(NSInteger index) {
        switch (index) {
            case 1:
            {
                [AppUtils sendWechatAuthRequest];
                
            }
                break;
            case 2:
            {
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAppID andDelegate:self];
                NSArray *permissions = @[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE, kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO];
                [self.tencentOAuth authorize:permissions];
                
            }break;
                
            case 3:
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            default:

                break;
        }
    }];
}
#pragma mark QQ登录相关
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    
    /** Access Token凭证，用于后续访问各开放接口 */
    if (_tencentOAuth.accessToken) {
        
        [_tencentOAuth getUserInfo];
    }else{
        
        [EasyShowTextView showText:@"token获取失败"];
    }
}
/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        [EasyShowTextView showText:@"用于取消登录"];
    }else{
        [EasyShowTextView showText:@"登录失败"];
    }
}
/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    
    [EasyShowTextView showText:@"没有网络"];
}
- (void)getUserInfoResponse:(APIResponse*) response{
    
    [HK_LoginRegesterTool tencentOauthSuccessApi:response andOpenId:_tencentOAuth.openId withCurrentController:self];
}
-(HKShortMessageView *)loginInputPhoneView{
    if (!_loginInputPhoneView) {
        _loginInputPhoneView = [[HKShortMessageView alloc]init];
        _loginInputPhoneView.delegate = self;
    }
    return _loginInputPhoneView;
}
@end
