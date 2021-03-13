#import "UIColor+DDYExtension.h"
#import "NSString+DDYExtension.h"

@implementation UIColor (DDYExtension)

static inline NSUInteger hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

#pragma mark 16进制color
+ (UIColor *)ddy_ColorWithHexString:(NSString *)hexString {
    if ([NSString ddy_blankString:hexString]) return nil;
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    } else if ([hexString hasPrefix:@"0X"] || [hexString hasPrefix:@"0x"]) {
        hexString = [hexString substringFromIndex:2];
    }
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[A-Fa-f0-9]+$"] evaluateWithObject:hexString]) return nil;
    if (hexString.length != 3 && hexString.length != 4 && hexString.length != 6 && hexString.length != 8) return nil;
    if (hexString.length < 5) {
        return [UIColor ddy_ColorIntR:hexStrToInt([hexString substringWithRange:NSMakeRange(0, 1)])
                             g:hexStrToInt([hexString substringWithRange:NSMakeRange(1, 1)])
                             b:hexStrToInt([hexString substringWithRange:NSMakeRange(2, 1)])
                             a:hexString.length == 4 ? hexStrToInt([hexString substringWithRange:NSMakeRange(3, 1)]) : 255.];
    } else {
        return [UIColor ddy_ColorIntR:hexStrToInt([hexString substringWithRange:NSMakeRange(0, 2)])
                             g:hexStrToInt([hexString substringWithRange:NSMakeRange(2, 2)])
                             b:hexStrToInt([hexString substringWithRange:NSMakeRange(4, 2)])
                             a:hexString.length == 4 ? hexStrToInt([hexString substringWithRange:NSMakeRange(6, 2)]) : 255.];
    }
    return nil;
}

+ (UIColor *)ddy_ColorFloatR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a {
   return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (UIColor *)ddy_ColorIntR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b a:(NSInteger)a {
    return [UIColor ddy_ColorFloatR:r/255. g:g/255. b:b/255. a:a/255.];
}

@end
