//
//  ShareSDKConnector.h
//  ShareSDKConnector
//
//  Created by fenghj on 15/6/2.
//  Copyright (c) 2015年 mob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

/**
 *  ShareSDK连接器
 */
@interface ShareSDKConnector : NSObject

/**
 *  链接微信API已供ShareSDK可以正常使用微信的相关功能（授权、分享）
 *
 *  @param weChatClass 微信SDK中的类型，应先导入libWXApi.a，再传入[WXApi class]到此参数。注：此参数不能为nil，否则会导致授权、分享无法正常使用
 *  @param delegate 对于需要获取微信回复或请求时传入该委托对象。该对象必须实现WXApiDelegate协议中的方法。
 */
+ (void)connectWeChat:(Class)wxApiClass;
+ (void)connectWeChat:(Class)wxApiClass delegate:(id)delegate;

/**
 *  连接微博API以供ShareSDK可以使用微博客户端来分享内容，不调用此方法也不会影响应用内分享、授权等相关功能。
 *
 *  @param weiboClass 微博SDK中的类型，应先导入libWeiboSDK.a,再传入[WeiboSDK class]到此参数.
 */
+ (void)connectWeibo:(Class)weiboSDKClass;

/**
 *  连接QQAPI以供ShareSDK可以正常使用QQ或者QQ空间客户端来授权或者分享内容。
 *
 *  @param qqApiInterfaceClass QQSDK中的类型，应先导入TencentOpenAPI.framework，再传入[QQApiInterface class]到此参数。
 *  @param tencentOAuthClass   QQSDK中的类型，应先导入TencentOpenAPI.framework，再传入[TencentOAuth class]到此参数。
 */
+ (void)connectQQ:(Class)qqApiInterfaceClass tencentOAuthClass:(Class)tencentOAuthClass;

/**
 *  连接人人网SDK以供ShareSDK可以正常使用人人网客户端进行SSO授权。
 *
 *  @param rennClientClass 人人网SDK中的类型，应先导入RennSDK.framework,再传入[RennClient class]到此参数。
 */
+ (void)connectRenren:(Class)rennClientClass;

/**
 *  连接Google＋以供ShareSDK可以正常使用Google＋的相关功能（包括授权、分享）
 *
 *  @param signClass  Google＋SDK中的类型,应先导入GooglePlus.framework,再传入[GPPSignIn class]到此参数
 *  @param shareClass Google＋SDK中的类型,应先导入GooglePlus.framework,再传入[GPPShare class]到此参数
 */
+ (void)connectGooglePlus:(Class)signClass shareClass:(Class)shareClass;

/**
 *  链接支付宝好友以供ShareSDK可以正常使用支付宝进行分享
 *
 *  @param apOpenApiClass 支付宝好友SDK中的类型，应先导入libAPOpenSdk.a，再将[APOpenApi class]传入到此参数。注：此参数不能为nil，否则会导致无法正常分享。
 */
+ (void)connectAliPaySocial:(Class)apOpenApiClass;

/**
 *  链接KaKao以供ShareSDK可以正常使用KaKao进行分享
 *
 *  @param koSessionClass KaKao SDK中的类型，应先导入KakaoOpenSDK.framework，再将[KOSession class]传入到此参数。
 */
+ (void)connectKaKao:(Class)koSessionClass;

@end
