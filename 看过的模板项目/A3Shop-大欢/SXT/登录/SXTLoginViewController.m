//
//  SXTLoginViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/21.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTLoginViewController.h"
#import "SXTLoginView.h"
#import "SXTThirdLoginView.h"
//#import "UMSocial.h"//引入友盟的qq登陆

@interface SXTLoginViewController ()
@property (strong, nonatomic)   SXTThirdLoginView *thirdLoginView;              /** 第三方登录view */
@property (strong, nonatomic)   SXTLoginView * loginView;   /** 登录view */
@end

@implementation SXTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.edgesForExtendedLayout = 0;
    [self addController];
    // Do any additional setup after loading the view.
}

- (void)addController{
    [self.view addSubview:self.loginView];
    [self.view addSubview:self.thirdLoginView];
    
    __weak typeof (self) weakSelf = self;
    [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@200);
    }];
    
    [_thirdLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loginView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@85);
    }];
    
}

- (SXTLoginView *)loginView{
    if (!_loginView) {
        _loginView = [[SXTLoginView alloc]init];
        __weak typeof (self) weakSelf = self;
        _loginView.loginBlock = ^(NSDictionary *dic){
            [weakSelf loginMethod:dic];
        };
    }
    return _loginView;
}

- (SXTThirdLoginView *)thirdLoginView{
    if (!_thirdLoginView) {
        _thirdLoginView = [[SXTThirdLoginView alloc]init];
        __weak typeof (self) weakSelf = self;
        _thirdLoginView.qqBlock = ^(){
            [weakSelf qqLandingMethod];
        };
    }
    return _thirdLoginView;
}
- (void)loginMethod:(NSDictionary *)dic{
    //    http://123.57.141.249:8080/beautalk/appMember/appLogin.do
//    登陆名:LoginName
//    密码 :Lpassword
    [self getData:@"appMember/appLogin.do" param:dic success:^(id responseObject) {
        //用户不存在
        //密码错误
        //登陆成功
        SXTLog(@"responseObject : %@",responseObject);
        if ([responseObject[@"ErrorMessage"] isEqualToString:@"登陆成功"]) {
            [self showTostMessage:@"登录成功"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"ISLOGIN"];
            [self performSelector:@selector(popMyViewController) withObject:nil afterDelay:1.0];
        }else if ([responseObject[@"ErrorMessage"] isEqualToString:@"密码错误"]){
            [self showTostMessage:@"密码错误"];
        }else if ([responseObject[@"ErrorMessage"] isEqualToString:@"用户不存在"]){
            [self showTostMessage:@"用户不存在"];
        }else{
            [self showTostMessage:@"登录失败"];
        }
    } error:^(NSError *error) {
        SXTLog(@"error : %@",error);
    }];
}

- (void)popMyViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - qq登录
- (void)qqLandingMethod{
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
//    __weak typeof (self) weakSelf = self;
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){        
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
////            SXTLandingNextViewController *next = [[SXTLandingNextViewController alloc]init];
////            next.userMessageDic = @{@"userName":snsAccount.userName,@"iconImage":snsAccount.iconURL,@"Telephone":@"17721025595",@"password":@"123123"};
////            [weakSelf.navigationController pushViewController:next animated:YES];
//        }});
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
