//
//  TBOpenSDK.h
//  WopcMiniSDK
//
//  Created by 慕徊 on 15/8/18.
//  Copyright (c) 2015年 TaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TBBasicParam.h"
#import "TBShopParam.h"
#import "TBDetailParam.h"
#import "TBURIParam.h"
#import "TBNativeParam.h"
#import "TBAuthParam.h"
#import "TBError.h"

//FOUNDATION_EXPORT NSString * const kSDKVersion;

typedef NSString* (^TBAppLinkCreateSignBlock)(NSString *);
typedef void (^TBAppLinkAuthCompleteBlock)(NSError *error,NSDictionary *authInfo);
//跳转手淘失败时（ios设备上只有'手淘未安装'一种场景,andorid上还有'手淘版本低'的场景），可选处理模式
typedef NS_ENUM(NSUInteger, TBAppLinkJumpFailedMode) {
    
    TBAppLinkJumpFailedModeDownLoadTaobao=0,  //跳转到手淘下载页
    TBAppLinkJumpFailedModeOpenH5=1,          //降级到h5
    TBAppLinkJumpFailedModeNone=2,            //自行处理Jump跳转方法返回为NO的情况，只有设置为该模式，才能屏蔽以上2种模式的实现
    
};
@interface TBAppLinkSDK : NSObject

/**
 *  appkey为正常使用appLink功能的关键数据，当appKey信息校验失败时，将没有返回原app的功能
 */
@property (nonatomic, strong) NSString *appKey;

@property (nonatomic, strong) NSString *appSecret;

/**
 *  backURL,返回跳转的地址,可选,如果不传则跳转手淘后无法回来当前的app
 */
@property (nonatomic, strong) NSString *backURL;

/**
 *  淘客参数,pid传入时需要设置相应的type
 */
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *type;

/**
 *  百川（芒果）结算埋点数据
 */
@property (nonatomic, strong) NSString *TTID;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *utdid;

/**
 *  来源, 百川
 */
@property (nonatomic, strong) NSString *source;
/*
 * AppLink Jump方法失败处理模式，当前有3种模式。默认模式为TBAppLinkJumpFailedModeDownLoadTaobao
 */
@property (nonatomic, assign)   TBAppLinkJumpFailedMode  jumpFailedMode;

/*
 * 生成签名sign的算法,AppLink提供2个信道模式：可信模式&不可信模式，只有提供了有效的安全算法使用方才是可信模式，
 * 可信模式享受更多服务（如授权登录），appLink还会将可信状态通知手淘具体的业务方（如：红包业务），由该业务决定可信模式与不可信模式
 * 状态下具体的处理方式。当前版本只支持“黑匣子”加密算法
 */
@property (nonatomic, copy)     TBAppLinkCreateSignBlock       createSignBlock;

/**
 *  获取单例
 */
+ (instancetype)sharedInstance;

/**
 *  初始化SDK,传入appkey
 */
- (void)initWithAppkey:(NSString *)appKey;

/**
 *  DESIGNATED INITIALIZER
 */
- (void )initWithAppkey:(NSString *)appKey BackURL:(NSString *)backURL pid:(NSString *)pid type:(NSString *)type;

/**
 *  设置百川,芒果参数(非百川芒果可忽略)
 */
- (void)setTTID:(NSString *)TTID utdid:(NSString *)utdid tag:(NSString *)tag source:(NSString *)source;

/**
 *  跳转到店铺,店铺和详情2个明确的native跳转业务单独独立出来，是jumpNative:的具体化
 */
- (TBError *)jumpShop:(TBShopParam *)param;

/**
 *  跳转到详情，店铺和详情2个明确的native跳转业务单独独立出来，是jumpNative:的具体化
 */
- (TBError *)jumpDetail:(TBDetailParam *)param;

/**
 *  跳转到任意淘宝URI
 */
- (TBError *)jumpTBURI:(TBURIParam *)param;

/**
 *  跳转到授权页面,授权登录功能仅在可信模式下有效，不可信模式下使用该方法将停留在“淘宝首页”
 *  传入TBAuthParam,里面包含正常的backURL和降级到H5授权页面的redirectURI.
 *  授权结果通过block的形式回调3方app，参数为mixedNick、iconURL、error
 */
- (TBError *)doAuth:(TBAuthParam *)param Complete:(TBAppLinkAuthCompleteBlock)block;
/**
 *  处理appLink返回结果，需要在AppDelegate的 [application:(UIApplication)app handleOpenURL:(NSURL*)url]中添加
 */
- (BOOL)handleOpenURL:(NSURL*)url;

/**
 * 检查是否能打开指定app，传入是linkKey，比如：@"taobao"，指手淘
 */
- (BOOL)canOpenApp:(NSString*)linkKey;

@end
