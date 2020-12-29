//
//  HK_CodeReceived.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/8/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_CodeReceived.h"
#import "LQ_PasswordView.h"
#import "HK_setNewPassController.h"
#import "HKLoginViewController.h"
#import "HK_BaseRequest.h"
@interface HK_CodeReceived ()

@property (nonatomic, strong) UILabel *sendPhoneLabel;
@property (nonatomic, strong) UILabel * reSubmitBtn;
@property (nonatomic, strong) LQ_PasswordView * passWordView;
@property (nonatomic ,copy)NSString *codeString;
@property (nonatomic, strong) UIButton * passWordLognBtn;

@end

@implementation HK_CodeReceived

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
-(void)leftBtnPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initNav {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(leftBtnPressed:) image:[UIImage imageNamed:@"selfMediaClass_back"]];
    if (self.typeCode==codeTypeRegister) {
            self.navigationItem.title =@"注册新用户";
    }else if (self.typeCode == codeChangeMobile) {
        self.navigationItem.title =@"验证手机号";
    }
    else {
         self.navigationItem.title =@"找回密码登录";
    }
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
       
       NSForegroundColorAttributeName:RGB(51,51,51)}];
}

-(void)viewWillLayoutSubviews {
    //WEAKSELF
    [self.sendPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(32);
        make.top.equalTo(self.view).offset(50);
        make.height.mas_equalTo(15);
        
    }];
    [self.reSubmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendPhoneLabel);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.sendPhoneLabel.mas_bottom).offset(10);
    }];
    [self.passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reSubmitBtn);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(self.reSubmitBtn.mas_bottom).offset(54);
        make.height.mas_equalTo(60);
        
    }];
  
}
#pragma mark lazyLoad
-(UILabel *)sendPhoneLabel {
    if (!_sendPhoneLabel) {
        _sendPhoneLabel =[[UILabel alloc] init];
        NSString * oneStre = [self.phonString substringWithRange:NSMakeRange(0,3)
                              ];
        NSString * twoStre =[self.phonString substringWithRange:NSMakeRange(3,4)];
        NSString * threeStr =[self.phonString substringWithRange:NSMakeRange(7,4)];
        NSString *phone =[NSString stringWithFormat:@"已发送6位验证码至+86 %@ %@ %@",oneStre,twoStre,threeStr];
        _sendPhoneLabel.text = phone;
        _sendPhoneLabel.textColor =RGB(51,51,51);
        _sendPhoneLabel.font = PingFangSCRegular16;
    }
    return _sendPhoneLabel;
}

