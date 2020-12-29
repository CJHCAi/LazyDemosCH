//
//  SCNSString+Utils.m
//  SeaCat_IOS
//
//  Created by reganan on 15/5/5.
//  Copyright (c) 2015年 reganan. All rights reserved.
//

#import "SCNSString+Utils.h"
#import<CommonCrypto/CommonDigest.h>

@implementation NSString (SCUtils)

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}
- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

//验证email
-(BOOL)isValidateEmail {
    
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [predicate evaluateWithObject:self];
    
}

//验证电话号码
-(BOOL)isValidateTelNumber{
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
// 正则判断手机号码地址格式
- (BOOL)isMobileNumber{
    
    //    /**
    //     * 手机号码
    //     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    //     * 联通：130,131,132,152,155,156,185,186
    //     * 电信：133,1349,153,180,189
    //     */
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    //    /**
    //     10         * 中国移动：China Mobile
    //     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    //     12         */
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //    /**
    //     15         * 中国联通：China Unicom
    //     16         * 130,131,132,152,155,156,185,186
    //     17         */
    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //    /**
    //     20         * 中国电信：China Telecom
    //     21         * 133,1349,153,180,189
    //     22         */
    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    //    /**
    //     25         * 大陆地区固话及小灵通
    //     26         * 区号：010,020,021,022,023,024,025,027,028,029
    //     27         * 号码：七位或八位
    //     28         */
    //    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    //
    //    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
    //        || ([regextestcm evaluateWithObject:mobileNum] == YES)
    //        || ([regextestct evaluateWithObject:mobileNum] == YES)
    //        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    //    {
    //        if([regextestcm evaluateWithObject:mobileNum] == YES) {
    //            NSLog(@"China Mobile");
    //        } else if([regextestct evaluateWithObject:mobileNum] == YES) {
    //            NSLog(@"China Telecom");
    //        } else if ([regextestcu evaluateWithObject:mobileNum] == YES) {
    //            NSLog(@"China Unicom");
    //        } else {
    //            NSLog(@"Unknow");
    //        }
    //
    //        return YES;
    //    }
    //    else
    //    {
    //        return NO;
    //    }
    NSString *strRegex = @"^((13[0-9])|(147)|(170)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumber
{
    NSString *strRegex = @"“^[0-9]*$”";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    return [predicate evaluateWithObject:self];
    
}

-(CGSize)sizeWithFont:(UIFont *)f maxWidth:(CGFloat)w
{
    //设置文本范围。200代表宽度最大为200，到了200则换到下一行；MAXFLOAT代表长度不限
    CGSize s = CGSizeMake(w, MAXFLOAT);
    
    　　//需跟lable字体大小一直，否则会显示不全等问题
    NSDictionary *attr=@{NSFontAttributeName:f};
    
    return [self boundingRectWithSize:s
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attr
                              context:nil].size;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isString
{
    return [self isKindOfClass:[NSString class]];
}

- (BOOL)isEmpty
{
    return !self || !self.length;
}
//- (NSString *) sha1_base64
//{
//    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:self.length];
//
//    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
//
//    CC_SHA1(data.bytes, data.length, digest);
//
//    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
//    base64 = [GTMBase64 encodeData:base64];
//
//    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
//    return output;
//}
//
//- (NSString *) md5_base64
//{
//    const char *cStr = [self UTF8String];
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5( cStr, strlen(cStr), digest );
//
//    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
//    base64 = [GTMBase64 encodeData:base64];
//
//    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
//    return output;
//}
//
//- (NSString *) base64
//{
//    NSData * data = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    data = [GTMBase64 encodeData:data];
//    NSString * output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return output;
//}

@end
