//
//  HK_Tool.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "XY_TabRegisterView.h"
@class TTTAttributedLabel;
@interface HK_Tool : NSObject
+ (NSString *)stringWithNSTimerinteral:(NSTimeInterval)inerval;
+ (NSString *)GetTimeStamp;
+ (void)event:(NSString *)eventId label:(NSString *)label; // label为nil或@""时，等同于 event:eventId label:eventId;
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;
+ (void)beginLogPageView:(NSString *)pageName;
+ (void)endLogPageView:(NSString *)pageName;
//返回裁剪区域图片,返回裁剪区域大小图片
+ (UIImage *)clipWithImageRect:(CGRect)clipRect clipImage:(UIImage *)clipImage;

+ (NSDate * )NSStringToNSDate: (NSString * )string;

// 根据颜色返回图片
+ (UIImage *)imageWithUIColor:(UIColor*)color size:(CGSize)size;

// 创建 UIImageView 对象
+ (UIImageView *)createNormalImageViewWithImageName:(NSString *)imageName;

// 创建 分割线
+ (UIView *)createSeperateLineWithFrame:(CGRect)frame;

// 创建 button 对象 (图片背景)
+ (UIButton *)createNormalButtonWithNormalImageName:(NSString*)normal highlightName:(NSString*)highlight title:(NSString*)title target:(id)target selector:(SEL)selector;

// 创建 button 对象 (颜色背景)
+ (UIButton *)createColorButtonWithFrame:(CGRect)frame normalColor:(UIColor*)normal highlightColor:(UIColor*)highlight title:(NSString*)title target:(id)target selector:(SEL)selector;

// 创建 button 对象 (颜色背景,无selector)
+ (UIButton *)createColorButtonWithFrame:(CGRect)frame normalColor:(UIColor*)normal highlightColor:(UIColor*)highlight title:(NSString*)title;

// 创建 纯文字 按钮
+ (UIButton *)createTextButtonWithFrame:(CGRect)frame text:(NSString*)text target:(id)target selector:(SEL)selector;

// 创建 纯文字 按钮（不带 selector）
+ (UIButton *)createTextButtonWithFrame:(CGRect)frame text:(NSString*)text;

// 创建 导航栏 右键（纯文字）
+ (UIButton *)createNavigationRightButtonWithText:(NSString *)text target:(id)target selector:(SEL)selector;

// 创建 Label
+ (UILabel *)createNormalLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment;

// 创建 普通 label
+ (UILabel *)createSizeFitLabelWithText:(NSString *)text;

// 创建 普通 label
+ (UILabel *)createSizeFitFortLabelWithText:(NSString *)text font:(int)font;

// 创建 Label
+ (TTTAttributedLabel *)createNormalTTTLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)alignment;

// 创建 普通 label
+ (TTTAttributedLabel *)createSizeFitTTTLabelWithText:(NSString *)text;

+ (TTTAttributedLabel *)createSizeFitWhiteTTTLabelWithText:(NSString *)text textColor:(UIColor *)textColor;


+ (TTTAttributedLabel *)createSizeFortTTTLabelWithText:(NSString *)text font:(UIFont *)font;
+ (CGFloat)HeightForView:(id)view bottom:(UIView*)bottom offset:(CGFloat)offset;

+ (TTTAttributedLabel *)createSizeFortTTTLabelWithLeftText:(NSString *)text font:(UIFont *)font;

+ (TTTAttributedLabel *)createSizeFortTTTLabelWithRightText:(NSString *)text font:(UIFont *)font;
#pragma mark - 生成字符串
// 生成唯一标示符
+ (NSString *)createUniqueString;

// 生成随机字符串
+ (NSString *)createRandomString:(NSInteger)length;

+ (BOOL)NavigationLoginView:(UIViewController*)view;

//+(BOOL)NavigationLoginView:(UIViewController*)view registerSucessBlock:(RegisterSucessBlock)registerSucessBlock;

+ (NSString*)remainingTimeMethodAction:(long long)endTime;

+(BOOL)NavigationLoginOrRegView:(UIViewController*)view LoginOrReg:(BOOL)state;

+(BOOL)NavMessageCenter:(UIViewController*)rootview;

+(void)initNav:(UIViewController*)rootview action:(SEL)action;

+(UIFont*)customFontsize:(CGFloat)fontSize;
//获取主色调
+(UIColor*)mostColor:(UIImage*)image;

+(void)addTextField:(CGRect)rect delegate:(id)delegate text:(NSString*)text textField:(UITextField *)textField view:(UIView *)view font:(UIFont *)font holdercolor:(UIColor*) color;

+(void)addLabel:(CGRect)rect title:(NSString *)title font:(UIFont *)font view:(UIView *)view align:(NSTextAlignment)align color:(UIColor *)color;

+  (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

+(void)addCommodityMode;

+(NSArray*)randomArray:(NSMutableArray*)source count:(NSInteger)count;

+(void) pushURLString:(NSString*)url view:(UIViewController*)view;
+(void) pushURLString:(NSString*)url;

+(UIColor *)getColor:(NSString *)cString;

+(float)calculationStringLenght:(NSString *)fullDescAndTagStr Wight:(int)labelWidth;
@end


@interface LGGuangDianTong: NSObject
+ (void)send ;


@end
