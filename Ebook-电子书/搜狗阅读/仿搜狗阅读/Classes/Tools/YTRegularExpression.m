//
//  YTRegularExpression.m
//  每日烹
//
//  Created by Mac on 16/5/1.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTRegularExpression.h"

@implementation YTRegularExpression

+(NSString *)getRealMessageWithStr:(NSString *)str pattern:(NSString *)pattern{
    NSString *realStr = @"";

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];


    NSArray *matchs = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    for (NSTextCheckingResult *match in matchs) {
    NSRange matchRange = [match range];
    // result  是  >xxxx<形式的
    NSString *result = [str substringWithRange:matchRange];
    //裁剪掉首尾 的  ‘>’   '<'
    NSRange realRange = NSMakeRange(1, ([result length]-3));
    
    realStr = [realStr stringByAppendingString:[result substringWithRange:realRange]];
    realStr = [realStr stringByAppendingString:@"\n\n"];


    }
    return realStr;
}

+(NSString *)handleImagesUrlstr:(NSString *)imagesUrlStr pattern:(NSString *)pattern{
//  /cook/080500/656ef44248a34cbf417d4ecc22c3498a.jpg,/cook/080500/656ef44248a34cbf417d4ecc22c3498a.jpg
    //两端路径是一样的，所以只返回一段

    NSError *error = NULL;
    NSString *result = [[NSString alloc]init];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matchs = [regex matchesInString:imagesUrlStr options:0 range:NSMakeRange(0, [imagesUrlStr length])];
    for (NSTextCheckingResult *match in matchs) {
        NSRange matchRange = [match range];
        result = [result stringByAppendingString:[imagesUrlStr substringWithRange:matchRange]];
        if (result) {
            break;
        }
    }

     return result;
}
+(NSMutableArray *)getListMaterialWithMsgStr:(NSString *)str pattern:(NSString *)pattern{
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        NSMutableArray *ResultArr = [NSMutableArray array];
        NSArray *matchs = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
        for (NSTextCheckingResult *match in matchs) {
            NSRange matchRange = [match range];
            // result  是  >xxxx<形式的
            NSString *result = [str substringWithRange:matchRange];
            //裁剪掉首尾 的  ‘>’   '<'
            NSRange realRange = NSMakeRange(1, ([result length]-3));
    
            [ResultArr addObject: [result substringWithRange:realRange]];
            
    
    
            }
    return ResultArr;
}

+ (NSString *)getChapter:(NSString *)defaultStr pattern:(NSString *)pattern{
    NSString *realContent = [[NSString alloc]init];
    NSError *error = NULL;
    NSString *result = [[NSString alloc]init];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matchs = [regex matchesInString:defaultStr options:0 range:NSMakeRange(0, [defaultStr length])];
    for (NSTextCheckingResult *match in matchs) {
        NSRange matchRange = [match range];
        result = [result stringByAppendingString:[defaultStr substringWithRange:matchRange]];
        if (result) {
            break;
        }
    }
    //result是正则表达式包含的部分，我们需要的是不包含的那部分
    realContent = [defaultStr substringFromIndex:result.length];
    return realContent;
}
@end
