//
//  MtopAuthProtocol.h
//  OpenMtopExt
//
//  Created by 亿刀 on 16/7/11.
//  Copyright © 2016年 亿刀. All rights reserved.
//


#import <Foundation/Foundation.h>


/*!
 * 授权标记
 */
typedef enum {
    
    /* 只走AutoAuth，失败什么都不做！ */
    AuthOptionAutoAuthOnly = 1,
    
    /* 先走AutoAuth，失败再拉授权页面 */
    AuthOptionAutoAuthAndManualAuth,
    
} AuthOption;

/*!
 * 授权成功回调
 * @param isSuccessful  YES表示授权成功(auto auth或者manual auth)，NO表示授权失败（只可能发生在authOptionAutoauthOnly）
 * @param authResult   授权成功的情况下返回的授权结果（包含授权态）
 */
typedef void (^AUTH_COMPLETION_HANDLER) (BOOL isSuccessful, NSDictionary* authResult);

/*!
 * 授权取消回调
 * @param flags   用户手动取消授权页面
 */
typedef void (^AUTH_CANCELATION_HANDLER)();

@protocol MtopAuthProtocol <NSObject>

@required

/*!
 * 获取单例
 */
+ (id)sharedInstantce;

/*!
 * 判断当前用户是否有授权会话
 * @return
 *          YES     本地有会话且本地判断会话未过期，但服务端可能判定会话无效
 *          NO      本地无会话或本地判断会话已过期
 */
- (BOOL)isValidAuth;

/*
 * 触发授权操作
 * @param authOption         授权选项 参看 <code>authOption</code>
 * @param completionHandler   授权成功后回调
 * @param cancelationHandler  授权用户取消后回调
 */
- (void)authWithAuthOption:(AuthOption)authOption
         completionHandler:(AUTH_COMPLETION_HANDLER)completionHandler
        cancelationHandler:(AUTH_CANCELATION_HANDLER)cancelationHandler;

/*
 * 基本同上，一般业务方不要使用此方法，需要使用此方法，请联系@寻弦
 * @param extraInfoDict 额外参数
 */
- (void)authWithAuthOption:(AuthOption)authOption
                 extraInfo:(NSDictionary *)extraInfoDict
         completionHandler:(AUTH_COMPLETION_HANDLER)completionHandler
        cancelationHandler:(AUTH_CANCELATION_HANDLER)cancelationHandler;


/*!
 * 获取当前授权会话信息
 * @return
 *          会话信息
 *                  sid         ->  session id                (NSString*)
 *                  userId      ->  用户id                     (NSString*)
 *                  ecode       ->  ecode                      (NSString*)
 *                  nick        ->  用户nick                      (NSString*)
 *                  authToken  ->  授权令牌                       (NSString*)
 *                  ssoToken    ->  sso令牌                       (NSString*)
 *                  topSession  ->  top授权                       (NSString*)
 *                  cookie      ->  cookie                         (NSString*)
 *                  ......
 */
- (NSDictionary *)currentSession;

/*!
 * 返回当前authCenter是否已经在处理授权行为
 * @return YES 已经有在处理中的授权行为
 *         NO  没有正在处理的授权行为
 */
- (BOOL)isProcessingAuth;

/*!
 * 标识本地auth已经失效
 */
- (void)markInvalidAuth;


@end

