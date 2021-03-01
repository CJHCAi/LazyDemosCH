//
//  ComposeTextParser.m
//  HTMLDescription
//
//  Created by 刘继新 on 2017/9/12.
//  Copyright © 2017年 TopsTech. All rights reserved.
//

#import "ComposeTextParser.h"

@implementation ComposeTextParser

- (BOOL)parseText:(nullable NSMutableAttributedString *)text selectedRange:(nullable NSRangePointer)selectedRange {
    [text yy_setColor:[UIColor blackColor] range:text.yy_rangeOfAll];
    NSArray *urlResults = [[self regexURL] matchesInString:text.string options:kNilOptions range:text.yy_rangeOfAll];
    NSInteger urlIndex = 0;
    for (NSTextCheckingResult *url in urlResults) {
        if (url.range.location == NSNotFound && url.range.length <= 1) continue;
        if ((url.range.location + url.range.length) > text.length) continue;
        NSString *urlStr = [text.string substringWithRange:url.range];
        [text yy_setColor:[UIColor blueColor] range:url.range];
        
        if (![urlStr isEqualToString:self.parserURL] && 0 == urlIndex) {
            self.parserURL = urlStr;
            if ([self.delegate respondsToSelector:@selector(composeTextParser:discoverURL:)]) {
                [self.delegate composeTextParser:self discoverURL:urlStr];
            }
        }
        urlIndex ++;
    }
    return YES;
}

- (NSRegularExpression *)regexURL {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"(([hH]ttp[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:kNilOptions error:NULL];
    });
    return regex;
}

@end
