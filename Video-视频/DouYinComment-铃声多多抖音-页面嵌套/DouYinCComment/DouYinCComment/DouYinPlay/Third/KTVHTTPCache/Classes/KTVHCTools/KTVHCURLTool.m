//
//  KTVHCURLTool.m
//  KTVHTTPCache
//
//  Created by Single on 2017/8/10.
//  Copyright © 2017年 Single. All rights reserved.
//

#import "KTVHCURLTool.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation KTVHCURLTool

+ (instancetype)tool
{
    static KTVHCURLTool *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

- (NSString *)keyWithURL:(NSURL *)URL
{
    if (self.URLConverter && URL.absoluteString.length > 0) {
        NSURL *newURL = self.URLConverter(URL);
        if (newURL.absoluteString.length > 0) {
            URL = newURL;
        }
    }
    return [self md5:URL.absoluteString];
}

- (NSString *)md5:(NSString *)URLString
{
    const char *value = [URLString UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    return outputString;
}

- (NSString *)base64Encode:(NSString *)URLString
{
    NSData *data = [URLString dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64Decode:(NSString *)URLString
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:URLString options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)URLEncode:(NSString *)URLString
{
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger length = [URLString length];
    const char *c = [URLString UTF8String];
    NSString *resultString = @"";
    for(int i = 0; i < length; i++) {
        @autoreleasepool {
            switch (*c) {
                case '/':
                    resultString = [resultString stringByAppendingString:@"%2F"];
                    break;
                case '\'':
                    resultString = [resultString stringByAppendingString:@"%27"];
                    break;
                case ';':
                    resultString = [resultString stringByAppendingString:@"%3B"];
                    break;
                case '?':
                    resultString = [resultString stringByAppendingString:@"%3F"];
                    break;
                case ':':
                    resultString = [resultString stringByAppendingString:@"%3A"];
                    break;
                case '@':
                    resultString = [resultString stringByAppendingString:@"%40"];
                    break;
                case '&':
                    resultString = [resultString stringByAppendingString:@"%26"];
                    break;
                case '=':
                    resultString = [resultString stringByAppendingString:@"%3D"];
                    break;
                case '+':
                    resultString = [resultString stringByAppendingString:@"%2B"];
                    break;
                case '$':
                    resultString = [resultString stringByAppendingString:@"%24"];
                    break;
                case ',':
                    resultString = [resultString stringByAppendingString:@"%2C"];
                    break;
                case '[':
                    resultString = [resultString stringByAppendingString:@"%5B"];
                    break;
                case ']':
                    resultString = [resultString stringByAppendingString:@"%5D"];
                    break;
                case '#':
                    resultString = [resultString stringByAppendingString:@"%23"];
                    break;
                case '!':
                    resultString = [resultString stringByAppendingString:@"%21"];
                    break;
                case '(':
                    resultString = [resultString stringByAppendingString:@"%28"];
                    break;
                case ')':
                    resultString = [resultString stringByAppendingString:@"%29"];
                    break;
                case '*':
                    resultString = [resultString stringByAppendingString:@"%2A"];
                    break;
                default:
                    resultString = [resultString stringByAppendingFormat:@"%c", *c];
            }
            c++;
        }
    }
    return resultString;
}

- (NSString *)URLDecode:(NSString *)URLString
{
    return [URLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary<NSString *,NSString *> *)parseQuery:(NSString *)query
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:query];
    [scanner setCharactersToBeSkipped:nil];
    while (1) {
        NSString *key = nil;
        if (![scanner scanUpToString:@"=" intoString:&key] || [scanner isAtEnd]) {
            break;
        }
        [scanner setScanLocation:([scanner scanLocation] + 1)];
        NSString *value = nil;
        [scanner scanUpToString:@"&" intoString:&value];
        if (value == nil) {
            value = @"";
        }
        key = [key stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        NSString *unescapedKey = key ? [self URLDecode:key] : nil;
        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        NSString *unescapedValue = value ? [self URLDecode:value] : nil;
        if (unescapedKey && unescapedValue) {
            [parameters setObject:unescapedValue forKey:unescapedKey];
        }
        if ([scanner isAtEnd]) {
            break;
        }
        [scanner setScanLocation:([scanner scanLocation] + 1)];
    }
    return parameters;
}

@end
