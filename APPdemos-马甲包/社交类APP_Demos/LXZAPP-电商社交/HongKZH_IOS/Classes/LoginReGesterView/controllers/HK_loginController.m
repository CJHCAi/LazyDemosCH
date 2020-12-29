//
//  HK_loginController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_loginController.h"
#import "HK_LoginRegesterTool.h"
#import "GjBackScrollView.h"
#import "WXApi.h"
@interface HK_loginController ()<TencentSessionDelegate>
{
        TencentOAuth *_tencentOAuth;
        NSMutableArray *_permissionArray;   //权限列表
    
}
@property (nonatomic, strong)UIButton * wechatBtn;
@property (nonatomic, strong)UIButton * qqBtn;
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, strong)UIButton * registerBtn;
@property (nonatomic, strong)SDCycleScrollView * backScrollView;
@property (nonatomic, strong)UIImageView * logoView;
@property (nonatomic, strong)NSMutableArray * picArr;
@property (nonatomic, strong)GjBackScrollView *scrollViewBack;
@property (nonatomic, assign)CGFloat backH;

@end

@implementation HK_loginController

-(UIButton *)wechatBtn {
    if (!_wechatBtn) {
        _wechatBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _wechatBtn.frame = CGRectMake(75,SCREEN_HEIGHT_S-20-26,80,20);
        [AppUtils getButton:_wechatBtn font:PingFangSCRegular12 titleColor:[UIColor colorFromHexString:@"ffffff"] title:@"微信登录"];
        [_wechatBtn setImage:[UIImage imageNamed:@"00_wx_"] forState:UIControlStateNormal];
        [_wechatBtn addTarget:self action:@selector(btnSenderAction:) forControlEvents:UIControlEventTouchUpInside];
        _wechatBtn.tag = 1;
    }
    return _wechatBtn;
}

