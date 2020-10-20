# QQLoginDemo
QQ 最新版本第三方登录demo.  
最新版本的qq登录实现步骤实现：

1. 首先，你需要去向腾讯申请账号。 地址：点击打开链接

2. 下载最新的SDK   地址： SDK下载

SDK内容如下：

1. doc: 为说明文档， 方法参数说明。
2.sample 这个是简单的demo
 3. TencentOpenApi_IOS_Bundle.bundle   资源文件包
4. TencentOpenApi.framework     核心开发框架
接下来就进入正题：
 1. 项目配置，手把手教学：

   1. 新建一个工程。 
   2. 把TencentOpenApi.framework 和  TencentOpenApi_IOS_Bundle.bundle  拖入工程。 
   3. 配置项目。

   3.1 添加依赖库：


3.2 在工程配置中的“Build Settings”一栏中找到“Linking”配置区，给“Other Linker Flags”配置项添加属性值“-fobjc-arc”






3.3 URLScheme 配置：


 3.4 针对ios9以后，需要添加白名单。 

在info.plist文件中加入 LSApplicationQueriesSchemes 

对应的info.plist 的source code 为
<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>mqqapi</string>
		<string>mqq</string>
		<string>mqqOpensdkSSoLogin</string>
		<string>mqqconnect</string>
		<string>mqqopensdkdataline</string>
		<string>mqqopensdkgrouptribeshare</string>
		<string>mqqopensdkfriend</string>
		<string>mqqopensdkapi</string>
		<string>mqqopensdkapiV2</string>
		<string>mqqopensdkapiV3</string>
		<string>mqzoneopensdk</string>
		<string>wtloginmqq</string>
		<string>wtloginmqq2</string>
		<string>mqqwpa</string>
		<string>mqzone</string>
		<string>mqzonev2</string>
		<string>mqzoneshare</string>
		<string>wtloginqzone</string>
		<string>mqzonewx</string>
		<string>mqzoneopensdkapiV2</string>
		<string>mqzoneopensdkapi19</string>
		<string>mqzoneopensdkapi</string>
		<string>mqzoneopensdk</string>
	</array>
 3.5  针对iOS9默认使用https,现在先还原成http请求方式。

  在Info.plist中添加NSAppTransportSecurity类型Dictionary。
 在NSAppTransportSecurity下添加NSAllowsArbitraryLoads类型Boolean,值设为YES    
      第一步：在plist中添加NSAppTransportSecurity项，此项为NSDictionary
      第二步：在NSAppTransportSecurity下添加   NSAllowsArbitraryLoads类型为Boolean，value为YES

4. 开始码代码了， 最欢乐的时刻：

 1. 在刚刚新建的项目中 appdelegate.m， 添加代码：
          1.引入头文件 ： 
          
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
   2. 并遵循代理
@interface AppDelegate ()<QQApiInterfaceDelegate>
@end

  3. 在添加跳转的请求方法
      
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    /**
     处理由手Q唤起的跳转请求
     \param url 待处理的url跳转请求
     \param delegate 第三方应用用于处理来至QQ请求及响应的委托对象
     \return 跳转请求处理结果，YES表示成功处理，NO表示不支持的请求协议或处理失败
     */
    [QQApiInterface handleOpenURL:url delegate:self];
    return [TencentOAuth HandleOpenURL:url];
}


