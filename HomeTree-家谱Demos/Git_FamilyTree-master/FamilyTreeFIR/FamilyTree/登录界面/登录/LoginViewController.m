//
//  LoginViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "LoginViewController.h"
#import "ToRegistView.h"
#import "LoginModel.h"
#import "RootTabBarViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayOrder.h"
#import <AVFoundation/AVFoundation.h>
#define ReGistView_height 180
#define AnimationsTime 0.4f
@interface LoginViewController ()<LoginViewDelegate,ToRegisViewDelegate>

@property (nonatomic,strong) LoginView *loginView; /*登录界面*/

@property (nonatomic,strong) ToRegistView *regisView; /*注册view*/

@property (nonatomic,strong) RootTabBarViewController *tabBarVc; /*标签控制器*/
/** 验证码*/
@property (nonatomic, assign) NSInteger verificationCode;
/** 音乐播放器*/
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation LoginViewController
#pragma mark *** lifeCircle ***
- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.view addSubview:self.loginView];

    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *** ToRegisterViewDelegate ***
//点击获取验证码
-(void)ToRegisViewDidSelectedVerfication:(ToRegistView *)registView{
    MYLog(@"获取验证码");
     NSLog(@"%@", registView.accountView.inputTextView.text);
    self.verificationCode = arc4random() % 10000 + (arc4random()%9+1)*100000;
    MYLog(@"%ld",(long)self.verificationCode);
    [TCJPHTTPRequestManager POSTWithParameters:@{@"mobile":registView.accountView.inputTextView.text,@"content":[NSString stringWithFormat:@"%ld",(long)self.verificationCode]} requestID:@0 requestcode:@"sendsms" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@", jsonDic[@"message"]);
        if (succe) {
            
            
        }
    } failure:^(NSError *error) {
        //NSLog(@"%@", error.description);
    }];
    
}

//点击立即注册

-(void)ToRegisViewDidSelectedRegistBtn:(ToRegistView *)registView{
    
    
    NSString *accStr = registView.accountView.inputTextView.text;
    NSString *pasStr = registView.passwordView.inputTextView.text;
//    NSNumber *lng = @0;
//    NSNumber *lat = @0;
 
    MYLog(@"acc-%@pas-%@", accStr,pasStr);
    
    if ([pasStr isEqualToString:[NSString stringWithFormat:@"%ld",(long)self.verificationCode]]) {
        NSDictionary *dic = @{@"MeAccount":accStr,@"MePassword":pasStr,@"MeLng":@"0",@"MeLat":@"0"};
        //    NSDictionary *dic = @{@"MeAccount":accStr,@"MePassword":pasStr};
        
        
        [TCJPHTTPRequestManager POSTWithParameters:dic requestID:@0 requestcode:kRequestCodeRegister success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            MYLog(@"%@",jsonDic);
            if ([jsonDic[@"resultcode"] isEqualToString:@"00000003"]) {
               [SXLoadingView showAlertHUD:jsonDic[@"message"] duration:0.5];
            }
            if (succe) {
                if (![jsonDic[@"message"] isEqualToString:@"注册成功"]) {
                    [SXLoadingView showAlertHUD:jsonDic[@"message"] duration:0.5];
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册成功" message:[NSString stringWithFormat:@"您的初始密码是%ld", (long)self.verificationCode] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self dismissViewControllerAnimated:NO completion:nil];
                    }];
                    [alert addAction:sureAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error.description);
        }];
        
        MYLog(@"立即注册");

    }else{
        [SXLoadingView showAlertHUD:@"验证码不正确" duration:0.5];
    }
}

