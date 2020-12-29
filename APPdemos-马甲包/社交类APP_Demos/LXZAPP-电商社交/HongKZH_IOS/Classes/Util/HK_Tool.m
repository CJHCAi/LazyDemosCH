//
//  HK_Tool.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_Tool.h"
//#import "XY_LoginView.h"
//#import "XY_TabRegisterView.h"
#import "TTTAttributedLabel.h"
#import "UtilHKEnmu.h"
#import <UIKit/UIKit.h>
//#import <YWExtensionForCustomerServiceFMWK/YWExtensionForCustomerServiceFMWK.h>
//#import "SPKitExample.h"
//#import "SPUtil.h"
//#import "XY_SearchView.h"
@implementation HK_Tool
//// 根据颜色返回图片
//+ (UIImage *)imageWithUIColor:(UIColor*)color
//{
//    CIImage *ciImg = [[CIImage alloc] initWithColor:color.CIColor];
//    return [[UIImage alloc] initWithCIImage:ciImg];
//}

+ (NSString *)stringWithNSTimerinteral:(NSTimeInterval)inerval;
{
    NSInteger min = inerval/60;
    NSInteger sec = (NSInteger)inerval%60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}

+ (NSString *)GetTimeStamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    long long  a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%lld", a];
    return timeString;
}

+ (NSDate * )NSStringToNSDate: (NSString * )string
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: kDEFAULT_DATE_TIME_FORMAT];
    NSDate *date = [formatter dateFromString :string];
    return date;
}


//返回裁剪区域图片,返回裁剪区域大小图片

+ (UIImage *)clipWithImageRect:(CGRect)clipRect clipImage:(UIImage *)clipImage

{
    
    UIGraphicsBeginImageContext(clipRect.size);
    
    [clipImage drawInRect:CGRectMake(0,0,clipRect.size.width,clipRect.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return  newImage;
    
}

//+ (void)event:(NSString *)eventId label:(NSString *)label; // label为nil或@""时，等同于 event:eventId label:eventId;
//{
//    //    [MobClick event:eventId label:label];
//    [TalkingData trackEvent:eventId label:label];
//}
//+ (void)beginLogPageView:(NSString *)pageName
//{
//    //    [MobClick endLogPageView:pageName];
//    [TalkingData trackPageBegin:pageName withPageType:TDPageTypeGlance];
//}
//+ (void)endLogPageView:(NSString *)pageName
//{
//    //    [MobClick endLogPageView:pageName];
//    [TalkingData trackPageEnd:pageName];
//}
//
//+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;
//{
//    //    [MobClick event:eventId attributes:attributes];
//    [TalkingData trackEvent:eventId label:eventId parameters:attributes];
//}

// 根据颜色返回图片
+ (UIImage *)imageWithUIColor:(UIColor*)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 创建 UIImageView 对象
+ (UIImageView *)createNormalImageViewWithImageName:(NSString *)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    imgView.image = img;
    return imgView;
}

// 创建 分割线
+ (UIView *)createSeperateLineWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor blackColor];
    return view;
}

// 创建 button 对象 （图片背景）
+ (UIButton *)createNormalButtonWithNormalImageName:(NSString*)normal highlightName:(NSString*)highlight title:(NSString*)title target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (isStringNotEmpty(normal)) {
        UIImage *normalImage = [UIImage imageNamed:normal];
        [button setImage:normalImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    }
    
    if (isStringNotEmpty(highlight)) {
        [button setImage:[UIImage imageNamed:highlight] forState:UIControlStateHighlighted];
    }
    
    if (isStringNotEmpty(title)) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

// 创建 button 对象 (颜色背景)
+ (UIButton *)createColorButtonWithFrame:(CGRect)frame normalColor:(UIColor*)normal highlightColor:(UIColor*)highlight title:(NSString*)title target:(id)target selector:(SEL)selector
{
    UIButton *button = [HK_Tool createColorButtonWithFrame:frame normalColor:normal highlightColor:highlight title:title];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

// 创建 button 对象 (颜色背景,无selector)
+ (UIButton *)createColorButtonWithFrame:(CGRect)frame normalColor:(UIColor*)normal highlightColor:(UIColor*)highlight title:(NSString*)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    [button setBackgroundImage:[HK_Tool imageWithUIColor:normal size:frame.size] forState:UIControlStateNormal];
    [button setBackgroundImage:[HK_Tool imageWithUIColor:highlight size:frame.size] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[HK_Tool imageWithUIColor:[UIColor grayColor] size:frame.size] forState:UIControlStateDisabled];
    
    if (isStringNotEmpty(title)) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    }
    
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0f;
    
    return button;
}

