//
//  SXTLandingViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/18.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTLandingViewController.h"
#import "SXTLandingInPutView.h"//用户名密码输入view
#import "SXTThirdLoginView.h"//第三方登录view
#import "SXTLandingNextViewController.h"//注册页面下一步操作

//#import "UMSocial.h"//引入友盟的qq登陆
@interface SXTLandingViewController ()

@property (strong, nonatomic)   SXTLandingInPutView *landingView;              /** 输入view */
@property (strong, nonatomic)   SXTThirdLoginView *thirdLoginView;              /** 第三方登录view */

@end

@implementation SXTLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MainColor;
    self.edgesForExtendedLayout = 0;
    self.title = @"注册";
    [self addController];

}
//添加控件
- (void)addController{
    [self.view addSubview:self.landingView];
    [self.view addSubview:self.thirdLoginView];
    __weak typeof (self) weakSelf = self;
    [_landingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@230);
        make.left.right.top.equalTo(weakSelf.view);
    }];
    
    [_thirdLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.landingView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@85);
    }];
}

- (SXTLandingInPutView *)landingView{
    if (!_landingView) {
        _landingView = [[SXTLandingInPutView alloc]init];
        __weak typeof (self) weakSelf = self;
        _landingView.nextBlock = ^(NSDictionary *dic){
            SXTLandingNextViewController *next = [[SXTLandingNextViewController alloc]init];
            next.userMessageDic = dic;
            [weakSelf.navigationController pushViewController:next animated:YES];
        };
    }
    return _landingView;
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

- (void)qqLandingMethod{
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
//    __weak typeof (self) weakSelf = self;
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//        
//        //          获取微博用户名、uid、token等
//        
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            
////            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
////            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
//            SXTLandingNextViewController *next = [[SXTLandingNextViewController alloc]init];
////            next.userMessageDic = dic;
//            next.userMessageDic = @{@"userName":snsAccount.userName,@"iconImage":snsAccount.iconURL,@"Telephone":@"17721025595",@"password":@"123123"};
//            [weakSelf.navigationController pushViewController:next animated:YES];
//        }});
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