#pragma mark *** LoginViewDelegate ***
//选中上端菜单
-(void)loginView:(LoginView *)loginView didSelectedTopViewBtn:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
     
            //注册和登录动态切换
            [self.loginView.topView.regisBtn.titleLabel.text isEqualToString:@"注册"]?[self.loginView.topView.regisBtn setTitle:@"登录" forState:0]:[self.loginView.topView.regisBtn setTitle:@"注册" forState:0];
           
            
            [self.view addSubview:self.regisView];
            
            
            [UIView animateWithDuration:AnimationsTime animations:^{
                
                if (IsEquallString(self.loginView.topView.regisBtn.titleLabel.text, @"登录")) {
                    //移到屏幕外
                    self.loginView.accountView.center = CGPointMake(-250, self.loginView.accountView.center.y);
                    self.loginView.passwordView.center = CGPointMake(-250, self.loginView.passwordView.center.y);
                    self.loginView.accountView.alpha = 0;
                    self.loginView.passwordView.alpha = 0;
                    
                    //移到屏幕内
                    self.regisView.frame = CGRectMake(self.view.center.x-_regisView.bounds.size.width/2, CGRectGetMinY(self.loginView.accountView.frame), 0.8*Screen_width,ReGistView_height);
                    self.regisView.alpha = 1.0;
                    
                }else{
                    
                //移到屏幕内
                self.loginView.accountView.center = CGPointMake(self.view.center.x, self.loginView.accountView.center.y);
                self.loginView.passwordView.center = CGPointMake(self.view.center.x, self.loginView.passwordView.center.y);
                self.loginView.accountView.alpha = 1;
                self.loginView.passwordView.alpha = 1;
                //移到屏幕外
                self.regisView.frame = CGRectMake(700, CGRectGetMinY(self.loginView.accountView.frame), 0.8*Screen_width, ReGistView_height);
                self.regisView.alpha = 0;
                    
                }
            } completion:^(BOOL finished) {
                
                
            }];
            
        }
            
            break;
        case 1:
        {
            MYLog(@"找回密码");
            //找回密码
            FindPassViewController *finPassVc = [[FindPassViewController alloc]init];
            [self.navigationController pushViewController:finPassVc animated:YES];
            
        }
            break;
        default:
            break;
    }
}
//选中三方登录按钮
-(void)loginView:(LoginView *)loginView didSelectedOtherLoginBtn:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            NSLog(@"qq");
        }
            break;
        case 1:
        {
            NSLog(@"weixin");
            
            if (![WXApi isWXAppInstalled]) {
                [Tools showAlertViewcontrollerWithTarGet:self Message:@"未安装微信" complete:^(BOOL sure) {
                    
                }];
                return;
            }else{
                [Tools showAlertViewcontrollerWithTarGet:self Message:@"安装了微信" complete:^(BOOL sure) {
                    
                }];
                return;
            }
//            if(![WXApi isWXAppSupportApi]){
//                [Tools showAlertViewcontrollerWithTarGet:self Message:@"此版本不支持支付" complete:^(BOOL sure) {
//                    
//                }];
//                return;
//            }
            
            NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
            //解析服务端返回json数据
            NSError *error;
            //加载一个NSURL对象
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            //将请求的url数据放到NSData对象中
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            if ( response != nil) {
                NSMutableDictionary *dict = NULL;
                //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
                dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                
                NSLog(@"url:%@",urlString);
                if(dict != nil){
                    NSMutableString *retcode = [dict objectForKey:@"retcode"];
                    if (retcode.intValue == 0){
                        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                        
                        //调起微信支付
                        PayReq* req             = [[PayReq alloc] init];
                        req.partnerId           = [dict objectForKey:@"partnerid"];
                        req.prepayId            = [dict objectForKey:@"prepayid"];
                        req.nonceStr            = [dict objectForKey:@"noncestr"];
                        req.timeStamp           = stamp.intValue;
                        req.package             = [dict objectForKey:@"package"];
                        req.sign                = [dict objectForKey:@"sign"];
                        [WXApi sendReq:req];
                        //日志输出
                        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                        
                    }else{
                        NSLog(@"%@",  [dict objectForKey:@"retmsg"]);
                    }
                }else{
                    NSLog(@"服务器返回错误，未获取到json对象");
                }
            }else{
                NSLog(@"服务器返回错误");
            }

        }
            break;
        
        case 2:
        {
            NSLog(@"weibo");
            /*
             *在调用支付宝之前，需要我们将相关订单参数发送至我们的后台服务器，由后台服务器进行签名等处理，并返回客户端所有相关参数，
             客户端直接使用参数调起支付宝支付
             */
            
            /*
             *商户的唯一的parnter和seller。
             *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
             */
            
            /*============================================================================*/
            /*=======================需要填写商户app申请的===================================*/
            /*============================================================================*/
            NSString *partner = @"";
            NSString *seller = @"";
            NSString *privateKey = @"";
            //这些重要信息不在客户端保存
            /*============================================================================*/
            /*============================================================================*/
            /*============================================================================*/
            
            //partner和seller获取失败,提示
            if ([partner length] == 0 ||
                [seller length] == 0 ||
                [privateKey length] == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"缺少partner或者seller或者私钥。"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            /*
             *生成订单信息及签名
             */
            //将商品信息赋予AlixPayOrder的成员变量
            AliPayOrder *order = [[AliPayOrder alloc] init];
            order.partner = partner;
            order.sellerID = seller;
            order.outTradeNO = @"123123"; //订单ID（由商家自行制定）
            order.subject = @"ourMakise"; //商品标题
            order.body = @"elpsycongrol"; //商品描述
            order.totalFee = @"0.01"; //商品价格
            order.notifyURL =  @"http://www.xxx.com"; //回调URL
            
            order.service = @"mobile.securitypay.pay";
            order.paymentType = @"1";
            order.inputCharset = @"utf-8";
            order.itBPay = @"30m";
            order.showURL = @"m.alipay.com";
            
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"alisdkdemo";
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            NSLog(@"orderSpec = %@",orderSpec);
            
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            //    id<DataSigner> signer = CreateRSADataSigner(privateKey);
            //    NSString *signedString = [signer signString:orderSpec];
            NSString *signedString = @"xxxxx_sign";
            
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }

           
        }
            break;
        default:
            break;
    }
}

//登录按钮
-(void)loginView:(LoginView *)loginView didSelectedLoginBtn:(UIButton *)sender{
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"login" withExtension:@"wav"];
    self.player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
    [SXLoadingView showProgressHUD:@"正在登录"];
    
    MYLog(@"登录");
    RootTabBarViewController *rootVC = [[RootTabBarViewController alloc]init];
    [self presentViewController:rootVC animated:YES completion:nil];