// 创建 纯文字 按钮
+ (UIButton *)createTextButtonWithFrame:(CGRect)frame text:(NSString*)text target:(id)target selector:(SEL)selector
{
    UIButton *button = [HK_Tool createTextButtonWithFrame:frame text:text];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// 创建 纯文字 按钮（不带 selector）
+ (UIButton *)createTextButtonWithFrame:(CGRect)frame text:(NSString*)text
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    button.titleLabel.font = [UIFont systemFontOfSize:GLOBAL_FONT_SIZE_NORMAL];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    return button;
}



// 创建 导航栏 右键（纯文字）
+ (UIButton *)createNavigationRightButtonWithText:(NSString *)text target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWidth - GLOBAL_LEFT_PADDING_SMALL - 60.0f, HEIGHT_OF_STATUS_BAR, 60.0f, HEIGHT_OF_NAVIGATION_BAR);
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    button.titleLabel.font = [UIFont systemFontOfSize:GLOBAL_FONT_SIZE_LARG];
    [button.titleLabel sizeToFit];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, button.frame.size.width - button.titleLabel.frame.size.width, 0, 0)];
    
    return button;
}


// 创建 Label
+ (UILabel *)createNormalLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

// 创建 普通 label
+ (UILabel *)createSizeFitLabelWithText:(NSString *)text
{
    UILabel *label = [HK_Tool createNormalLabelWithFrame:CGRectZero text:text textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:GLOBAL_FONT_SIZE_NORMAL] alignment:NSTextAlignmentLeft];
    [label sizeToFit];
    return label;
}

// 创建 普通 label
+ (UILabel *)createSizeFitFortLabelWithText:(NSString *)text font:(int)font
{
    UILabel *label = [HK_Tool createNormalLabelWithFrame:CGRectZero text:text textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:font] alignment:NSTextAlignmentLeft];
    [label sizeToFit];
    return label;
}


// 创建 Label
+ (TTTAttributedLabel *)createNormalTTTLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment
{
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

// 创建 普通 label
+ (TTTAttributedLabel *)createSizeFitTTTLabelWithText:(NSString *)text
{
    TTTAttributedLabel *label = [HK_Tool createNormalTTTLabelWithFrame:CGRectZero text:text textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:GLOBAL_FONT_SIZE_NORMAL] alignment:NSTextAlignmentLeft];
    [label sizeToFit];
    return label;
}

// 创建 普通 label
+ (TTTAttributedLabel *)createSizeFitWhiteTTTLabelWithText:(NSString *)text textColor:(UIColor *)textColor
{
    TTTAttributedLabel *label = [HK_Tool createNormalTTTLabelWithFrame:CGRectZero text:text textColor:textColor font:[UIFont systemFontOfSize:GLOBAL_FONT_SIZE_NORMAL] alignment:NSTextAlignmentLeft];
    [label sizeToFit];
    return label;
}

