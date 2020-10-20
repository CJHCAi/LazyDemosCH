//
//  Utils.m
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//

#import "Utils.h"


@implementation Utils

+ (NSString*)iphoneModels {
    
    //需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone1,1"]) return@"iPhone 2G";
    if([platform isEqualToString:@"iPhone1,2"]) return@"iPhone 3G";
    if([platform isEqualToString:@"iPhone2,1"]) return@"iPhone 3GS";
    if([platform isEqualToString:@"iPhone3,1"]) return@"iPhone 4";
    if([platform isEqualToString:@"iPhone3,2"]) return@"iPhone 4";
    if([platform isEqualToString:@"iPhone3,3"]) return@"iPhone 4";
    if([platform isEqualToString:@"iPhone4,1"]) return@"iPhone 4S";
    if([platform isEqualToString:@"iPhone5,1"]) return@"iPhone 5";
    if([platform isEqualToString:@"iPhone5,2"]) return@"iPhone 5";
    if([platform isEqualToString:@"iPhone5,3"]) return@"iPhone 5c";
    if([platform isEqualToString:@"iPhone5,4"]) return@"iPhone 5c";
    if([platform isEqualToString:@"iPhone6,1"]) return@"iPhone 5s";
    if([platform isEqualToString:@"iPhone6,2"]) return@"iPhone 5s";
    if([platform isEqualToString:@"iPhone7,1"]) return@"iPhone 6 Plus";
    if([platform isEqualToString:@"iPhone7,2"]) return@"iPhone 6";
    if([platform isEqualToString:@"iPhone8,1"]) return@"iPhone 6s";
    if([platform isEqualToString:@"iPhone8,2"]) return@"iPhone 6s Plus";
    if([platform isEqualToString:@"iPhone8,4"]) return@"iPhone SE";
    if([platform isEqualToString:@"iPhone9,1"]) return@"iPhone 7";
    if([platform isEqualToString:@"iPhone9,2"]) return@"iPhone 7 Plus";
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    if([platform isEqualToString:@"iPod1,1"]) return@"iPod Touch 1G";
    if([platform isEqualToString:@"iPod2,1"]) return@"iPod Touch 2G";
    if([platform isEqualToString:@"iPod3,1"]) return@"iPod Touch 3G";
    if([platform isEqualToString:@"iPod4,1"]) return@"iPod Touch 4G";
    if([platform isEqualToString:@"iPod5,1"]) return@"iPod Touch 5G";
    if([platform isEqualToString:@"iPad1,1"]) return@"iPad 1G";
    if([platform isEqualToString:@"iPad2,1"]) return@"iPad 2";
    if([platform isEqualToString:@"iPad2,2"]) return@"iPad 2";
    if([platform isEqualToString:@"iPad2,3"]) return@"iPad 2";
    if([platform isEqualToString:@"iPad2,4"]) return@"iPad 2";
    if([platform isEqualToString:@"iPad2,5"]) return@"iPad Mini 1G";
    if([platform isEqualToString:@"iPad2,6"]) return@"iPad Mini 1G";
    if([platform isEqualToString:@"iPad2,7"]) return@"iPad Mini 1G";
    if([platform isEqualToString:@"iPad3,1"]) return@"iPad 3";
    if([platform isEqualToString:@"iPad3,2"]) return@"iPad 3";
    if([platform isEqualToString:@"iPad3,3"]) return@"iPad 3";
    if([platform isEqualToString:@"iPad3,4"]) return@"iPad 4";
    if([platform isEqualToString:@"iPad3,5"]) return@"iPad 4";
    if([platform isEqualToString:@"iPad3,6"]) return@"iPad 4";
    if([platform isEqualToString:@"iPad4,1"]) return@"iPad Air";
    if([platform isEqualToString:@"iPad4,2"]) return@"iPad Air";
    if([platform isEqualToString:@"iPad4,3"]) return@"iPad Air";
    if([platform isEqualToString:@"iPad4,4"]) return@"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,5"]) return@"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,6"]) return@"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,7"]) return@"iPad Mini 3";
    if([platform isEqualToString:@"iPad4,8"]) return@"iPad Mini 3";
    if([platform isEqualToString:@"iPad4,9"]) return@"iPad Mini 3";
    if([platform isEqualToString:@"iPad5,1"]) return@"iPad Mini 4";
    if([platform isEqualToString:@"iPad5,2"]) return@"iPad Mini 4";
    if([platform isEqualToString:@"iPad5,3"]) return@"iPad Air 2";
    if([platform isEqualToString:@"iPad5,4"]) return@"iPad Air 2";
    if([platform isEqualToString:@"iPad6,3"]) return@"iPad Pro 9.7";
    if([platform isEqualToString:@"iPad6,4"]) return@"iPad Pro 9.7";
    if([platform isEqualToString:@"iPad6,7"]) return@"iPad Pro 12.9";
    if([platform isEqualToString:@"iPad6,8"]) return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"]) return@"iPhone Simulator";
    if([platform isEqualToString:@"x86_64"]) return@"iPhone Simulator";
    return platform;
    
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(CGSize)withString:(NSString *)string font:(UIFont *)font
{
    
    CGSize LabelSize;
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0)
    {
        LabelSize=[string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //ios7 以下
        LabelSize=[string sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
#pragma clang diagnostic pop
    }
    
    return LabelSize;
}

+(CGSize)withString:(NSString *)string font:(UIFont *)font ViewWidth:(float)Width
{
    CGSize LabelSize;
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0)
    {
        LabelSize=[string boundingRectWithSize:CGSizeMake(Width, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //ios7 以下
        LabelSize=[string sizeWithFont:font constrainedToSize:CGSizeMake(Width, MAXFLOAT)];
#pragma clang diagnostic pop
    }
    
    return LabelSize;
    
}
@end