//    NSDictionary *logDic = @{@"user":self.loginView.accountView.inputTextView.text,@"pass":self.loginView.passwordView.inputTextView.text};
//    WK(weakSelf)
//    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:@0 requestcode:kRequestCodeLogin success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        MYLog(@"登录%@",jsonDic);
//        if (succe) {
//            //登录成功
//            if ([jsonDic[@"message"] isEqualToString:@"登录成功"]) {
//                [SXLoadingView showAlertHUD:@"登录成功" duration:0.5];
//                LoginModel *loginModel = [LoginModel modelWithJSON:jsonDic[@"data"]];
//
//                if ([USERDEFAULT objectForKey:@"userid"]&&[[USERDEFAULT objectForKey:@"userid"] integerValue]!=loginModel.info.userId) {
//                    //登录成功移除userdefault的id
//                    if ([USERDEFAULT objectForKey:kNSUserDefaultsMyFamilyID]) {
//                        [USERDEFAULT removeObjectForKey:kNSUserDefaultsMyFamilyID];
//                        if ([WFamilyModel shareWFamilModel]) {
//                            [WFamilyModel  shareWFamilModel].ds = 0;
//                            [WFamilyModel  shareWFamilModel].rs = 0;
//                            WFamilyModel *model = [[WFamilyModel alloc] init];
//                            [WFamilyModel  shareWFamilModel].datalist = model.datalist;
//
//
//                        }
//                    }
//                }
//
//                //存储用户信息
//                //id
//                [USERDEFAULT setObject:@(loginModel.info.userId) forKey:@"userid"];
//                //登录授权认证码
//                [USERDEFAULT setObject:loginModel.info.auth
//                                forKey:@"authcode"];
//                //vip等级
//                [USERDEFAULT setObject:@(loginModel.lv) forKey:@"vipLevel"];
//                //[USERDEFAULT setObject:@1 forKey:@"vipLevel"];
//
//                [USERDEFAULT setObject:self.loginView.accountView.inputTextView.text forKey:UserAccount];
//                [USERDEFAULT setObject:self.loginView.passwordView.inputTextView.text forKey:UserPassword];
//
//                RootTabBarViewController *rootVC = [[RootTabBarViewController alloc]init];
//                [weakSelf presentViewController:rootVC animated:YES completion:nil];
//
//            }else{
//                [SXLoadingView showAlertHUD:jsonDic[@"message"] duration:0.5];
//            }
//
//        }else{
//            [SXLoadingView showAlertHUD:jsonDic[@"message"] duration:0.5];
//        }
//
//    } failure:^(NSError *error) {
//        MYLog(@"失败---%@",error.description);
//    }];
    
}
////游客按钮
//-(void)loginView:(LoginView *)loginView didSelectedTourBtn:(UIButton *)sender{
//    
//    NSLog(@"游客请进！");
//    [USERDEFAULT setObject:@false forKey:LoginStates];
//    //游客进入id为1的测试账号
//    NSDictionary *logDic = @{@"user":@"test1234",@"pass":@"111111"};
//    
//    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:@0 requestcode:kRequestCodeLogin success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        if (succe) {
//            //登录成功
//            LoginModel *loginModel = [LoginModel modelWithJSON:jsonDic[@"data"]];
//            //存储用户信息
//            //id
//            [USERDEFAULT setObject:@(loginModel.userId) forKey:@"userid"];
//            //登录授权认证码
//            [USERDEFAULT setObject:loginModel.auth
//                            forKey:@"authcode"];
//            
//            //[self dismissViewControllerAnimated:NO completion:nil];
//            
//            
//        }
//        
//    } failure:^(NSError *error) {
//        MYLog(@"失败---%@",error.description);
//    }];
//
//    
//    
//    [USERDEFAULT setObject:@1 forKey:@"userid"];
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:NO completion:nil];
//}

#pragma mark *** touch ***
//收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark *** getters ***
-(LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc] initWithFrame:self.view.bounds];
        _loginView.delegate = self;
        _loginView.accountView.inputTextView.placeholder = @"用户名/手机号";
        [_loginView.accountView setAccPlaceholder];
        
        if ([USERDEFAULT objectForKey:UserAccount]&&[USERDEFAULT objectForKey:UserPassword]) {
            _loginView.accountView.inputTextView.text = [USERDEFAULT objectForKey:UserAccount];
            _loginView.passwordView.inputTextView.text = [USERDEFAULT objectForKey:UserPassword];
        }
        
    }
    return _loginView;
}

-(ToRegistView *)regisView{
    if (!_regisView) {
        _regisView = [[ToRegistView  alloc] initWithFrame:CGRectMake(0, 0, 0.8*Screen_width, ReGistView_height)];
        _regisView.center = CGPointMake(700, CGRectGetMinY(self.loginView.accountView.frame)+ReGistView_height/2);
        _regisView.alpha = 0;
        _regisView.delegate = self;
        
    }
    return _regisView;
}


@end