-(UIButton *)qqBtn {
    if (!_qqBtn) {
        _qqBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _qqBtn.frame = CGRectMake(SCREEN_WIDTH_S-75-80,CGRectGetMinY(self.wechatBtn.frame),80,20);
        [AppUtils getButton:_qqBtn font:PingFangSCRegular12 titleColor:[UIColor colorFromHexString:@"ffffff"] title:@"QQ登录"];
        [_qqBtn setImage:[UIImage imageNamed:@"00_qq_"] forState:UIControlStateNormal];
        [_qqBtn addTarget:self action:@selector(btnSenderAction:) forControlEvents:UIControlEventTouchUpInside];
        _qqBtn.tag = 2;
    }
    return _qqBtn;
}
-(UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(CGRectGetMinX(self.registerBtn.frame),CGRectGetMinY(self.registerBtn.frame)-20-50,CGRectGetWidth(self.registerBtn.frame),CGRectGetHeight(self.registerBtn.frame));
        [AppUtils getButton:_loginBtn font:PingFangSCMedium16 titleColor:[UIColor colorFromHexString:@"ffffff"] title:@"登录"];
        [_loginBtn addTarget:self action:@selector(btnSenderAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.backgroundColor =[UIColor colorFromHexString:@"006cff"];
        _loginBtn.tag =3;
       _loginBtn.layer.cornerRadius  =7;
       _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}
-(UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.frame = CGRectMake(30,CGRectGetMinY(self.wechatBtn.frame)-40-50,SCREEN_WIDTH_S-60,50);
        [AppUtils getButton:_registerBtn font:PingFangSCMedium16 titleColor:[UIColor colorFromHexString:@"ffffff"] title:@"注册"];
        [_registerBtn addTarget:self action:@selector(btnSenderAction:) forControlEvents:UIControlEventTouchUpInside];
        _registerBtn.tag = 4;
        _registerBtn.alpha = 0.6;
        _registerBtn.backgroundColor =[UIColor colorFromHexString:@"000000"];
        _registerBtn.layer.cornerRadius  =7;
        _registerBtn.layer.masksToBounds = YES;
        
    }
    return _registerBtn;
}
-(UIImageView *)logoView {
    if (!_logoView) {
        UIImage  * image =[UIImage imageNamed:@"slogan_"];
        _logoView =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-image.size.width/2,142,image.size.width,image.size.height)];
        _logoView.image =image;
        _logoView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quit)];
        [_logoView addGestureRecognizer:tapG];
    }
    return _logoView;
}
-(void)quit {
    [self dismissViewControllerAnimated:YES completion:nil];
}
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
     // [self startAnimation];
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
#pragma mark 按钮点击事件
-(void)btnSenderAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            
            [AppUtils sendWechatAuthRequest];
        }
            break;
            case 2:
        {
            _tencentOAuth=[[TencentOAuth alloc]initWithAppId:QQAppID andDelegate:self];
            NSArray *permissions = @[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE, kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO];
            [_tencentOAuth authorize:permissions];
        }
            break;
        case 3:
        {
            [HK_LoginRegesterTool pushLoadControllerWithCurrentVc:self withType:0];
        }
            break;
        case 4:
        {
      
            [HK_LoginRegesterTool pushRigeSterControllerWithCurrentVc:self];
        }
            break;
        default:
            break;
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}
//微信登录
-(void)wechatLogin:(NSNotification *)noti {
    
    [HK_LoginRegesterTool WeixinOauthSuccessForApi:noti.object withCurrentVc:self];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
   //增加监听 监听三方登录返回的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLogin:) name:WeChatLoginMessage object:nil];
    
    //计算每一个item图片要显示的尺寸为backScollView的大小
        UIImage * backIm =[UIImage imageNamed:@"bg1080.jpg"];
        CGFloat backW =kScreenWidth;
        CGFloat backH =0;
        CGFloat imageW =backIm.size.width;
        CGFloat imageH =backIm.size.height;
        backH  = imageH * backW/imageW;
        self.backH = backH;
    
    GjBackScrollView * backView2=[[GjBackScrollView alloc]initWithFrame:CGRectMake(0,-20,kScreenWidth,kScreenHeight+20)];
   // backView2.rollImageURL = @"https://a-ssl.duitang.com/uploads/item/201611/16/20161116161417_ydRxF.thumb.700_0.jpeg"; //网络图片
    backView2.image =backIm;
    backView2.contentMode =UIViewContentModeScaleAspectFill;
    backView2.timeInterval = .02; //移动一次需要的时间
    backView2.rollSpace = .5; //每次移动的像素距离
    backView2.direction = RollDirectionUpDown;//滚动的方向
    [backView2 startRoll]; //开始滚动
    [self.view addSubview:backView2];
    
    //加一个遮罩层
    UIView * coverV=[[UIView alloc] initWithFrame:CGRectMake(0,-20,kScreenWidth,kScreenHeight+20)];
    coverV.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.4];
    [self.view addSubview:coverV];
    [self.view addSubview:self.logoView];

#pragma mark 验证是否安装了微信和QQ
    if ([WXApi isWXAppInstalled]) {
        [self.view addSubview:self.wechatBtn];
    }
    if ([TencentOAuth iphoneQQInstalled]) {
         [self.view addSubview:self.qqBtn];
    }
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.loginBtn];
   
}
-(SDCycleScrollView *)backScrollView {
    if (!_backScrollView) {
   //计算每一个item图片要显示的尺寸为backScollView的大小
        UIImage * backIm =[UIImage imageNamed:@"00_logo_"];
        CGFloat backW =kScreenWidth;
        CGFloat backH =0;
        CGFloat imageW =backIm.size.width;
        CGFloat imageH =backIm.size.height;
        backH  = imageH * backW/imageW;
        _backScrollView =[[SDCycleScrollView alloc] initWithFrame:CGRectMake(0,0,backW,SCREEN_HEIGHT_S)];
        _backScrollView.autoScroll = YES;
        _backScrollView.backgroundColor =[UIColor redColor];
        _backScrollView.scrollDirection =UICollectionViewScrollDirectionVertical;
        _backScrollView.autoScrollTimeInterval =3;
        _backScrollView.bannerImageViewContentMode =UIViewContentModeScaleAspectFill;
        _backScrollView.showPageControl = NO;
    }
    return _backScrollView;
}
-(NSMutableArray *)picArr {
    if (!_picArr) {
        _picArr =[[NSMutableArray alloc] init];
    }
    return _picArr;
}

@end
