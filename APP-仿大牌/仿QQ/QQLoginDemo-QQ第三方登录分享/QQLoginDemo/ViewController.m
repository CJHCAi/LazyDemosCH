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
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "AppDelegate.h"

#define APP_ID @"100424468"
@interface ViewController ()<TencentSessionDelegate,QQShareDelegate>
{
    TencentOAuth *_tencentOAuth;
    NSMutableArray *_permissionArray;   //权限列表
    AppDelegate *appdelegate;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark QQ登录
- (IBAction)loginAction:(id)sender {
    _tencentOAuth=[[TencentOAuth alloc]initWithAppId:APP_ID andDelegate:self];
    
    //设置权限数据 ， 具体的权 限名，在sdkdef.h 文件中查看。
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

#pragma mark 登录成功后，回调 - 返回对应QQ的相关信息
/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    
    //这里 与自己服务器进行对接，看怎么利用这获取到的个人信息。
    
    NSDictionary *dic = response.jsonResponse;
    NSLog(@" response %@",dic);
    
    
}

#pragma mark QQ分享
- (IBAction)QQshareAction:(id)sender {
    /**  
     分享 新闻URL对象 。
     获取一个autorelease的<code>QQApiAudioObject</code>
     @param url 音频内容的目标URL
     @param title 分享内容的标题
     @param description 分享内容的描述
     @param previewURL 分享内容的预览图像URL
     @note 如果url为空，调用<code>QQApi#sendMessage:</code>时将返回FALSE
     */
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURL *preimageUrl = [NSURL URLWithString:@"http://www.sizzee.com/index.php/catalog/product/view/id/55730/s/10196171/?SID=au0lhpg54f11nenmrjvhsh0rq6?uk=Y3VzdG9tZXJfaWQ9Mjc0fHByb2R1Y3RfaWQ9NTU3MzA"];
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:@"测试分享" description:[NSString stringWithFormat:@"分享内容------新闻URL对象分享 ------test"] previewImageURL:preimageUrl];
    
    //请求帮助类,分享的所有基础对象，都要封装成这种请求对象。
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    //通过自定义的qqdelegate来通知本controller，是否成功分享
    appdelegate.qqDelegate = self;
    
    NSLog(@"QQApiSendResultCode %d",sent);
    
    [self handleSendResult:sent];
  /*  QQApiSendResultCode 说明
    EQQAPISENDSUCESS = 0,                      操作成功
    EQQAPIQQNOTINSTALLED = 1,                   没有安装QQ
    EQQAPIQQNOTSUPPORTAPI = 2,
    EQQAPIMESSAGETYPEINVALID = 3,              参数错误
    EQQAPIMESSAGECONTENTNULL = 4,
    EQQAPIMESSAGECONTENTINVALID = 5,
    EQQAPIAPPNOTREGISTED = 6,                   应用未注册
    EQQAPIAPPSHAREASYNC = 7,
    EQQAPIQQNOTSUPPORTAPI_WITH_ERRORSHOW = 8,
    EQQAPISENDFAILD = -1,                       发送失败
    //qzone分享不支持text类型分享
    EQQAPIQZONENOTSUPPORTTEXT = 10000,
    //qzone分享不支持image类型分享
    EQQAPIQZONENOTSUPPORTIMAGE = 10001,
    //当前QQ版本太低，需要更新至新版本才可以支持
    EQQAPIVERSIONNEEDUPDATE = 10002,
   */
}
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark QQ分享回调代理
/* 返回码 对照说明
 0   成功
 -1  参数错误
 -2  该群不在自己的群列表里面
 -3  上传图片失败
 -4  用户放弃当前操作
 -5  客户端内部处理错误
 */
-(void)shareSuccssWithQQCode:(NSInteger)code{
    NSLog(@"code %ld",(long)code);
    if (code == 0) {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"警告" message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }else{
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"警告" message:@"分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
