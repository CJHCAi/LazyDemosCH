//
//  HK_ReGisterView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/8/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_ReGisterView.h"
#import "HK_LoginRegesterTool.h"
#import "HK_ShareViews.h"
#import "WXApi.h"
#import "HKWebInfoVc.h"
@interface HK_ReGisterView ()<UITextFieldDelegate,TencentSessionDelegate>
{
    NSString * _preMessageCode;
    NSString * _verifyCode;

    NSMutableArray *_permissionArray;   //权限列表
    
}
@property (nonatomic, strong) UILabel * phoneDresslabel;
@property (nonatomic, strong) UIButton * selectCountyBtn;
@property (nonatomic, strong) UIView * liveOneV;
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UITextField * phoneInput;
@property (nonatomic, strong) UIButton * nextStepBtn;
@property (nonatomic, strong) UIButton * otherTypeBtn;
@property (nonatomic, strong) UILabel * bottomMessageLabel;
@property (nonatomic, strong) UIView *lineTwoV;
@property (nonatomic, strong) TencentOAuth * tencentOAuth;

@end

@implementation HK_ReGisterView

#pragma mark 懒加载布局子视图
-(UILabel *)phoneDresslabel {
    if (!_phoneDresslabel) {
        _phoneDresslabel =[[UILabel alloc] init];
        _phoneDresslabel.text =@"手机号归属地";
        _phoneDresslabel.textColor =RGB(51,51,51);
        _phoneDresslabel.font = PingFangSCRegular16;
        
    }
    return _phoneDresslabel;
}

-(UIButton *)selectCountyBtn {
    if (!_selectCountyBtn) {
        //
        _selectCountyBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_selectCountyBtn setTitle:@"中国" forState:UIControlStateNormal];
        [_selectCountyBtn setImage:[UIImage imageNamed:@"right-gray"] forState:UIControlStateNormal];
        [_selectCountyBtn setTitleColor:RGB(64,144,247) forState:UIControlStateNormal];
        _selectCountyBtn.titleLabel.font =PingFangSCRegular14;
        _selectCountyBtn.hidden =YES;
     
    }
    return _selectCountyBtn;
}

-(UIView *)liveOneV {
    if (!_liveOneV) {
        _liveOneV =[[UIView alloc] init];
        _liveOneV.backgroundColor=RGB(242, 242, 242);
        
    }
    return _liveOneV;
}

-(UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel =[[UILabel alloc] init];
        _numberLabel.text =@"+86";
        _numberLabel.textColor =RGB(51,51,51);
        _numberLabel.font = PingFangSCRegular14;
    }
    return _numberLabel;
}
-(UITextField *)phoneInput {
    if (!_phoneInput) {
        _phoneInput =[[UITextField alloc] init];
        _phoneInput.textColor = RGB(51,51,51);
        _phoneInput.placeholder = @"请输入手机号";
        [_phoneInput setValue:RGB(153,153,153) forKeyPath:@"_placeholderLabel.textColor"];
        [_phoneInput setValue:PingFangSCRegular16 forKeyPath:@"_placeholderLabel.font"];
        _phoneInput.delegate = self;
        _phoneInput.keyboardType = UIKeyboardTypeNumberPad;
        [_phoneInput addTarget:self action:@selector(inputChanged) forControlEvents:UIControlEventEditingChanged];
        _phoneInput.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _phoneInput;
}

-(instancetype)init {
    if (self =[super init]) {
        self.sx_disableInteractivePop = YES;
    }
    return  self;
}

-(UIView *)lineTwoV {
    if (!_lineTwoV) {
        _lineTwoV =[[UIView alloc] init];
        _lineTwoV.backgroundColor=RGB(242, 242, 242);
        

    }
    return _lineTwoV;
}
-(UIButton *)nextStepBtn {
    if (!_nextStepBtn) {
        _nextStepBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextStepBtn.backgroundColor = RGB(204,204,204);
        _nextStepBtn.titleLabel.font =PingFangSCRegular16;
        [_nextStepBtn setTitleColor:RGB(255,255,255) forState:UIControlStateNormal];
        [_nextStepBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
        _nextStepBtn.layer.cornerRadius = 5;
        _nextStepBtn.layer.masksToBounds =YES;
        _nextStepBtn.enabled = NO;
        
        
    }
    return _nextStepBtn;
}

-(UIButton *)otherTypeBtn
{
    if (!_otherTypeBtn) {
        _otherTypeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_otherTypeBtn setTitle:@"使用其他方式登录" forState:UIControlStateNormal];
        _otherTypeBtn.titleLabel.font =PingFangSCRegular14;
        [_otherTypeBtn setTitleColor:RGB(64,144,247) forState:UIControlStateNormal];
        [_otherTypeBtn addTarget:self action:@selector(otherTypeLogin) forControlEvents:UIControlEventTouchUpInside];
     
    }
    return _otherTypeBtn;
}

-(UILabel *)bottomMessageLabel {
    if (!_bottomMessageLabel) {
        _bottomMessageLabel =[[UILabel alloc] init];
        NSString * text = @"注册代表您已同意《乐小转用户协议》";
        NSMutableAttributedString *attribute=[[NSMutableAttributedString alloc] initWithString:text];
        [attribute addAttribute:NSForegroundColorAttributeName value:RGB(64,144,247) range:NSMakeRange(8,9)];
        _bottomMessageLabel.font =PingFangSCRegular13;
        _bottomMessageLabel.textColor =RGB(51,51,51);
        _bottomMessageLabel.attributedText = attribute;
        _bottomMessageLabel.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *taoB =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taoBClick)];
        _bottomMessageLabel.userInteractionEnabled = YES;
        [_bottomMessageLabel addGestureRecognizer:taoB];
    }
    return _bottomMessageLabel;
 }
