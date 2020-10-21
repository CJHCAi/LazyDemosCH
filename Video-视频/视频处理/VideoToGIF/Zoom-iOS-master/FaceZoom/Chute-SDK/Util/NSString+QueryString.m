//
//  NSString+QueryString.m
//  LROAuth2Client
//
//  Created by Luke Redpath on 14/05/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "NSString+QueryString.h"

@implementation NSString (QueryString)

- (NSString*)stringByEscapingForURLQuery
{
    return [self stringURLEncodedForQuery:YES];
}

- (NSString *)stringByEscapingForURL
{
    return [self stringURLEncodedForQuery:NO];
}

- (NSString*)stringByUnescapingFromURLQuery
{
    return [[self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

- (NSString *)stringURLEncodedForQuery:(BOOL)isQuery
{
    NSString *result = self;
    
    CFStringRef originalAsCFString = (__bridge  CFStringRef) self;
    CFStringRef leaveAlone = isQuery ? CFSTR(" ") : nil;
    CFStringRef toEscape = isQuery ? CFSTR("\n\r?[]()$,!'*;:@&=#%+/") : CFSTR("\n\r?[]()$,!'*;:@&=#%+/ ");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, originalAsCFString, leaveAlone, toEscape, kCFStringEncodingUTF8);
    
    if (escapedStr) {
        NSMutableString *mutable = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        [mutable replaceOccurrencesOfString:@" " withString:@"+" options:0 range:NSMakeRange(0, [mutable length])];
        result = mutable;
    }
    return result;
}

@end
