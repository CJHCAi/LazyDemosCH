//
//  AppUtils.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TencentOpenAPI/TencentApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "HK_CladlyChattesView.h"
//#import "RCUserInfo.h"
#import "HKMyFollowAndFans.h"
#import "HKMyCircleViewController.h"
//店铺页
#import "HKShopHomeVc.h"
#import "HKGoodsSearchViewController.h"
typedef enum {
    PositionTypeLeft,
    PositionTypeRight
} PositionType;
@interface AppUtils : NSObject
/**
 *验证手机号是否合法
 */
+(BOOL)verifyPhoneNumbers:(NSString *)phoneNumberStr;

/**
 * 获取应用的bundle ID
 */
+(NSString *)bundleID;

/**
 * 当前应用版本
 */
+ (NSString *)currentVersion;

/**
 * 用户设备具体型号
 */
+(NSString *)iphoneType;
/**
 * 去掉字符串空格
 */

+ (NSString *)trim:(NSString *)value;

/**
 * 判断字符串是否为空
 */
+ (BOOL)isEmpty:(NSString *)value;

+ (BOOL)isNotEmpty:(NSString *)value;

+ (BOOL)isEmptyArray:(NSArray *)values;

+ (BOOL)isNotEmptyArray:(NSArray *)values;
/**
 * MD5加密
 */
+ (NSString *)md5:(NSString *)value;

/**
 * 编码字符串
 */
+ (NSString *)encodeURL:(NSString *)value;

/**
 * 解码字符串
 */
+ (NSString *)decodeURL:(NSString *)value;

/**
 * 将JSON字符串转成对象
 */
+ (id)parseJSON:(NSString *)value;

/**
 * 将对象转成JSON字符串
 */
+ (NSString *)toJSONString:(id)object;

/**
 * 获取唯一的UUID
 */
+ (NSString *)getUUID;

/**
 * 将NSInteger转成字符串
 */
+ (NSString *)toStr:(NSInteger)value;

/**
 * 将id类型转成int类型
 */
+ (NSInteger)toInteger:(id)value;

/**
 * 将id类型数据转成字符串
 */
+ (NSString *)toString:(id)value;


/**
 * 是否为系统表情输入模式
 */
+ (BOOL)isEmojiInputMode;


/**
 * 解析链接地址参数
 */
+ (NSString *)getQueryString:(NSString *)url paramName:(NSString *)paramName;

/**
 * 异步执行方法
 */
+ (void)dispatchAsync:(void (^)(id))handle complection:(void (^)(id))completion object:(id)object;

/**
 * 延时执行
 */
+ (void)delay:(void(^)(void))completion delayTime:(NSTimeInterval)delayTime;

/**
 * 图片加载
 */

+(void)seImageView:(UIImageView *)imageView withUrlSting:(NSString *)urlSting placeholderImage:(UIImage *)image;

/**
 * 获取搜索框中的输入框
 */
+ (UITextField *)getSearchBarTextField:(UISearchBar *)searchBar;

/**
 * 设置搜索框中的取消按钮样式
 */
+ (UIButton *)setSearchBarButtonStyle:(UISearchBar *)searchBar;

/**
 * 设置搜搜框的样式
 */
+ (void)setSearchBarStyle:(UISearchBar *)searchBar;
/**
 *  比较两个字符串是否相等
 *
 
 */
+ (BOOL)equals:(NSString *)string another:(NSString *)another;
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**
 * 生成分割线
 */
+ (CALayer *)addSeparatorLine:(UIView *)view frame:(CGRect)frame color:(UIColor *)color;
/**
 * 获取字符个数，一个中文算一个长度，两个英文算一个长度
 */
+ (NSUInteger)length:(NSString *)value;

+(void)getConfigueLabel:(UILabel *)label  font:(UIFont *)font aliment:(NSTextAlignment )aliment textcolor:(UIColor *)textColor text:(NSString *)text;

+(void)getButton:(UIButton *)button font:(UIFont *)font titleColor:(UIColor *)titleColor title:(NSString *)title;
//是否为合法邮箱
+(BOOL)validateEmail: (NSString *) candidate;
//是否为身份证号
+(BOOL) validateIdentityCard: (NSString *)identityCard;

