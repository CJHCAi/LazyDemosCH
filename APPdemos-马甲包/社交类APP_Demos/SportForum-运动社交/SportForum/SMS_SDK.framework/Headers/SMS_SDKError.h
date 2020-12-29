//
//  SMS_SDKError.h
//  SMS_SDKDemo
//
//  Created by ljh on 1/29/15.
//  Copyright (c) 2015 严军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMS_SDKError : NSError
{
@private
    NSInteger _errorCode;
    NSString *_errorDescription;
}

///#begin zh-cn
/**
 *	@brief	错误代码，如果为调用API出错则应该参考API错误码对照表。错误码对照表如下：
 错误码	错误描述	         备注
 511	无效请求	         客户端请求不能被识别。
 512	禁止访问	         服务器拒绝访问，或者拒绝操作
 513	Appkey无效	     请求Appkey不存在或被禁用。
 514	权限不足	         无权执行该请求
 515	服务器内部错误	     服务器内部错误
 516	非法请求	         服务器不支持客户端的请求。
 517	参数缺损	         缺少必要的请求参数
 518	非法手机号	     请求中用户的手机号格式不正确（包括手机的区号）
 519	请求验证超上限	     请求发送验证码次数超出限制（如每日、每APP、单台设备以及运营商等都有各种发送验证码的上限）
 520	验证码错误	     无效验证码。
 521	token无效	     请求的令牌无效或者非法
 522	duid无效	         请求的duid非法或者无效
 523	已验证	         请求验证的手机号码已经被验证。
 524	请求频于繁	     客户端请求发送短信验证过于频繁
 525	签名无效	         需要签名检验
 526	余额不足	         余额不足
 */
///#end
///#begin en
/**
 *	@brief	Error code，If it is you call the API, you should see the error code table, if it is an HTTP error, this attribute indicates the HTTP error code.
 ErrorCode	 Error description                             Remarks
 511	     Invalid request 	                           The request cannot be identified
 512	     Forbidden	                                   Server access denied, or refused to operate
 513	     Invalid Appkey	                               Requested Appkey is forbidden or not exsit
 514	     Permission denied	                           No permission to execute the request
 515	     Server Error	                               Server Error
 516	     Illegal request	                           Server does not support the function of the client request
 517	     Missing Params	                               The request necessary params are missing or damaged
 518	     Invalid phone number	                       Request of the user mobile phone number format is not correct (including cell phone area code)
 519	     Request validation exceed the limit	       Request to send verification code beyond the limit (limitation of each day, app, device, carrier)
 520	     Verification code error                 	   Verification code error
 521	     Invalid token	                               The token of request is invalid or illegal
 522	     Invalid duid	                               The requested duid illegal or invalid
 523	     Verified	                                   Request to verify phone number has been verified
 524	     High frequency of verification code request   High frequency of verification code request
 525	     Invalid signature	                           Need signature verification
 526	     Insufficient balance	                       Insufficient balance
 */
///#end

@property (nonatomic) NSInteger errorCode;

///#begin zh-cn
/**
 *	@brief	错误描述，对应相应的错误码的描述
 */
///#end
///#begin en
/**
 *	@brief	Error description
 */
///#end
@property (nonatomic,copy) NSString *errorDescription;

@end
