#import "NSString+DDYExtension.h"
#import <CommonCrypto/CommonDigest.h> // MD5/SHA256加密
#import <CommonCrypto/CommonHMAC.h> // SHA265后台对Key加密
#import "keccak.h" // SHA3加密
#import <AdSupport/ASIdentifierManager.h> //IDFA
#import <sys/utsname.h> // 获取系统型号
#import <AVFoundation/AVFoundation.h> // 音量
#import <SystemConfiguration/CaptiveNetwork.h> //wifiSSID
#import <CoreTelephony/CTTelephonyNetworkInfo.h> // 网络制式
#import <CoreTelephony/CTCarrier.h>
#import <sys/ioctl.h> // ip 地址
#import <net/if.h>
#import <arpa/inet.h>
#import <sys/stat.h> // 越狱
#import <dlfcn.h>

@implementation NSString (DDYExtension)

#pragma mark 沙盒documents路径
+ (NSString *)ddy_DocumentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

#pragma mark 沙盒cache路径
+ (NSString *)ddy_CachePath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

#pragma mark 沙盒library路径
+ (NSString *)ddy_LibraryPath{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

#pragma mark bundleName (show in SpringBoard)
+ (NSString *)ddy_AppBundleName{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

#pragma mark bundleID com.**.app
+ (NSString *)ddy_AppBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

#pragma mark 版本号 1.1.1
+ (NSString *)ddy_AppVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

#pragma mark build 号 111
+ (NSString *)ddy_AppBuildNumber {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

#pragma mark 获取IDFA
+ (NSString *)ddy_IDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

#pragma mark 获取IDFV
+ (NSString *)ddy_IDFV {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

#pragma mark 获取UUID
+ (NSString *)ddy_UUID {
    return [[NSUUID UUID] UUIDString];
}

#pragma mark 系统版本
+ (NSString *)ddy_SystemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark 获取设备型号
+ (NSString *)ddy_DeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if([deviceString isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if([deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if([deviceString isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if([deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if([deviceString isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if([deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

#pragma mark 获取设备名字
+ (NSString *)ddy_DeviceName {
    return [UIDevice currentDevice].name;
}

#pragma mark 获取磁盘大小
+ (long)ddy_DiskTotalSize {
    NSDictionary *systemAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *diskTotalSize = [systemAttributes objectForKey:NSFileSystemSize];
    return (long)(diskTotalSize.floatValue / 1024.f / 1024.f);
}

#pragma mark wifi名称
+ (NSString *)ddy_WifiSSID {
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    
    return [dctySSID objectForKey:@"SSID"];
}

#pragma mark 网络制式
+ (NSString *)ddy_NetCarrier {
    NSString *mobileCarrier;
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSString *MCC = carrier.mobileCountryCode;
    NSString *MNC = carrier.mobileNetworkCode;
    
    if (!MCC || !MNC) {
        mobileCarrier = @"No Sim";
    } else {
        if ([MCC isEqualToString:@"460"]) {
            if ([MNC isEqualToString:@"00"] || [MNC isEqualToString:@"02"] || [MNC isEqualToString:@"07"]) {
                mobileCarrier = @"China Mobile";
            } else if ([MNC isEqualToString:@"01"] || [MNC isEqualToString:@"06"]) {
                mobileCarrier = @"China Unicom";
            } else if ([MNC isEqualToString:@"03"] || [MNC isEqualToString:@"05"] || [MNC isEqualToString:@"11"]) {
                mobileCarrier = @"China Telecom";
            } else if ([MNC isEqualToString:@"20"]) {
                mobileCarrier = @"China Tietong";
            } else {
                mobileCarrier = [NSString stringWithFormat:@"MNC%@", MNC];
            }
        } else {
            mobileCarrier = @"Foreign Carrier";
        }
    }
    return mobileCarrier;
}

#pragma mark 获取内网ip地址
+ (NSString *)ddy_WANIPAddress {
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) return nil;
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    close(sockfd);
    return ips.lastObject;
}

#pragma mark 获取外网ip地址
+ (NSString *)ddy_InternetIPAddress {
    // 请求url
    NSURL *url = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *mString = [NSMutableString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    // 判断返回字符串是否为所需数据
    if ([mString hasPrefix:@"var returnCitySN = "]) {
        // 对字符串进行处理，获取json数据
        [mString deleteCharactersInRange:NSMakeRange(0, 19)];
        NSString *jsonStr = [mString substringToIndex:mString.length - 1];
        // 对Json字符串进行Json解析
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dict[@"cip"];
    }
    return nil;
}

#pragma mark 过滤掉空格和某些特殊字符
+ (NSString *)ddy_TrimWhitespace:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark 判断空字符串
+ (BOOL)ddy_blankString:(NSString *)string {
    if (string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [self ddy_TrimWhitespace:string]==0) {
        return YES;
    }
    return NO;
}

#pragma makr 时间date转字符串
+ (NSString *)ddy_DateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark 数据data转字符串
+ (NSString *)ddy_DataToString:(NSData *)data{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str ? str : [[NSString alloc] initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
}

#pragma mark 字符串转数据data
- (NSData *)ddy_StringToData {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark Unicode字符串转常规字符串
- (NSString *)ddy_UnicodeToString {
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:nil error:nil];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

#pragma mark 汉字转拼音  http://www.olinone.com/?p=131
- (NSString *)ddy_ChangeToPinYin {
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark URL特殊符号编码
- (NSString *)ddy_URLEncode {
    NSString *resultStr = self;
    CFStringRef originalString = (__bridge CFStringRef)self;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, originalString, leaveUnescaped, forceEscaped, kCFStringEncodingUTF8);
    if( escapedStr) {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        [mutableStr replaceOccurrencesOfString:@" " withString:@"%20" options:0 range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    return resultStr;
}

#pragma mark 判断是否含有汉字
- (BOOL)ddy_IncludeChinese {
    for(int i = 0; i < [self length]; i++) {
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

#pragma mark 判断是否是纯汉字 https://blog.csdn.net/laokaizzz/article/details/43342285
- (BOOL)ddy_OnlyChinese {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

#pragma mark MD5
- (NSString *)ddy_MD5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

#pragma mark SHA256加密 http://www.jianshu.com/p/157d84c2d020
- (NSString *)ddy_SHA256 {
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

#pragma mark SHA256加密data */
+ (NSString *)ddy_SHA256WithData:(NSData *)data {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

#pragma mark SHA265加密 后台对key加密
- (NSString *)ddy_SHA256WithKey:(NSString *)key {
    const char *cKey  = [key  cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [self cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    return HMAC;
}

#pragma mark SHA3 Keccak-256加密 bitsLength:224/256/384/512
- (NSString *)ddy_SHA3:(NSUInteger)bitsLength {
    int bytes = (int)(bitsLength/8);
    const char * string = [self cStringUsingEncoding:NSUTF8StringEncoding];
    int size=(int)strlen(string);
    uint8_t md[bytes];
    keccak((uint8_t*)string, size, md, bytes);
    NSMutableString *sha3 = [[NSMutableString alloc] initWithCapacity:bitsLength/4];
    
    for(int32_t i=0;i<bytes;i++)
        [sha3 appendFormat:@"%02X", md[i]];
    return sha3;
}

#pragma mark 是否只包含给定字符串中字符
- (BOOL)ddy_OnlyHasCharacterOfString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:string] invertedSet];
    NSString *filter = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filter];
}

#pragma mark 浮点数字符串合法性 https://www.cnblogs.com/GJ-ios/p/5483462.html
- (BOOL)ddy_EffectFloatString {
    // 正则匹配整数或浮点数 0.0合法 0.00000不合法
    NSString *regex = @"^-?([1-9]d*|[1-9]d*.d*|0.d*[1-9]d*|0?.0+|0)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

/**
 NSJSONReadingMutableContainers = (1UL << 0), // 返回的是一个可变数组或者字段
 NSJSONReadingMutableLeaves = (1UL << 1), // 不仅返回的最外层是可变的, 内部的子数值或字典也是可变对象
 NSJSONReadingAllowFragments = (1UL << 2) // 返回的最外侧可不是字典或者数组 可以是如 "10"
 */
#pragma mark 字典/数组转json字符串
+ (NSString *)ddy_ArrayOrDictToJsonString:(id)obj {
    if (!obj) {
        return nil;
    }
    if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

#pragma mark json字符串转数组或者字典
- (id)ddy_JsonStringToArrayOrDict {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        return nil;
    }
    return obj;
}

#pragma mark json字符串转字典
- (NSDictionary *)ddy_JsonStringToDict {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        return nil;
    }
    return dict;
}

#pragma mark json字符串转数组
- (NSArray *)ddy_JsonStringToArray {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        return nil;
    }
    return array;
}

#pragma mark 将16进制的字符串转换成NSData
- (NSMutableData *)ddy_HexStrToData {
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([self length] %2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [self length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [self substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

#pragma mark 计算文本size
- (CGSize)sizeWithMaxWidth:(CGFloat)width font:(UIFont *)font {
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *dict = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

@end