/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req{
    NSLog(@" ----req %@",req);
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp{
     NSLog(@" ----resp %@",resp);
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response{

}

现在就是具体的登录controller.m了。

授权相关的字段
/** 发表一条说说到QQ空间(<b>需要申请权限</b>) */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_ADD_TOPIC;

/** 发表一篇日志到QQ空间(<b>需要申请权限</b>) */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_ADD_ONE_BLOG;

/** 创建一个QQ空间相册(<b>需要申请权限</b>) */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_ADD_ALBUM;

/** 上传一张照片到QQ空间相册(<b>需要申请权限</b>) */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_UPLOAD_PIC;

/** 获取用户QQ空间相册列表(<b>需要申请权限</b>) */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_LIST_ALBUM;

/** 同步分享到QQ空间、腾讯微博 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_ADD_SHARE;

/** 验证是否认证空间粉丝 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_CHECK_PAGE_FANS;

/** 获取登录用户自己的详细信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_INFO;

/** 获取其他用户的详细信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_OTHER_INFO;

/** 获取会员用户基本信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_VIP_INFO;

/** 获取会员用户详细信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_VIP_RICH_INFO;

/** 获取用户信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_USER_INFO;

/** 移动端获取用户信息 */
FOUNDATION_EXTERN NSString *const kOPEN_PERMISSION_GET_SIMPLE_USER_INFO;


直接上源码， 源码里面有注释，一看就明白了

//
//  ViewController.m
//  QQLoginDemo
//
//  Created by 张国荣 on 16/6/17.
//  Copyright © 2016年 BateOrganization. All rights reserved.
//

#import "ViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>

//#define TENCENT_CONNECT_APP_KEY @"1103827574"
#define APP_ID @"你的appid"
@interface ViewController ()<TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
    NSMutableArray *_permissionArray;   //权限列表
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


- (IBAction)loginAction:(id)sender {
    _tencentOAuth=[[TencentOAuth alloc]initWithAppId:APP_ID andDelegate:self];
    
    //设置权限数据 ， 具体的权限名，在sdkdef.h 文件中查看。
    _permissionArray = [NSMutableArray arrayWithObjects: kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
    
    //登录操作
    [_tencentOAuth authorize:_permissionArray inSafari:NO];
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    
    /** Access Token凭证，用于后续访问各开放接口 */
    if (_tencentOAuth.accessToken) {
        
        //获取用户信息。 调用这个方法后，qq的sdk会自动调用
        //- (void)getUserInfoResponse:(APIResponse*) response
        //这个方法就是 用户信息的回调方法。
        
        [_tencentOAuth getUserInfo];
    }else{
    
        NSLog(@"accessToken 没有获取成功");
    }
    
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled) {
        NSLog(@" 用户点击取消按键,主动退出登录");
    }else{
        NSLog(@"其他原因， 导致登录失败");
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    NSLog(@"没有网络了， 怎么登录成功呢");
}


/**
 * 因用户未授予相应权限而需要执行增量授权。在用户调用某个api接口时，如果服务器返回操作未被授权，则触发该回调协议接口，由第三方决定是否跳转到增量授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \param permissions 需增量授权的权限列表。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启增量授权流程。若需要增量授权请调用\ref TencentOAuth#incrAuthWithPermissions: \n注意：增量授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}

/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    return YES;
}

/**
 * 用户通过增量授权流程重新授权登录，token及有效期限等信息已被更新。
 * \param tencentOAuth token及有效期限等信息更新后的授权实例对象
 * \note 第三方应用需更新已保存的token及有效期限等信息。
 */
- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth{
    NSLog(@"增量授权完成");
    if (tencentOAuth.accessToken
        && 0 != [tencentOAuth.accessToken length])
    { // 在这里第三方应用需要更新自己维护的token及有效期限等信息
        // **务必在这里检查用户的openid是否有变更，变更需重新拉取用户的资料等信息** _labelAccessToken.text = tencentOAuth.accessToken;
    }
    else
    {
        NSLog(@"增量授权不成功，没有获取accesstoken");
    }

}

/**
 * 用户增量授权过程中因取消或网络问题导致授权失败
 * \param reason 授权失败原因，具体失败原因参见sdkdef.h文件中\ref UpdateFailType
 */
- (void)tencentFailedUpdate:(UpdateFailType)reason{
    
    switch (reason)
    {
        case kUpdateFailNetwork:
        {
            //            _labelTitle.text=@"增量授权失败，无网络连接，请设置网络";
            NSLog(@"增量授权失败，无网络连接，请设置网络");
            break;
        }
        case kUpdateFailUserCancel:
        {
            //            _labelTitle.text=@"增量授权失败，用户取消授权";
            NSLog(@"增量授权失败，用户取消授权");
            break;
        }
        case kUpdateFailUnknown:
        default:
        {
            NSLog(@"增量授权失败，未知错误");
            break;
        }
    }

    
}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    NSLog(@" response %@",response);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