+(BOOL) urlValidation:(NSString *)string;

//字符串是否包含汉子
+(BOOL)isHasChineseWithStr:(NSString *)strFrom ;
/**
 * 切圆角
 */
+(void)getCornerRadioWithView:(UIView *)inputView andCGSize:(CGSize)size;
/** 获取验证码时候的倒计时逻辑*/
+(void)getMessageCodeWithLabel:(UILabel *)label ;
/** 弹出登录界面*/
+(void)presentLoadControllerWithCurrentViewController:(UIViewController *)contorller;
/** 传入一个保留两位小数的*/
+(NSString *)FloatStringToDecemerStringWithCurrentString:(float)price;
/**将响应得到的字典转为json串存入本地 */
+(void)WriteResponseToJsonString;
/** 0.5秒后回到主页*/
+(void)popToViewControllersAfterSeconds:(UIViewController *)controller;
/**返回数字 */
+(BOOL)isNum:(NSString *)checkedNumString;
/** 计算文件大小*/
+(NSString *)byteUnitConvert:(long long)length;
/** 网络图片去汉子转译*/
+(NSString *)transfromUrlToNomalRule:(NSString *)uncodeUrl;
/** 判断字符串中是否包含汉子*/
+(BOOL)hasChinese:(NSString *)str;
/**发送微信授权请求 */
+(void)sendWechatAuthRequest;
/**发送QQ登录权限请求*/
+(void)sendQQAuthRequest:(TencentOAuth *)ouath;
/** 保存用户登录信息*/
+(void)saveUserDataWithObject:(id)responseObject;
/**
 * 增加导航按钮
 */
+ (UIBarButtonItem *)addBarButton:(UIViewController *)controller title:(NSString *)title action:(SEL)action position:(PositionType)position;

+(UIImageView *)setNoDataViewWithFrame:(UIView *)view andImageStr:(NSString *)imgstr;

/**
 * 从隐藏导航到进入不隐藏-->当需要进入更深层次时 在viewwlldisspa设置
 */
+(void)setPopHidenNavBarForFirstPageVc:(UIViewController *)controller;

/**
 * 打开图片选择器(从ActionSheet菜单中选择，ipad下无法打卡(ios8))
 */
+ (void)openImagePicker:(id)controller sourceType:(UIImagePickerControllerSourceType)sourceType allowsEditing:(BOOL)allowsEditing;

/**
 *  创建富文本label 显示图片加文字
 */
+(NSMutableAttributedString *)configueLabelAtLeft:(BOOL)left andCount:(NSInteger)count;

/**
 * 传2个时间字符串 求其差值时间 转为d : H :M :s 显示
 */
+(NSString *)getCountTimeWithString:(NSString *)limitTime andNowTime:(NSString *)currentTime;
/**
 * 跳转到聊天界面
 */
+(void)PushChatControllerWithType:(RCConversationType)type uid:(NSString *)uid name:(NSString *)name headImg:(NSString *)headImage  andCurrentVc:(UIViewController *)controller;

/**
 * 跳出导航 调到指定的Tabbar处..
 */
+(void)dismissNavGationToTabbarWithIndex:(NSInteger)index currentController:(UIViewController *)controller;
/**
 * 进入商品详情页面
 */
+(void)pushGoodsInfoDetailWithProductId:(NSString *)productId  andCurrentController:(UIViewController *)controller;

/**
 * 延迟执行操作
 */
+(void)hanldeSuccessPopAfterSecond:(CGFloat)second WithCunrrentController:(UIViewController *)controller;
/**
 * 进入到个人详情主页
 */
+(void)pushUserDetailInfoVcWithModel:(HKMyFollowAndFansList *)model andCurrentVc:(UIViewController *)controller;
/**
 * 进入到圈子主页
 */
+(void)pushCicleMainContentWithCicleId:(NSString *)cicleId andCurrentVc:(UIViewController *)controller;
/**
 * 进入店铺主页
 */
+(void)pushShopInfoWithShopId:(NSString *)shopId andCurrentVc:(UIViewController *)controller;
/**
 * 进入搜索界面
 */
+(void)pushGoodsSearchWithCurrentVc:(UIViewController *)controller;

@end
