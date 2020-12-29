//
//  HK_ForGetCodeController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//
//找回密码
#import "HK_ForGetCodeController.h"
#import "HK_LoginRegesterTool.h"

@interface HK_ForGetCodeController ()<UITextFieldDelegate>
{
    NSString  * _preMessageCode;
}
@property (nonatomic, strong)UITextField * phoneInput;
@property (nonatomic, strong)UIButton * nextStepBtn;
@property (nonatomic, strong)UIView *lineTwoV;

@end

@implementation HK_ForGetCodeController
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
    if (self.fromAccount) {
          self.navigationItem.title =@"登录密码";
    }else {
         self.navigationItem.title =@"找回登录密码";
    }
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
       
       NSForegroundColorAttributeName:RGB(51,51,51)}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self initNav];
    [self setSubViews];
}

-(void)setSubViews {
    UILabel * label =[[UILabel alloc] init];
    [self.view addSubview:label];
    [AppUtils getConfigueLabel:label font:PingFangSCRegular16 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"请填写你要找回密码的账号"];
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
        [HK_LoginRegesterTool pushCodeSendMessageVcWithPreCode:_preMessageCode andPhone:self.phoneInput.text withTypeCode:codeTypeGetPassWord onCurrentVc:self];
    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
