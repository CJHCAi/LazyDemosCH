//
//  AppUtils.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "AppUtils.h"
#import <sys/utsname.h>
#import "HK_loginController.h"
#import "HKLoginViewModel.h"
#import "AppDelegate.h"
#import "LCTabBarController.h"
#import "HKDetailsPageViewController.h"
#import "HKFrindMainVc.h"
#import "HK_CladlyChattesView.h"
#import "WXApi.h"
@implementation AppUtils
const int GB = 1024 * 1024 * 1024;//定义GB的计算常量
const int MB = 1024 * 1024;//定义MB的计算常量
const int KB = 1024;//定义KB的计算常量
+ (NSString *)currentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
+(NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    return platform;
}
+ (NSString *)trim:(NSString *)value
{
    if (value == nil) {
        return nil;
    }
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [value stringByReplacingOccurrencesOfString:@"\u2006" withString:@""];
}
+ (BOOL)isEmpty:(NSString *)value
{
    return value == nil || [AppUtils trim:value].length == 0;
}

+ (BOOL)isNotEmpty:(NSString *)value
{
    if ([value isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    return ![AppUtils isEmpty:value];
}
+ (BOOL)isEmptyArray:(NSArray *)values
{
    if ([values isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return values == nil || values.count == 0;
}

+ (BOOL)isNotEmptyArray:(NSArray *)values
{
    return ![self isEmptyArray:values];
}
+ (NSString *)encodeURL:(NSString *)value
{
    if (value == nil) {
        return @"";
    }
    NSMutableString *temp = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@", value]];
    NSString *resultStr = value;
    CFStringRef originalString = (__bridge CFStringRef) temp;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!'();:@&=+$,/?%#[]~");
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    if (escapedStr) {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        if (!mutableStr || [mutableStr isKindOfClass:[NSNull class]] || mutableStr.length <= 0) {
            return resultStr;
        }
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"+"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    return resultStr;
}

+ (NSString *)decodeURL:(NSString *)value
{
    if ([self isEmpty:value]) {
        return nil;
    }
    NSMutableString *outputStr = [NSMutableString stringWithString:value];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, outputStr.length)];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+ (id)parseJSON:(NSString *)value
{
    
    id object = nil;
    @try {
        
        NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
    }
    @catch (NSException *exception) {
        
//        DSLog(@"%s [Line %d] JSON字符串转成对象出错，原因：%@",  __PRETTY_FUNCTION__, __LINE__, exception);
    }
    return object;
}

+ (NSString *)toJSONString:(id)object

{
    NSString *jsonStr = @"";
    @try {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
//        DSLog(@"%s [Line %d] 对象转成JSON字符串出错，原因：%@", __PRETTY_FUNCTION__, __LINE__, exception);
    }
    return jsonStr;
}
#pragma mark 获取应用程序安装之后生成的UUID
+ (NSString *)getUUID
{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return [uuid lowercaseString];
}

+ (NSString *)toStr:(NSInteger)value
{
    return [NSString stringWithFormat:@"%d", value];
}

+ (NSInteger)toInteger:(id)value
{
    return [[AppUtils toString:value] integerValue];
}
+ (NSString *)toString:(id)value
{
    if (!value) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", value];
}
+ (BOOL)isEmojiInputMode
{
    return [[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"];
}
+ (NSString *)getQueryString:(NSString *)url paramName:(NSString *)paramName
{
    NSError *error;
    NSString *pattern = [[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", paramName];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:url options:NSMatchingReportCompletion range:NSMakeRange(0, url.length)];
    for (NSTextCheckingResult *match in matches) {
        return [url substringWithRange:[match rangeAtIndex:2]];
    }
    return nil;
}

+ (void)dispatchAsync:(void (^)(id))handle complection:(void (^)(id))completion object:(id)object
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // 处理异步业务
        handle(object);
        // 异步执行完后，回到主线程执行操作
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(object);
        });
    });
}

+ (void)delay:(void (^)(void))completion delayTime:(NSTimeInterval)delayTime
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayTime * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), completion);
}
+(void)seImageView:(UIImageView *)imageView withUrlSting:(NSString *)urlSting placeholderImage:(UIImage *)image {
    
    NSString *imgUrl = [urlSting  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (![imgUrl hasPrefix:@"http://"]) {
        imgUrl = [NSString stringWithFormat:@"%@/%@",host_imgText,imgUrl];
    }
    NSURL *url= [NSURL URLWithString:imgUrl];
    [imageView sd_setImageWithURL:url placeholderImage:image];
}

/** 网络地址带汉子进行转译*/
+(NSString *)transfromUrlToNomalRule:(NSString *)uncodeUrl {
    
    NSString *imgUrl = [uncodeUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return imgUrl;
}
+ (BOOL)equals:(NSString *)string another:(NSString *)another
{
    if (string == nil && another == nil) {
        return YES;
    }
    if (string == nil || another == nil) {
        return NO;
    }
    return [string isEqualToString:another];
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        DLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (CALayer *)addSeparatorLine:(UIView *)view frame:(CGRect)frame color:(UIColor *)color
{
    CALayer *separator = [[CALayer alloc] init];
    separator.frame = frame;
    UIColor *borderColor = color ? color : [UIColor colorFromHexString:@"c8c7cc"];
    separator.borderColor = borderColor.CGColor;
    separator.borderWidth = frame.size.height;
    [view.layer addSublayer:separator];
    return separator;
}
+ (NSUInteger)length:(NSString *)value
{
    if ([AppUtils isEmpty:value]) {
        return 0;
    }
    int i,n = [value length],l = 0,a = 0,b = 0;
    unichar c;
    for(i = 0; i < n; i++){
        c = [value characterAtIndex:i];
        if(isblank(c)){
            b++;
        } else if (isascii(c)) {
            a++;
        } else {
            l++;
        }
    }
    if (a == 0 && l == 0) {
        return 0;
    }
    NSInteger total = l + (int)ceilf((float)(a + b) / 2.0);
//    DSLog(@"length:%d  words:%@ ",total,value);
    return total;
}
+(void)getConfigueLabel:(UILabel *)label font:(UIFont *)font aliment:(NSTextAlignment)aliment textcolor:(UIColor *)textColor text:(NSString *)text {
    
    label.font =font;
    label.textAlignment =aliment;
    
    label.textColor =textColor;
    label.text =text;
    
    
}
+(void)getButton:(UIButton *)button font:(UIFont *)font titleColor:(UIColor *)titleColor title:(NSString *)title {
    
    button.titleLabel.font =font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    
}

+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    
    
    return [emailTest evaluateWithObject:candidate];
}
////邮箱
//+ (BOOL) validateEmail:(NSString *)email
//{
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    return [emailTest evaluateWithObject:email];
//}

+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+(BOOL)isHasChineseWithStr:(NSString *)strFrom {
    for (int i=0; i<strFrom.length; i++) {
        NSRange range =NSMakeRange(i, 1);
        NSString * strFromSubStr=[strFrom substringWithRange:range];
        const char *cStringFromstr = [strFromSubStr UTF8String];
        if (strlen(cStringFromstr)==3) {
            //汉字
            return YES;
        } else if (strlen(cStringFromstr)==1) {
            //字母
        }
    }
    return NO;
}
/**切圆角*/
+(void)getCornerRadioWithView:(UIView *)inputView andCGSize:(CGSize)size {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:inputView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = inputView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    inputView.layer.mask = maskLayer;
}
/** 获取验证码*/
+(void)getMessageCodeWithLabel:(UILabel *)label {
    
    label.userInteractionEnabled = NO;
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                label.text = @"获取验证码";
                label.userInteractionEnabled = YES;
                label.textAlignment =NSTextAlignmentCenter;
            });
        }else{
            int seconds = timeout;
            dispatch_async(dispatch_get_main_queue(), ^{
                label.text = [NSString stringWithFormat:@"%ld秒后重新获取",(long)seconds];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
/** 返回数字*/
+(BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    
    return YES;
}
+(BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}
+(NSString *)byteUnitConvert:(long long)length {
    NSString *unit = @"B";
    CGFloat unitLegth = length;
    
    if (length / GB >= 1){//如果当前Byte的值大于等于1GB
        unit = @"GB";
        unitLegth = 1.0f*length / GB;
    }else if (length / MB >= 1){//如果当前Byte的值大于等于1MB
        if(length / MB >= 1000){
            unit = @"GB";
            unitLegth = 1.0f*length / GB;
        }else{
            unit = @"MB";
            unitLegth = 1.0f*length / MB;
        }
    }else if (length / KB >= 1){//如果当前Byte的值大于等于1KB
        if(length / KB >= 1000){
            unit = @"MB";
            unitLegth = 1.0f*length / MB;
        }else{
            unit = @"KB";
            unitLegth = 1.0f*length / KB;
        }
    }else{
        if(length >= 1000){
            unit = @"KB";
            unitLegth = 1.0f*length / KB;
        }
    }
    return [NSString stringWithFormat:@"%.2f%@",unitLegth,unit];
    
}
/**0.5后回到主页 */
+(void)popToViewControllersAfterSeconds:(UIViewController *)controller {
    [controller performSelector:@selector(backPop:) withObject:controller afterDelay:0.5];
}

-(void)backPop:(UIViewController *)vc {
    [vc.navigationController popViewControllerAnimated:YES];
}
/** 获得精度更高的浮点型字符串*/
+(NSString *)FloatStringToDecemerStringWithCurrentString:(float)price {
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSString *priceStr =[NSString stringWithFormat:@"%.3f",price];
    NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:priceStr];
    NSDecimalNumber *yy = [a decimalNumberByRoundingAccordingToBehavior:roundUp];
    //不足的补0
    NSString *outStr =[NSString stringWithFormat:@"%@",yy];
    DLog(@"outStr==%@",outStr);
    
    if (![outStr containsString:@"."] ) {
        
        outStr =[NSString stringWithFormat:@"%@.00",outStr];
        
    }else if ([outStr containsString:@"."]){
        
        NSMutableString *mutable =[[NSMutableString  alloc] initWithString:outStr];
        //切割 查看第二个数组个数..
        NSArray *array =[mutable componentsSeparatedByString:@"."];
        NSString *lastStr =array.lastObject;
        
        if (lastStr.length<2) {
            
            outStr =[NSString stringWithFormat:@"%@0",outStr];
        }
    }
    return  outStr;
}
/**
弹出登录界面
 */
+(void)presentLoadControllerWithCurrentViewController:(UIViewController *)contorller  {
   
    HK_loginController * login =[[HK_loginController alloc] initWithNibName:@"HK_loginController" bundle:nil];
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:login];
    [contorller presentViewController:nav animated:YES completion:^{
        
    }];
}
/**
 *验证手机号是否合法
 */
+(BOOL)verifyPhoneNumbers:(NSString *)phoneNumberStr {
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9])|(19[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumberStr];
    
    if (!isMatch)
    {
        return NO;
    }
    return YES;
}
/**
 * 发送微信授权请求
 */
