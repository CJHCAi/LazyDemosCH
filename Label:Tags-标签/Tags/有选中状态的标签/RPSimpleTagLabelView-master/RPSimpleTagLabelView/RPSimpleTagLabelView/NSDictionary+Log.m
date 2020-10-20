//
//  NSDictionary+Log.m
//  RPSimpleTagLabelView
//
//  Created by 李翩翩 on 2019/9/3.
//  Copyright © 2019 Tao. All rights reserved.
//

#import "NSDictionary+Log.h"
@implementation NSDictionary (Log)
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"\t%@", key];
        [string appendString:@" : "];
        [string appendFormat:@"%@,\n", obj];
    }];
    [string appendString:@"}"];
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound )
        [string deleteCharactersInRange:range];
    
    return string;
}
@end
@implementation NSArray (Log)
- (NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"[\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [string appendFormat:@"\t%@,\n", obj];
    }];
    [string appendString:@"]"];
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [string deleteCharactersInRange:range];
    
    return string;
}
@end

