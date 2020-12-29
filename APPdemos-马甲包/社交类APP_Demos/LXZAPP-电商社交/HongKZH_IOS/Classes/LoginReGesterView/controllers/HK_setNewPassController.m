//
//  HK_setNewPassController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_setNewPassController.h"
#import "HK_BaseRequest.h"
@interface HK_setNewPassController ()<UITextFieldDelegate>

{
    NSString  * _preMessageCode;
    NSString  * _PassWordString;
    NSString  * _defineString;
    UILabel * _messageLabel;
}
@property (nonatomic, strong)UITextField * phoneInput;
@property (nonatomic, strong)UIButton * nextStepBtn;
@property (nonatomic, strong)UIView *lineTwoV;

@end

@implementation HK_setNewPassController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self initNav];
    [self setSubViews];
   
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)initNav {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBtnPressed:) image:[UIImage imageNamed:@"selfMediaClass_back"]];
    
    self.navigationItem.title =@"设置新密码";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
       
       NSForegroundColorAttributeName:RGB(51,51,51)}];
}

-(void)setSubViews {
    UILabel * label =[[UILabel alloc] init];
    [self.view addSubview:label];
    _messageLabel = label;
    NSString * oneStre = [self.phonString substringWithRange:NSMakeRange(0,3)
                          ];
    NSString * twoStre =[self.phonString substringWithRange:NSMakeRange(3,4)];
    NSString * threeStr =[self.phonString substringWithRange:NSMakeRange(7,4)];
    NSString *phone =[NSString stringWithFormat:@"请为账号 %@ %@ %@ 设置一个新密码",oneStre,twoStre,threeStr];
    [AppUtils getConfigueLabel:label font:PingFangSCRegular16 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:phone];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(31);
        make.top.equalTo(self.view).offset(50);
        make.height.mas_equalTo(16);
        
    }];
    [self.view addSubview:self.phoneInput];
    [self.phoneInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label);
        make.top.equalTo(label.mas_bottom).offset(50);
        make.width.mas_equalTo(kScreenWidth-62);
        make.height.mas_equalTo(20);
        
    }];
    [self.view addSubview:self.lineTwoV];
    [self.lineTwoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneInput.mas_left);
        make.right.equalTo(self.phoneInput.mas_right);
        make.top.equalTo(self.phoneInput.mas_bottom).offset(6);
        make.height.mas_equalTo(1);
    }];
    
    [self.view addSubview:self.nextStepBtn];
    [self.nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineTwoV);
        make.top.equalTo(self.lineTwoV.mas_bottom).offset(36);
        make.width.mas_equalTo(kScreenWidth-62);
        make.height.mas_equalTo(50);
    }];
}
-(UIView *)lineTwoV {
    if (!_lineTwoV) {
        _lineTwoV =[[UIView alloc] init];
        _lineTwoV.backgroundColor=RGB(242, 242, 242);
    }
    return _lineTwoV;
}
//输入框改变调用
-(void)inputChanged {
    if (self.phoneInput.text.length && self.phoneInput.text.length >=8) {
        self.nextStepBtn.backgroundColor = RGB(74,145, 233);
        self.nextStepBtn.enabled = YES;
    }else {
        _nextStepBtn.backgroundColor =RGB(204,204, 204);
        self.nextStepBtn.enabled  = NO;
    }
}
//验证手机号是否可用
-(BOOL)verifyPhoneNumbers:(NSString *)phoneNumberStr {
    
    NSString * regex = @"^[A-Za-z0-9]{9,15}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
   
    BOOL isMatch = [pred evaluateWithObject:phoneNumberStr];
    if (isMatch) {
        return YES;
    }
    return  NO;
}
//输入密码
-(void)nextPage {
    [self.phoneInput resignFirstResponder];
    //验证输入密码的合法性.......(只包含数字和字母)
    if (![self verifyPhoneNumbers:self.phoneInput.text]) {

        [EasyShowTextView showText:@"输入的密码不合法"];

    }else {
        //存在密码说明在二次验证
        if (!_PassWordString.length && !_defineString.length) {
            [self setNewPassWord];
           
        }else if (_PassWordString.length && !_defineString.length) {
            //验证对比
            _defineString = self.phoneInput.text;
            if ([_defineString isEqualToString:_PassWordString]) {
                
                [self setNewPassWordRequest];
            }else {
                [EasyShowTextView showText:@"输入密码不一致"];
            }
        }
    }
}
#pragma mark 验证密码设置密码
-(void)setNewPassWordRequest {
    
    NSMutableDictionary * params =[[NSMutableDictionary alloc] init];
    [params setValue:kUUID forKey:@"registrationID"];
    [params setValue:self.phonString forKey:@"mobile"];
    [params setValue:_defineString forKey:@"password"];
    [HK_BaseRequest buildPostRequest:get_userSetForgetCode body:params success:^(id  _Nullable responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code) {
            NSString *meg = responseObject[@"msg"];
            if (meg.length) {
                [EasyShowTextView showText:meg];
            }
        }else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
#pragma mark 第一次保存密码
-(void)setNewPassWord {
    //密码输入完成 更改文字 并清空输入框
    _PassWordString = self.phoneInput.text;
    _messageLabel.text =@"请再次确认密码";
    self.phoneInput.text = @"";
    [self.phoneInput becomeFirstResponder];
    self.nextStepBtn.backgroundColor =RGB(204,204, 204);
    self.nextStepBtn.enabled  = NO;
}

-(UIButton *)nextStepBtn {
    if (!_nextStepBtn) {
        _nextStepBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_nextStepBtn setTitle:@"保存新密码" forState:UIControlStateNormal];
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
-(UITextField *)phoneInput {
    if (!_phoneInput) {
        _phoneInput =[[UITextField alloc] init];
        _phoneInput.textColor = RGB(51,51,51);
        _phoneInput.placeholder = @"请设置8-32位(数字+字母)";
        [_phoneInput setValue:[UIColor colorFromHexString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
        [_phoneInput setValue:PingFangSCRegular16 forKeyPath:@"_placeholderLabel.font"];
        _phoneInput.delegate = self;
        _phoneInput.secureTextEntry = YES;
        [_phoneInput addTarget:self action:@selector(inputChanged) forControlEvents:UIControlEventEditingChanged];
        _phoneInput.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _phoneInput;
}
//-(void)Business_Request_State:(BusinessRequestType)type statusCode:(NSInteger)statusCode responseJsonObject:(id)jsonObj {
//    
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
-(void)leftBtnPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