+(void)sendWechatAuthRequest {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    
}
/**
* 保存用户登录信息
*/
+(void)saveUserDataWithObject:(id)responseObject {

    //用户信息保存到本地中
    LoginUserData * data =[LoginUserDataModel getUserInfoItems];
    data.name = nil;
    data.loginUid = nil;
    [LoginUserDataModel clearLoginUse];
    
    [LoginUserDataModel saveLoginUser:responseObject];
    //登录融云
    [HKLoginViewModel addRCIM];
    //存一个字符串
    NSUserDefaults * userD =[NSUserDefaults standardUserDefaults];
    [userD setValue:data.loginUid forKey:@"loginId"];
    [userD synchronize];
    
}
+ (UIBarButtonItem *)addBarButton:(UIViewController *)controller title:(NSString *)title action:(SEL)action position:(PositionType)position
{
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:controller action:action forControlEvents:UIControlEventTouchUpInside];
    
    if ([title isEqualToString:@"search"]) {
        
        [button setImage:[UIImage imageNamed:@"class_search"] forState:UIControlStateNormal];
    }else if ([title isEqualToString:@"分享"]){
        [button setImage:[UIImage imageNamed:@"class_share"] forState:UIControlStateNormal];
        
    }else if ([title isEqualToString:@"buy_more"]){
        
        [button setImage:[UIImage imageNamed:@"buy_more"] forState:UIControlStateNormal];
        
    }else if ([title isEqualToString:@"更多"]){
        
        [button setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    }else if ([title isEqualToString:@"转发"]) {
        [button setImage:[UIImage imageNamed:@"BQfenxiang"] forState:UIControlStateNormal];
    }else if ([title isEqualToString:@"取消"]||[title isEqualToString:@"投诉"]) {
        
        [button  setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        
        
    }else if ([title isEqualToString:@"邀请"]||[title isEqualToString:@"上传"]||[title isEqualToString:@"发布"]||[title isEqualToString:@"发送"]||[title isEqualToString:@"完成"]) {
        [button  setTitleColor:[UIColor colorFromHexString:@"999999"] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];

    }else if ([title isEqualToString:@"跳过"]||[title isEqualToString:@"保存"]||[title isEqualToString:@"提交"]){
        [button  setTitleColor:[UIColor colorFromHexString:@"666666"] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font =PingFangSCMedium15;
        
    }else if ([title isEqualToString:@"视频"]) {
        [button setImage:[UIImage imageNamed:@"upShow"] forState:UIControlStateNormal];
    }else if ([title isEqualToString:@"评论"]){
        [button setImage:[UIImage imageNamed:@"upCommic"] forState:UIControlStateNormal];
    }else if ([title isEqualToString:@"举报"]) {
        [button setImage:[UIImage imageNamed:@"report"] forState:UIControlStateNormal];
    }else if ([title isEqualToString:@"关闭"]) {
        [button setImage:[UIImage imageNamed:@"feedClose"] forState:UIControlStateNormal];
    }else if ([title isEqualToString:@"投屏"]) {
        [button setImage:[UIImage imageNamed:@"tvCast"] forState:UIControlStateNormal];
    }
    if (button.currentImage) {
        button.frame =CGRectMake(0,0,button.currentImage.size.width,button.currentImage.size.height);
    }else {
        button.frame =CGRectMake(0,0,40,40);
        button.titleLabel.font =[UIFont systemFontOfSize:15];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    UIBarButtonItem *barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    
    if (position == PositionTypeLeft) {
        button.frame =CGRectMake(0,0,40,40);
        button.titleLabel.font =[UIFont systemFontOfSize:15];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        controller.navigationItem.leftBarButtonItem =barButton;
        
    } else {
        
        controller.navigationItem.rightBarButtonItem = barButton;
    }
    
    return barButton;
}
+(void)setPopHidenNavBarForFirstPageVc:(UIViewController *)controller {
    NSArray *viewControllers = controller.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == controller) {
        //push
        [controller.navigationController setNavigationBarHidden:NO animated:YES];
    } else if ([viewControllers indexOfObject:controller] == NSNotFound) {
        //pop
        [controller.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

+(UIImageView *)setNoDataViewWithFrame:(UIView *)view andImageStr:(NSString *)imgstr
{
    UIImageView * nodataV =[[UIImageView alloc] initWithFrame:view.bounds];
    nodataV.image = [UIImage imageNamed:imgstr];
    DLog(@"%@",nodataV.image);
    return nodataV;
}

#pragma mark 拍照 上传
+ (void)openImagePicker:(id)controller sourceType:(UIImagePickerControllerSourceType)sourceType allowsEditing:(BOOL)allowsEditing
{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {

        return;
    }
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [self setImagePickerStyle:imgPicker];
    [imgPicker setSourceType:sourceType];
    [imgPicker setDelegate:controller];
    //是否可以裁剪
    [imgPicker setAllowsEditing:allowsEditing];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        UIViewController *vc = controller;
        vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [controller presentViewController:imgPicker animated:YES completion:^{}];
}
+ (void)setImagePickerStyle:(UIImagePickerController *)controller
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]==6.0) {
        // 修复导航栏高度问题
        controller.navigationBar.clipsToBounds = YES;
    }
}

/**
 * 创建图片加文字的 text
 */
+(NSMutableAttributedString *)configueLabelAtLeft:(BOOL)left andCount:(NSInteger)count {
    NSString *countStr;
    if (count==-1) {
        countStr =@"当前乐币剩余";
    }else {
        countStr =[NSString stringWithFormat:@"%zd",count];
    }
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"514_goldc_"];
    attch.bounds = CGRectMake(0,-1,12,12);
    //创建带有图片的富文本
    NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attch];
    if (left) {
      //图片在左边
        //创建富文本
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",countStr]];
        [attri insertAttributedString:string atIndex:0];
        
        return  attri;
    }else {
       //图片在右侧
        //创建富文本
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",countStr]];
        [attri appendAttributedString:string];
        
        return  attri;
   
    }
}
//倒计时 显示文本
+(NSString *)getCountTimeWithString:(NSString *)limitTime andNowTime:(NSString *)currentTime {
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:limitTime];
    
    NSDate  *nowDate = [formater dateFromString:currentTime];
