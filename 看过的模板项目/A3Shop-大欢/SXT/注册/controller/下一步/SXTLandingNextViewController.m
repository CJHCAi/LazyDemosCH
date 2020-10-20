//
//  SXTLandingNextViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/18.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTLandingNextViewController.h"
#import "SXTNextLandingView.h"//下一步view



@interface SXTLandingNextViewController ()
@property (strong, nonatomic)   SXTNextLandingView *nextLandingView;              /** 下一步view */
@end

@implementation SXTLandingNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证手机号";
    self.edgesForExtendedLayout = 0;
    
    SXTLog(@"用户名和密码是:%@",_userMessageDic);
    [self addController];
    [self requestCodeNumber];

}
//加载控件mvc  mvvm
- (void)addController{
    [self.view addSubview:self.nextLandingView];
    __weak typeof (self) weakSelf = self;
    [_nextLandingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@140);
    }];
}
//请求验证码
- (void)requestCodeNumber{
    [self postData:@"appMember/createCode.do" param:@{@"MemberId":_userMessageDic[@"userName"]} success:^(id responseObject) {
        SXTLog(@"responseObject : %@",responseObject);
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            [self.nextLandingView GCDTime];
        }else if ([responseObject[@"result"] isEqualToString:@"TelephoneExistError"]){
            [self showTostMessage:@"手机号已经被注册"];
        }else{
            [self showTostMessage:@"验证码请求失败"];
        }
    } error:^(NSError *error) {
        SXTLog(@"error : %@",error);
    }];
    
}


//注册方法
- (void)LandingMethod:(NSString *)code{
    [self getData:@"appMember/appRegistration.do" param:@{@"LoginName":_userMessageDic[@"userName"],
                @"Lpassword":_userMessageDic[@"password"],
                @"Code":code,
                @"Telephone":_userMessageDic[@"userName"]}
                 success:^(id responseObject) {
                     if ([responseObject[@"result"]isEqualToString:@"success"]) {
                                [self showTostMessage:@"注册成功"];
                         [self autoLogin];
                            }else if ([responseObject[@"result"]isEqualToString:@"codeError"]){
                                [self showTostMessage:@"验证码错误"];
                            }else{
                                [self showTostMessage:@"注册失败"];
                            }
                            SXTLog(@"responseObject : %@",responseObject);
                    } error:^(NSError *error) {
                            SXTLog(@"error : %@",error);
                }];
    
}
- (SXTNextLandingView *)nextLandingView{
    if (!_nextLandingView) {
        _nextLandingView = [[SXTNextLandingView alloc]init];
        _nextLandingView.phoneNumString = _userMessageDic[@"userName"];
        __weak typeof (self) weakSelf = self;
        _nextLandingView.landingBlock = ^(NSString *code){
            [weakSelf LandingMethod:code];
        };
    }
    return _nextLandingView;
}
//登录方法
- (void)autoLogin{
    [self getData:@"appMember/appLogin.do" param:@{@"LoginName":_userMessageDic[@"userName"],@"Lpassword":_userMessageDic[@"password"]} success:^(id responseObject) {
        SXTLog(@"responseObject : %@",responseObject);
        if ([responseObject[@"result"] isEqualToString:@"0"]) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"ISLOGIN"];
            [self performSelector:@selector(popMyViewController) withObject:nil afterDelay:1.0];
        }
    } error:^(NSError *error) {
        SXTLog(@"error : %@",error);
    }];
}

- (void)popMyViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