-(void)taoBClick {
    HKWebInfoVc * webIM =[[HKWebInfoVc alloc] init];
    webIM.webTitleIndex =0;
    [self.navigationController pushViewController:webIM animated:YES];
}
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
    [AppUtils setPopHidenNavBarForFirstPageVc:self];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //增加监听 监听三方登录返回的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLogin:) name:WeChatLoginMessage object:nil];
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self initNav];
    [self setSubViews];    
}
//微信登录
-(void)wechatLogin:(NSNotification *)noti {
    
    [HK_LoginRegesterTool WeixinOauthSuccessForApi:noti.object withCurrentVc:self];
}
-(void)setSubViews {
    [self.view addSubview:self.phoneDresslabel];
    [self.view addSubview:self.selectCountyBtn];
    [self.view addSubview:self.liveOneV];
   [self.view addSubview:self.numberLabel];
    [self.view addSubview:self.phoneInput];
    [self.view addSubview:self.lineTwoV];
    [self.view addSubview:self.nextStepBtn];
     [self.view addSubview:self.otherTypeBtn];
    if (![WXApi isWXAppInstalled]||![TencentOAuth iphoneQQInstalled]) {
        self.otherTypeBtn.hidden =YES;
    }
    [self.view addSubview:self.bottomMessageLabel];
    
}
-(void)viewWillLayoutSubviews {
    
    [self.phoneDresslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(31);
        make.top.equalTo(self.view).offset(77);
        make.height.mas_equalTo(15);
        
    }];
    [self.selectCountyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-30);
        make.centerY.equalTo(self.phoneDresslabel);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(49);
        
    }];
    [_selectCountyBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_selectCountyBtn.imageView.size.width, 0,_selectCountyBtn.imageView.size.width)];
    [_selectCountyBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _selectCountyBtn.titleLabel.bounds.size.width+10, 0, -_selectCountyBtn.titleLabel.bounds.size.width)];
    
    [self.liveOneV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneDresslabel);
        make.right.equalTo(self.selectCountyBtn);
        make.height.mas_equalTo(1);
 
        make.top.equalTo(self.phoneDresslabel.mas_bottom).offset(8);

    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneDresslabel);
        make.top.equalTo(self.liveOneV.mas_bottom).offset(40);
        make.height.mas_equalTo(11);
    
    }];
    [self.phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel.mas_right).offset(30);
        make.right.equalTo(self.selectCountyBtn.mas_right);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.liveOneV.mas_bottom).offset(30);

    }];
    [self.lineTwoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.liveOneV.mas_left);
        make.right.equalTo(self.liveOneV.mas_right);
        make.top.equalTo(self.numberLabel.mas_bottom).offset(6);
        make.height.equalTo(self.liveOneV.mas_height);

    }];
    [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel);
        make.right.equalTo(self.selectCountyBtn);
        make.height.mas_equalTo(49);
        make.top.equalTo(self.lineTwoV.mas_bottom).offset(40);

    }];

    [self.otherTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.nextStepBtn);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(14);
        make.top.equalTo(self.nextStepBtn.mas_bottom).offset(25);

    }];
    [self.bottomMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.nextStepBtn);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];

}
//输入框改变调用
-(void)inputChanged {
    if (self.phoneInput.text.length && self.phoneInput.text.length >=11) {
        self.nextStepBtn.backgroundColor = RGB(74,145, 233);
        self.nextStepBtn.enabled = YES;
    }else {
        _nextStepBtn.backgroundColor =RGB(204,204, 204);
        self.nextStepBtn.enabled  = NO;
    }
}
//验证手机号是否可用
-(BOOL)verifyPhoneNumbers:(NSString *)phoneNumberStr {
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumberStr];
    
    if (!isMatch)
    {
        return NO;
    }
    return YES;
}

//跳转到下一页
-(void)nextPage {
    
    [self.phoneInput resignFirstResponder];
   //验证手机号是否有效.......
    if (![self verifyPhoneNumbers:self.phoneInput.text]) {
        [EasyShowTextView showText:@"输入的手机号不合法"];
    }else {
        [HK_LoginRegesterTool pushCodeSendMessageVcWithPreCode:_preMessageCode andPhone:self.phoneInput.text withTypeCode:codeTypeRegister onCurrentVc:self];
    }
}
//其他方式登录
-(void)otherTypeLogin {
    @weakify(self);
        [HK_ShareViews showSelfBotomWithselectSheetBlock:^(NSInteger index) {
            @strongify(self)
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
                  
                }
                    break;
                case 3:
                {
                    [HK_LoginRegesterTool pushLoadControllerWithCurrentVc:self withType:1];
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
/**
 * 获取用户个人信息回调
*/
- (void)getUserInfoResponse:(APIResponse*) response{
    [HK_LoginRegesterTool tencentOauthSuccessApi:response andOpenId:_tencentOAuth.openId withCurrentController:self];
}

-(void)leftBtnPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initNav {
         self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBtnPressed:) image:[UIImage imageNamed:@"selfMediaClass_back"]];
    
    self.navigationItem.title =@"注册新用户";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
       
       NSForegroundColorAttributeName:RGB(51,51,51)}];
    
}
@end