-(UILabel *)reSubmitBtn {
    if (!_reSubmitBtn) {
        _reSubmitBtn =[[UILabel alloc] init];
        _reSubmitBtn.textColor =RGB(64,144,247);
        _reSubmitBtn.font =PingFangSCRegular14;
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCodeMesageRequest)];
        _reSubmitBtn.userInteractionEnabled =YES;
        [_reSubmitBtn addGestureRecognizer:tap];
        
    }
    return _reSubmitBtn;
}
-(UIButton *)passWordLognBtn {
    if (!_passWordLognBtn) {
        _passWordLognBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _passWordLognBtn.frame = CGRectMake(CGRectGetMinX(self.passWordView.frame),CGRectGetMaxY(self.passWordView.frame)+15,90,14);
        [_passWordLognBtn setTitle:@"使用密码登录" forState:UIControlStateNormal];
        [_passWordLognBtn setTitleColor:RGB(64,144,247) forState:UIControlStateNormal];
        _passWordLognBtn.titleLabel.font =PingFangSCRegular14;
        [_passWordLognBtn addTarget:self action:@selector(phoneLogin) forControlEvents:UIControlEventTouchUpInside];
     
    }
    return _passWordLognBtn;
}
-(void)sendPrendRequest {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    //极光推送ID
    [dic setObject:kUUID forKey:@"registrationID"];
    [HK_BaseRequest buildPostRequest:get_usePresendMessage body:dic success:^(id  _Nullable responseObject) {
        
        self.presString =responseObject[@"data"][@"verificationCode"];
        //请求短信验证码
        [self getCodeMesageRequest];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //预先调接口
    [self sendPrendRequest];

    self.view.backgroundColor =[UIColor whiteColor];
    [self  initNav];
    [self.view addSubview:self.sendPhoneLabel];
    [self.view  addSubview:self.reSubmitBtn];
    [AppUtils getMessageCodeWithLabel:self.reSubmitBtn];
    LQ_PasswordView *view = [[LQ_PasswordView alloc]initWithFrame:CGRectMake(31,140, self.view.frame.size.width-31*2, 54)];
    view.num = 6;
    self.passWordView = view;
   @weakify(view)
    view.callBackBlock = ^(NSString *text) {
        DLog(@"最终text== %@",text);
        @strongify(view)
        if ([text isEqualToString:self.codeString]) {
            [view.textField resignFirstResponder];
            if (self.typeCode ==codeTypeGetPassWord) {
             //当验证码匹配时跳转找回密码
                HK_setNewPassController *passVc =[[HK_setNewPassController alloc] init];
                passVc.phonString = self.phonString;
                [self.navigationController pushViewController:passVc animated:YES];
                
            }else {
                NSString * sendTypeStr;
                if (self.typeCode ==codePhoneLogin) {
                    
                     sendTypeStr = get_loginByCode;
                }else if (self.typeCode == codeChangeMobile) {
                    sendTypeStr = get_userUpdateMobile;
                }
                else {
                     sendTypeStr = get_userRegister;
                }
                //输入验证完成进行注册
                NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                //极光推送ID
                [dic setObject:kUUID forKey:@"registrationID"];
                [dic setObject:self.phonString forKey:@"mobile"];
                if (self.typeCode == codeChangeMobile) {
                    [dic setValue:self.previsPhone forKey:@"ymobile"];
                }
                [dic setObject:self.codeString forKey:@"verificationCode"];
                [HK_BaseRequest buildPostRequest:sendTypeStr body:dic success:^(id  _Nullable responseObject) {

                            NSInteger code = [responseObject[@"code"] integerValue];
                            if (code) {
                                //拿到与推送相关的登录码
                                NSString *meg = responseObject[@"msg"];
                                if (meg.length) {
                                    [EasyShowTextView showText:meg];
                                }
                            }
                            else {
                                if ([sendTypeStr isEqualToString:get_userRegister]) {

                                    [self handleSuccessLoginRegister:responseObject];
                                }else {
                                    if (self.typeCode ==codeChangeMobile) {
                                   // pop 到账户界面..
                                        Class  vc = NSClassFromString(@"HKAccountVc");
                                        
                                        for(UIViewController *temVC in self.navigationController.viewControllers)
                                        {
                                            if ([temVC  isKindOfClass:vc]) {
                                                
                                                [self.navigationController popToViewController:temVC animated:YES];
                                            }
                                        }
                                    }else {
                                        [self handleSuccessLoginRegister:responseObject];
                                    }
                                }
                        }
                } failure:^(NSError * _Nullable error) {
                    
                }];
            }
            
        }else{
            [EasyShowTextView showText:@"验证码有误"];
            
            [view cleanPassword:@"error"];

        }
    };
    [view showPassword];
    [self.view addSubview:view];
    if (self.typeCode == codeChangeMobile) {
        
    }else {
        [self.view addSubview:self.passWordLognBtn];
    }
}

#pragma mark 注册登录成功..
-(void)handleSuccessLoginRegister:(id)responseObject {
    //用户信息保存到本地中
    LoginUserData * data =[LoginUserDataModel getUserInfoItems];
    data.name = nil;
    data.uid = nil;
    [LoginUserDataModel clearLoginUse];
    [LoginUserDataModel saveLoginUser:responseObject];
    [self dismissViewControllerAnimated:YES completion:nil];
    [LoginUserDataModel saveUserInfoUsername:self.phonString];
}
#pragma mark 使用密码登录
-(void)phoneLogin {
    HKLoginViewController * log =[[HKLoginViewController alloc] init];
    [self.navigationController pushViewController:log animated:YES];
    
}
-(void)getCodeMesageRequest {
    //获取验证码类型....
    NSString * codetypeStr ;
    if (self.typeCode == codeTypeGetPassWord) {
        //忘记密码
        codetypeStr = get_userSendforgetmessage;
        
    }else if (self.typeCode == codeTypeRegister) {
        
        codetypeStr = get_userSendregistermessage;
    }else if (self.typeCode == codeChangeMobile){
        codetypeStr = get_userUpdateregistermessage;
    }
    else  {
        codetypeStr = get_userSendloginmessage;
    }
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    //极光推送ID
    [dic setObject:kUUID forKey:@"registrationID"];
    [dic setObject:self.phonString forKey:@"mobile"];
    if (self.typeCode == codeChangeMobile) {
        [dic setValue:self.previsPhone forKey:@"ymobile"];
    }
    [dic setObject:self.presString forKey:@"verificationCode"];
    
    [HK_BaseRequest buildPostRequest:codetypeStr body:dic success:^(id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==1) {
            [EasyShowTextView showText:[responseObject objectForKey:@"msg"]];
        }else {
            //拿到验证码
#if Urldebug
            [SVProgressHUD showSuccessWithStatus:responseObject[@"data"][@"verificationCode"]];
#else
#endif
            self.codeString = responseObject[@"data"][@"verificationCode"];
        }
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
@end