// 创建 Label
+ (TTTAttributedLabel *)createNormalFortTTTLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment
{
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (TTTAttributedLabel *)createNormalFortTTTLabelWithLeftFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment
{
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}


+ (TTTAttributedLabel *)createNormalFortTTTLabelWithRightFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment
{
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentRight;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}


+ (TTTAttributedLabel *)createSizeFortTTTLabelWithText:(NSString *)text font:(UIFont *)font
{
    TTTAttributedLabel *label = [HK_Tool createNormalFortTTTLabelWithFrame:CGRectZero text:text textColor:[UIColor grayColor] font:font alignment:NSTextAlignmentCenter];
    [label sizeToFit];
    return label;
}

+ (TTTAttributedLabel *)createSizeFortTTTLabelWithLeftText:(NSString *)text font:(UIFont *)font
{
    TTTAttributedLabel *label = [HK_Tool createNormalFortTTTLabelWithLeftFrame:CGRectZero text:text textColor:[UIColor grayColor] font:font alignment:NSTextAlignmentLeft];
    [label sizeToFit];
    return label;
}

+ (TTTAttributedLabel *)createSizeFortTTTLabelWithRightText:(NSString *)text font:(UIFont *)font
{
    TTTAttributedLabel *label = [HK_Tool createNormalFortTTTLabelWithRightFrame:CGRectZero text:text textColor:[UIColor grayColor] font:font alignment:NSTextAlignmentRight];
    [label sizeToFit];
    return label;
}

#pragma mark - 生成字符串
// 生成唯一标示符
+ (NSString *)createUniqueString
{
    NSString *unique = @"";
    unique = [self createRandomString:32];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    unique = [NSString stringWithFormat:@"%@%.f", unique, timeInterval];
    unique = [NSString stringWithFormat:@"%@%@", unique, [self createRandomString:19]];
    return unique;
}

// 生成随机字符串
+ (NSString *)createRandomString:(NSInteger)length
{
    NSString *random = @"";
    for (int i = 0; i < length; i++) {
        random = [NSString stringWithFormat:@"%@%c", random, (char)('A' + (arc4random_uniform(26)))];
    }
    return random;
}

//添加各种字体颜色的label到视图
+(void)addLabel:(CGRect)rect title:(NSString *)title font:(UIFont *)font view:(UIView *)view align:(NSTextAlignment)align color:(UIColor *)color
{
    UILabel * label=[[UILabel alloc]initWithFrame:rect];
    label.text=title;
    label.textColor=color;
    label.font=font;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=align;
    [view addSubview:label];
}

//添加文本框（保留指针） wdsdfsdfsdf
+(void)addTextField:(CGRect)rect delegate:(id)delegate text:(NSString*)text textField:(UITextField *)textField view:(UIView *)view font:(UIFont *)font holdercolor:(UIColor*) color
{
    textField.frame=rect;
    textField.placeholder=text;
    textField.delegate = delegate;
    [textField setFont:font];
    [textField setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [view addSubview:textField];
}

//+(BOOL)NavigationLoginView:(UIViewController*)view
//{
//    XY_TabRegisterView * vc = [[XY_TabRegisterView alloc] init];
//    [view.navigationController pushViewController:vc animated:YES];
//
//    return NO;
//}


//+(BOOL)NavigationLoginView:(UIViewController*)view registerSucessBlock:(RegisterSucessBlock)registerSucessBlock;
//{
//    XY_TabRegisterView * vc = [[XY_TabRegisterView alloc] init];
//    vc.registerSucessBlock = registerSucessBlock;
//    [view.navigationController pushViewController:vc animated:YES];
//
//    return NO;
//}

//+(BOOL)NavigationLoginOrRegView:(UIViewController*)view LoginOrReg:(BOOL)state
//{
//    XY_LoginView * vc = [[XY_LoginView alloc] init];
//    [view.navigationController pushViewController:vc animated:YES];
//    if (state == NO) {
//        [vc SlideToReg];
//    }
//    return NO;
//}

//+(BOOL)NavMessageCenter:(UIViewController*)rootview
//{
//
//    if(!rootview ||!rootview.navigationController)
//    {
//        return NO;
//    }
//    __weak typeof(UIViewController*) weakSelf = rootview;
//    YWConversationListViewController *message = [[SPKitExample sharedInstance] exampleMakeConversationListControllerWithSelectItemBlock:^(YWConversation *aConversation) {
//        if ([aConversation isKindOfClass:[YWCustomConversation class]]) {
//            //            YWCustomConversation *customConversation = (YWCustomConversation *)aConversation;
//            //            [customConversation markConversationAsRead];
//            //            if ([customConversation.conversationId isEqualToString:SPTribeInvitationConversationID]) {
//            //                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tribe" bundle:nil];
//            //                UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SPTribeInvitationListViewController"];
//            //
//            //                [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
//            //                [weakSelf.navigationController pushViewController:controller animated:YES];
//            //            }
//            //            else {
//            //                YWWebViewController *controller = [YWWebViewController makeControllerWithUrlString:@"http://im.baichuan.taobao.com/" andImkit:[SPKitExample sharedInstance].ywIMKit];
//            //                __weak typeof(controller) weakController = controller;
//            //                [controller setViewWillAppearBlock:^(BOOL aAnimated) {
//            //                    [weakController.navigationController setNavigationBarHidden:NO animated:aAnimated];
//            //                }];
//            //                [controller setHidesBottomBarWhenPushed:YES];
//            //                [controller setTitle:@"功能介绍"];
//            //                [weakSelf.navigationController pushViewController:controller animated:YES];
//            //            }
//        } else {
//            [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithConversation:aConversation fromNavigationController:weakSelf.navigationController];
//        }
//    }];
//
//    message.ywcsTrackTitle = @"消息";
//
//    // 会话列表空视图
//    if (message)
//    {
//        CGRect frame = CGRectMake(0, 0, 100, 100);
//        UIView *viewForNoData = [[UIView alloc] initWithFrame:frame];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
//        imageView.center = CGPointMake(viewForNoData.frame.size.width/2, viewForNoData.frame.size.height/2);
//        [imageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
//
//        [viewForNoData addSubview:imageView];
//
//        message.viewForNoData = viewForNoData;
//    }
//
//    __weak typeof(message) weakController = message;
//    [[SPKitExample sharedInstance].ywIMKit setUnreadCountChangedBlock:^(NSInteger aCount) {
//        NSString *badgeValue = aCount > 0 ?[ @(aCount) stringValue] : nil;
//        //        weakController.tabBarItem.badgeValue = badgeValue;
//        if ([badgeValue isKindOfClass:[NSString class]]) {
//            [UserPreferences setString:[NSString stringWithFormat:@"%@",badgeValue] withKey:kMessageCnt];
//        }
//        else
//        {
//            [UserPreferences setString:@"0" withKey:kMessageCnt];
//        }
//        [[NSNotificationCenter defaultCenter]postNotificationName:kMessageCnt object:nil userInfo:nil];
//
//    }];
//
//    message.title = @"消息";
//
//    [[ViewModelLocator sharedModelLocator] initNav:message action:@selector(leftBtnPressed:)];
//    //    message.tabBarItem.image = [UIImage imageNamed:@"Message"];
//    //    message.tabBarItem.selectedImage = [UIImage imageNamed:@"MessageH"];
//
//    [rootview.navigationController pushViewController:message animated:YES];
//
//    [ViewModelLocator sharedModelLocator].isShowSPMsgBox = NO;
//    return NO;
//}

+(NSArray*)randomArray:(NSMutableArray*)source count:(NSInteger)count
{
    NSMutableSet *randomSet = [[NSMutableSet alloc] init];
    
    while ([randomSet count] < count) {
        int r = arc4random() % [source count];
        [randomSet addObject:[source objectAtIndex:r]];
    }
    
    NSArray *randomArray = [randomSet allObjects];
    
    return randomArray;
}

//+(void) pushURLString:(NSString*)url view:(UIViewController*)view
//{
//    if ([url isEqualToString:@"inapp://go/10"]) {
//        [Tool event:@"clk_search_#home" attributes:[NSDictionary dictionaryWithObject:[ViewModelLocator sharedModelLocator].keyword forKey:@"KEYWORD"]];
//        XY_SearchView* view = [[XY_SearchView alloc] init];
//        XY_BlackNavigationView *nav = [[XY_BlackNavigationView alloc]initWithRootViewController:view];
//        [view.navigationController presentViewController:nav animated:NO completion:nil];
//        return;
//    }
//
//    if (([url isEqualToString:@"inapp://go/6"] || [url isEqualToString:@"inapp://go/7"] || [url hasPrefix:@"inapp://go/19"]) ) {
//
//        if ([ViewModelLocator sharedModelLocator].userModel.islogin) {
//            [URLManager pushURLString:url animated:YES];
//        }
//        else
//        {
//            [Tool NavigationLoginView:view];
//        }
//    }
//    else
//    {
//        [URLManager pushURLString:url animated:YES];
//    }
//
//
//}
//
//+(void) pushURLString:(NSString*)url
//{
//
//    if (([url isEqualToString:@"inapp://go/6"] || [url isEqualToString:@"inapp://go/7"]|| [url isEqualToString:@"inapp://go/11"]) ) {
//
//        if ([ViewModelLocator sharedModelLocator].userModel.islogin) {
//            [URLManager pushURLString:url animated:YES];
//        }
//        else
//        {
//            [URLManager pushURLString:@"inapp://go/12" animated:YES];
//        }
//    }
//    else
//    {
//        [URLManager pushURLString:url animated:YES];
//    }
//
//
//}

+ (CGFloat)HeightForView:(id)view bottom:(UIView*)bottom offset:(CGFloat)offset{
    
    [view layoutIfNeeded];
    
    CGFloat rowHeight = bottom.frame.size.height + bottom.frame.origin.y;
    rowHeight += offset;
    
    return rowHeight;
}

+ (UIFont *)customFont:(NSString *)fontName size:(CGFloat)fontSize
{
    return [UIFont fontWithName:fontName size:fontSize];
}

+(UIFont*)customFontsize:(CGFloat)fontSize
{
    UIFont*font =  [HK_Tool customFont:@"Hiragino Sans GB" size:fontSize];
    //    UIFont*font =  [UIUtil customFont:@"FZXiYuan-M01" size:fontSize];
    //    UIFont*font =  [UIUtil customFont:@"FZBeiWeiKaiShu-S19S" size:fontSize];
    //    UIFont*font =  [UIUtil customFont:@"Heiti TC" size:fontSize];
    
    
    return font;
}

static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}


+(UIColor*)mostColor:(UIImage*)image{
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(40, 40);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    NSArray *MaxColor=nil;
    // NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    float maxScore=0;
    for (int x=0; x<thumbSize.width*thumbSize.height; x++) {
        
        
        int offset = 4*x;
        
        int red = data[offset];
        int green = data[offset+1];
        int blue = data[offset+2];
        int alpha =  data[offset+3];
        
        if (alpha<25)continue;
        
        float h,s,v;
        RGBtoHSV(red, green, blue, &h, &s, &v);
        
        float y = MIN(abs(red*2104+green*4130+blue*802+4096+131072)>>13, 235);
        y= (y-16)/(235-16);
        if (y>0.9) continue;
        
        float score = (s+0.1)*x;
        if (score>maxScore) {
            maxScore = score;
        }
        MaxColor=@[@(red),@(green),@(blue),@(alpha)];
        //[cls addObject:clr];
        
        
        
    }
    CGContextRelease(context);
    
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}


/**
 
 *  计算文字尺寸
 
 *  @param text    需要计算尺寸的文字
 
 *  @param font    文字的字体
 
 *  @param maxSize 文字的最大尺寸
 
 */

+  (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize

{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
}

//+(void)addCommodityMode
//{
//    XY_CommodityModel * commodityModel = [[XY_CommodityModel alloc] init];
//    commodityModel.price = @"7499";
//    commodityModel.brand = @"ALEXANDER MCQUEEN";
//    commodityModel.title = @"亚历山大·麦昆牛皮材质女士手提包";
//    commodityModel.stock = @"435";
//    commodityModel.store = @"西有全球好店";
//    commodityModel.destail =  @"ALEXANDER MCQUEEN桃粉色牛皮材质纯色女士手提包";
//    commodityModel.cnt = 1;
//    commodityModel.paramerModel = nil;
//    commodityModel.sizeModel = nil;
//    commodityModel.colorModel = nil;
//
//    NSArray * arr = [NSArray arrayWithObjects:@"http://p10.ytrss.com/product/20/554/9039/ZoomImage/13513.jpg",
//                     @"http://p10.ytrss.com/product/20/554/9039/ZoomImage/2498.jpg",
//                     @"http://p10.ytrss.com/product/20/554/9039/ZoomImage/3626.jpg",
//                     @"http://p10.ytrss.com/product/20/554/9039/ZoomImage/55048.jpg",
//                     @"http://p10.ytrss.com/product/20/554/9039/ZoomImage/46350.jpg",
//                     @"http://p10.ytrss.com/product/20/554/9039/ZoomImage/9703.jpg",
//                     @"http://p10.ytrss.com/product/20/554/9039/ZoomImage/22093.jpg",
//                     @"http://p10.ytrss.com/product/20/554/9039/ZoomImage/9681.jpg",
//                     @"http://p10.ytrss.com/product/20/554/9039/ZoomImage/64862.jpg",
//                     nil];
//
//    for (NSString * url in arr) {
//        XY_FlowImageModel * val = [[XY_FlowImageModel alloc] init];
//        val.imageurl = url;
//        val.imgsize = CGSizeMake(kScreenWidth, 450);
//        [commodityModel.rootflowImageModel addChild:val];
//    }
//    //
//    arr = [NSArray arrayWithObjects:@"X", @"S", @"M", @"L", @"XL", @"XXL",@"3XL",nil];
//
//    for (NSString * value in arr) {
//        if (!value) {
//            continue;
//        }
//        XY_CommoditySizeModel * val = [[XY_CommoditySizeModel alloc] init];
//        val.value = value;
//        [commodityModel.sizeModel addChild:val];
//    }
//    arr = [NSArray arrayWithObjects:@"红色", @"蓝色", @"黑色", @"白色", @"粉红色", @"灰色",@"红色", @"蓝色", @"黑色", @"白色", @"粉红色",nil];
//    for (NSString * value in arr) {
//        if (!value) {
//            continue;
//        }
//        XY_CommodityColorModel * val1 = [[XY_CommodityColorModel alloc] init];
//        val1.value = value;
//        [commodityModel.colorModel addChild:val1];
//    }
//    [ViewModelLocator sharedModelLocator].commodityModel = commodityModel;
//}

+(UIColor *)getColor:(NSString *)cString
{
    //    NSString *cString = @"#24DB54";
    if ([cString isKindOfClass:[NSString class]] && cString.length  == 7) {
        NSRange range;
        range.location = 1;
        range.length = 2;
        NSString *rString = [cString substringWithRange:range];
        
        range.location = 3;
        NSString *gString = [cString substringWithRange:range];
        
        range.location = 5;
        NSString *bString = [cString substringWithRange:range];
        
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        //NSLog(@"r = %u, g = %u, b = %u",r, g, b);
        UIColor *color  = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
        return color;
    }
    return [UIColor whiteColor];
    
}

+(float)calculationStringLenght:(NSString *)fullDescAndTagStr Wight:(int)labelWidth
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:fullDescAndTagStr];
    
    NSRange allRange = [fullDescAndTagStr rangeOfString:fullDescAndTagStr];
    
    [attrStr addAttribute:NSFontAttributeName
     
                    value:[UIFont systemFontOfSize:13.0]
     
                    range:allRange];
    
    [attrStr addAttribute:NSForegroundColorAttributeName
     
                    value:[UIColor blackColor]
     
                    range:allRange];
    
    
    NSString * tagStr = @"";
    NSRange destRange = [fullDescAndTagStr rangeOfString:tagStr];//tagStr 是需要特殊显示处理的子字符串.
    
    [attrStr addAttribute:NSForegroundColorAttributeName
     
                    value:UICOLOR_RGB_Alpha(0x009cdd, 1)
     
                    range:destRange];
    
    CGFloat titleHeight;
    
    
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                   
                                        options:options
                   
                                        context:nil];
    
    titleHeight = ceilf(rect.size.height);
    
    
    
    return titleHeight+2;
}
//计算字符串高度，固定宽度