//    // 当前时间字符串格式
//    NSString *nowDateStr = [formater stringFromDate:nowDate];
//    // 当前时间date格式
//    nowDate = [formater dateFromString:nowDateStr];
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return @"支付时间截止";
    }
//    if (days) {
//        return [NSString stringWithFormat:@"支付:%@:%@:%@:%@", dayStr,hoursStr, minutesStr,secondsStr];
//    }
    return [NSString stringWithFormat:@"支付 %@:%@:%@",hoursStr , minutesStr,secondsStr];
}

+(void)PushChatControllerWithType:(RCConversationType)type uid:(NSString *)uid name:(NSString *)name headImg:(NSString *)headImage  andCurrentVc:(UIViewController *)controller  {
    HK_CladlyChattesView    *chat = [[HK_CladlyChattesView alloc] initWithConversationType:type targetId:uid];
    //设置聊天会话界面要显示的标题
    chat.title = name;
    [controller.navigationController pushViewController:chat animated:YES];
}

+(void)pushUserDetailInfoVcWithModel:(HKMyFollowAndFansList *)model andCurrentVc:(UIViewController *)controller {
    HKFrindMainVc *mainVc =[[HKFrindMainVc alloc] init];
    mainVc.listModel = model;
    [controller.navigationController pushViewController:mainVc animated:YES];
}
+(void)dismissNavGationToTabbarWithIndex:(NSInteger)index currentController:(UIViewController *)controller {
    [UIView animateWithDuration:0 animations:^{
        [controller.navigationController popToRootViewControllerAnimated:YES];
    } completion:^(BOOL finished) {
        AppDelegate *delegete =(AppDelegate *)[UIApplication sharedApplication].delegate;
        LCTabBarController *tabLC =(LCTabBarController *)delegete.window.rootViewController;
        [tabLC setSelectedIndex:index];
    }];
}
+(void)pushGoodsInfoDetailWithProductId:(NSString *)productId  andCurrentController:(UIViewController *)controller {
    HKDetailsPageViewController *detail =[[HKDetailsPageViewController alloc] init];
    detail.productId = productId;
    [controller.navigationController pushViewController:detail animated:YES];
}

+(void)hanldeSuccessPopAfterSecond:(CGFloat)second WithCunrrentController:(UIViewController *)controller {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, second*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [controller.navigationController popViewControllerAnimated:YES];
        
    });
}
+(void)pushCicleMainContentWithCicleId:(NSString *)cicleId andCurrentVc:(UIViewController *)controller {
    HKMyCircleViewController*vc = [[HKMyCircleViewController alloc]init];
    vc.circleId = cicleId;
    [controller.navigationController pushViewController:vc animated:YES];
}
+(void)pushShopInfoWithShopId:(NSString *)shopId andCurrentVc:(UIViewController *)controller {
    HKShopHomeVc *shopVC =[[HKShopHomeVc alloc] init];
    shopVC.shopId = shopId;
    [controller.navigationController pushViewController:shopVC animated:YES];
}
+(void)pushGoodsSearchWithCurrentVc:(UIViewController *)controller {
    HKGoodsSearchViewController*vc = [[HKGoodsSearchViewController alloc]init];
  
    [controller.navigationController pushViewController:vc animated:YES];
}

@end