/**
 *  倒计时
 *
 *  @param endTime 截止的时间戳
 *
 *  @return 返回的剩余时间
 */
- (NSString*)remainingTimeMethodAction:(long long)endTime
{
    //得到当前时间
    NSDate *nowData = [NSDate date];
    NSDate *endData=[NSDate dateWithTimeIntervalSince1970:endTime];
    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
    NSUInteger unitFlags =
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:nowData  toDate: endData options:0];
    NSInteger Hour  = [cps hour];
    NSInteger Min   = [cps minute];
    NSInteger Sec   = [cps second];
    NSInteger Day   = [cps day];
    NSInteger Mon   = [cps month];
    NSInteger Year  = [cps year];
    NSLog(  @" From Now to %@, diff: Years: %d  Months: %d, Days; %d, Hours: %d, Mins:%d, sec:%d",
          [nowData description], Year, Mon, Day, Hour, Min,Sec );
    NSString *countdown = [NSString stringWithFormat:@"还剩: %zi天 %zi小时 %zi分钟 %zi秒   ", Day,Hour, Min, Sec];
    if (Sec<0) {
        countdown=[NSString stringWithFormat:@"活动结束/开始抢购"];
    }
    return countdown;
}


@end




//#import <CommonCrypto/CommonCrypto.h>
//#import <AdSupport/AdSupport.h>
//#import "WXUtil.h"
//#import "NSDataEx.h"
//
//#define gdt_encrypt_key @"BAAAAAAAAAAAFTuX"
//#define gdt_sign_key    @"f655d5b0f678a614";
//#define gdt_app_id      @"1080864259"
//#define gdt_advertiser_id @"1391511"
//
//@interface LGGuangDianTong()
//
//
//@end
//@implementation LGGuangDianTong
//
//
////激活发送
//+ (void)send {
//    LGGuangDianTong *gdt = [[LGGuangDianTong alloc] init];
//
//    if ([UserPreferences  getBoolWithKey:@"KEY_DB_ADVERTISER_ACTIVE" withDefault:NO]) {
//        return;
//    }
//
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[gdt generateUrl]]];
//    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSError *error = nil;
//        if (!connectionError) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//            if ([[[dic objectForKey:@"ret"] stringValue] isEqualToString:@"0"]) {
//                //            NSLog(@"发送成功");
//                [UserPreferences setBool:YES withKey:@"KEY_DB_ADVERTISER_ACTIVE"];
//            } else {
//                //            NSLog(@"发送失败");
//            }
//        }
//
//    }];
//}
//
////生成url
//- (NSString *)generateUrl {
//
//    NSString *result = @"";
//
//    NSString *encrypt_key = gdt_encrypt_key;
//    NSString *sign_key = gdt_sign_key;
//    NSString *app_id = gdt_app_id;
//    NSString *idfa =[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    NSString *conv_type = @"MOBILEAPP_ACTIVITE";
//    NSString *app_type = @"IOS";
//    NSString *advertiser_id = gdt_advertiser_id;
//
//    NSString *conv_time = [NSString stringWithFormat:@"%.0lf", [NSDate date].timeIntervalSince1970];
//
//    NSString *muid = [self generateMuid:idfa];
//    NSString *query_string = [NSString stringWithFormat:@"muid=%@&conv_time=%@", muid, conv_time];
//
//    NSString *encode_page = [NSString stringWithFormat:@"http://t.gdt.qq.com/conv/app/%@/conv?%@", app_id, query_string];
//    NSString *temp = [NSString stringWithFormat:@"%@&GET&%@", sign_key, [encode_page URLEncode]];
//    NSString *signature = [[WXUtil md5:temp] lowercaseString];
//    NSString* base_data = [query_string stringByAppendingFormat:@"&sign=%@", signature];
//    NSString* v_data = [[[self simpleXor:base_data key:encrypt_key] base64Encoding] URLEncode];
//
//    NSLog(@"query_string: %@", query_string);
//    NSLog(@"v_data: %@", v_data);
//
//    result = [NSString stringWithFormat:@"http://t.gdt.qq.com/conv/app/%@/conv?v=%@&conv_type=%@&app_type=%@&advertiser_id=%@", app_id, v_data, conv_type, app_type, advertiser_id];
//    NSLog(@"\n%@", result);
//    return result;
//}
//
////生成muid
//- (NSString *)generateMuid:(NSString *)idfa {
//    idfa = [idfa uppercaseString];
//    NSString* result = [[WXUtil md5:idfa] lowercaseString];
//    NSLog(@"muid--%@", result);
//    return result;
//}
//
////异或操作
//- (NSData *)simpleXor:(NSString *)info key:(NSString *)key {
//
//    const char *infoBytes = [info UTF8String];
//    const char *keyBytes = [key UTF8String];
//
//    int i = 0, j = 0;
//    char *bytes = malloc(strlen(infoBytes));
//    for (i = 0; i < strlen(infoBytes); i++) {
//        bytes[i] = (char)(infoBytes[i]^keyBytes[j]);
//
//        j++;
//        j = j%(key.length);
//    }
//
//    //这一定要用strlen(infoBytes),不要用strlen(bytes),因为bytes里面有\0,而strlen只计算\0之前数，所以最终的长度偏小
//    NSData *data = [NSData dataWithBytes:bytes length:strlen(infoBytes)];
//    return data;
//}
//@end
